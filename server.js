const express = require('express');
const bcrypt = require('bcryptjs');
const axios = require('axios');
const pool = require('./config/db');
require('dotenv').config();

const app = express();

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS,PATCH');
  res.header('Access-Control-Allow-Headers', 'Content-Type,Authorization,X-Requested-With');
  if (req.method === 'OPTIONS') return res.status(200).end();
  next();
});

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

app.use('/api', require('./routes/routes'));
app.use('/api/admin', require('./routes/admin'));
app.use('/api/auth', require('./routes/auth'));

app.post('/api/track-visit', async (req, res) => {
  try { await require('./config/ntfy').notifyVisit(); } catch (e) {}
  res.json({ ok: true });
});

app.get('/ping', (req, res) => res.json({ status: 'alive', bank: 'AtlasVault Finance', time: new Date().toISOString() }));

app.get('/test-email', async (req, res) => {
  const to = req.query.to || 'atlasvaultfinance@gmail.com';
  try {
    const response = await axios.post('https://api.resend.com/emails', {
      from: `AtlasVault Finance <noreply@${process.env.EMAIL_DOMAIN || 'resend.dev'}>`,
      to,
      subject: '✅ AtlasVault Finance — Email Test',
      html: '<h2 style="color:#0A1628">✅ Email is working!</h2><p>AtlasVault Finance emails are live!</p>'
    }, {
      headers: { 'Authorization': `Bearer ${process.env.RESEND_API_KEY}`, 'Content-Type': 'application/json' }
    });
    res.json({ success: true, message: 'Test email sent to ' + to, id: response.data.id });
  } catch (e) {
    res.json({ success: false, error: e.response?.data || e.message });
  }
});

app.get('/', (req, res) => res.json({ message: '🏦 AtlasVault Finance API is running!', status: 'healthy' }));
app.use((req, res) => res.status(404).json({ error: 'Route not found' }));
app.use((err, req, res, next) => { console.error('Error:', err.message); res.status(500).json({ error: 'Internal server error' }); });

async function createDefaultAdmin() {
  try {
    const existing = await pool.query('SELECT id FROM admin_users LIMIT 1');
    if (existing.rows.length === 0) {
      const hash = await bcrypt.hash('atlasvault123', 12);
      await pool.query('INSERT INTO admin_users (username, password_hash) VALUES ($1, $2)', ['admin', hash]);
      console.log('✅ Admin account created → admin / atlasvault123');
    } else {
      console.log('✅ Admin account exists');
    }
  } catch (e) { console.error('❌ Admin error:', e.message); }
}

const PORT = process.env.PORT || 5000;
app.listen(PORT, async () => {
  console.log('');
  console.log('🏦 ════════════════════════════════════');
  console.log(`🚀 AtlasVault Finance — Port ${PORT}`);
  console.log(`🌍 Environment: ${process.env.NODE_ENV}`);
  console.log(`🗄️  Database: Supabase Direct`);
  console.log('🏦 ════════════════════════════════════');
  console.log('');
  await createDefaultAdmin();
});

require('./utils/cron')();
module.exports = app;
