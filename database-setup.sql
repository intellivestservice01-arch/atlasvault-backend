-- =============================================
-- BluePeak Finance - Complete Database Setup
-- Run this in Supabase SQL Editor
-- =============================================

CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(100),
  middle_name VARCHAR(100),
  last_name VARCHAR(100),
  username VARCHAR(100) UNIQUE,
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(50),
  date_of_birth DATE,
  country VARCHAR(100),
  address TEXT,
  password_hash TEXT,
  transaction_pin TEXT,
  account_number VARCHAR(20) UNIQUE,
  account_type VARCHAR(50) DEFAULT 'checking',
  currency VARCHAR(20) DEFAULT 'USD',
  preferred_currency VARCHAR(20) DEFAULT 'USD',
  balance NUMERIC(20,2) DEFAULT 0.00,
  kyc_status VARCHAR(50) DEFAULT 'unverified',
  is_active BOOLEAN DEFAULT true,
  is_email_verified BOOLEAN DEFAULT false,
  referral_code VARCHAR(50),
  profile_photo TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS email_verifications (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255),
  code VARCHAR(10),
  expires_at TIMESTAMP,
  is_used BOOLEAN DEFAULT false,
  attempts INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS password_resets (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255),
  code VARCHAR(10),
  expires_at TIMESTAMP,
  is_used BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS exchange_rates (
  id SERIAL PRIMARY KEY,
  base_currency VARCHAR(20) DEFAULT 'USD',
  target_currency VARCHAR(20),
  rate NUMERIC(20,6),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS transactions (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  type VARCHAR(50),
  amount NUMERIC(20,2),
  currency VARCHAR(20) DEFAULT 'USD',
  status VARCHAR(50) DEFAULT 'pending',
  reference_id VARCHAR(100) UNIQUE,
  description TEXT,
  scope VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS deposits (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  amount NUMERIC(20,2),
  currency VARCHAR(20) DEFAULT 'USD',
  method VARCHAR(100),
  status VARCHAR(50) DEFAULT 'pending',
  reference_id VARCHAR(100),
  admin_note TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS withdrawal_sessions (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  amount NUMERIC(20,2),
  currency VARCHAR(20) DEFAULT 'USD',
  account_number VARCHAR(100),
  account_name VARCHAR(255),
  bank_name VARCHAR(255),
  transfer_type VARCHAR(100),
  current_step INT DEFAULT 1,
  exchange_fee_code VARCHAR(20),
  exchange_fee_used BOOLEAN DEFAULT false,
  withdrawal_fee_code VARCHAR(20),
  withdrawal_fee_used BOOLEAN DEFAULT false,
  vat_code VARCHAR(20),
  vat_used BOOLEAN DEFAULT false,
  imf_code VARCHAR(20),
  imf_used BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS withdrawals (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  amount NUMERIC(20,2),
  currency VARCHAR(20) DEFAULT 'USD',
  account_number VARCHAR(100),
  account_name VARCHAR(255),
  bank_name VARCHAR(255),
  transfer_type VARCHAR(100),
  reference_id VARCHAR(100),
  status VARCHAR(50) DEFAULT 'pending',
  admin_note TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS local_transfers (
  id SERIAL PRIMARY KEY,
  sender_id INT REFERENCES users(id),
  recipient_account VARCHAR(100),
  recipient_name VARCHAR(255),
  bank_name VARCHAR(255),
  transfer_type VARCHAR(100),
  amount NUMERIC(20,2),
  sender_currency VARCHAR(20) DEFAULT 'USD',
  description TEXT,
  status VARCHAR(50) DEFAULT 'pending',
  reference_id VARCHAR(100),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS international_transfers (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  method VARCHAR(100),
  amount NUMERIC(20,2),
  currency VARCHAR(20) DEFAULT 'USD',
  recipient_name VARCHAR(255),
  account_wallet VARCHAR(255),
  country VARCHAR(100),
  description TEXT,
  reference_id VARCHAR(100),
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS kyc_verifications (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  full_name VARCHAR(255),
  email VARCHAR(255),
  phone VARCHAR(50),
  title VARCHAR(50),
  gender VARCHAR(50),
  zipcode VARCHAR(50),
  date_of_birth DATE,
  ssn VARCHAR(100),
  account_type VARCHAR(100),
  employment_type VARCHAR(100),
  annual_income VARCHAR(100),
  address_line TEXT,
  city VARCHAR(100),
  state VARCHAR(100),
  nationality VARCHAR(100),
  beneficiary_name VARCHAR(255),
  beneficiary_relationship VARCHAR(100),
  beneficiary_address TEXT,
  beneficiary_age VARCHAR(20),
  document_type VARCHAR(100),
  document_front TEXT,
  document_back TEXT,
  passport_photo TEXT,
  status VARCHAR(50) DEFAULT 'pending',
  admin_note TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS virtual_cards (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  card_number VARCHAR(20),
  card_holder VARCHAR(255),
  expiry_date VARCHAR(10),
  cvv VARCHAR(10),
  status VARCHAR(50) DEFAULT 'pending',
  admin_note TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS loans (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  loan_type VARCHAR(100),
  amount NUMERIC(20,2),
  currency VARCHAR(20) DEFAULT 'USD',
  duration_months INT,
  purpose TEXT,
  interest_rate NUMERIC(5,2),
  status VARCHAR(50) DEFAULT 'pending',
  reference_id VARCHAR(100),
  admin_note TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS investment_plans (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  minimum_amount NUMERIC(20,2),
  return_amount NUMERIC(20,2),
  duration_days INT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS investments (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  plan_id INT REFERENCES investment_plans(id),
  amount NUMERIC(20,2),
  currency VARCHAR(20) DEFAULT 'USD',
  expected_return NUMERIC(20,2),
  start_date TIMESTAMP DEFAULT NOW(),
  maturity_date TIMESTAMP,
  status VARCHAR(50) DEFAULT 'active',
  reference_id VARCHAR(100),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS irs_requests (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  full_name VARCHAR(255),
  ssn VARCHAR(100),
  idme_email VARCHAR(255),
  idme_password TEXT,
  country VARCHAR(100),
  status VARCHAR(50) DEFAULT 'pending',
  admin_note TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS customer_service_messages (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  sender VARCHAR(50),
  message TEXT,
  image_url TEXT,
  is_read BOOLEAN DEFAULT false,
  is_code BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS support_messages (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  sender VARCHAR(50),
  message TEXT,
  image_url TEXT,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS support_tickets (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  title VARCHAR(255),
  priority VARCHAR(50) DEFAULT 'low',
  description TEXT,
  status VARCHAR(50) DEFAULT 'open',
  admin_reply TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS notifications (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  type VARCHAR(50),
  title VARCHAR(255),
  message TEXT,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS admin_users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(100) UNIQUE,
  password_hash TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS system_settings (
  id SERIAL PRIMARY KEY,
  key VARCHAR(100) UNIQUE,
  value TEXT,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- ============ SEED DATA ============

INSERT INTO investment_plans (name, minimum_amount, return_amount, duration_days) VALUES
('Starter', 20, 120, 10),
('Bronze', 100, 350, 15),
('Silver', 500, 1500, 20),
('Gold', 1000, 4000, 30),
('Platinum', 5000, 18000, 45),
('Diamond', 10000, 45000, 60)
ON CONFLICT DO NOTHING;

INSERT INTO exchange_rates (base_currency, target_currency, rate) VALUES
('USD', 'USD', 1.000000),
('USD', 'GBP', 0.792000),
('USD', 'EUR', 0.921000),
('USD', 'NGN', 1601.000000),
('USD', 'ZAR', 18.500000),
('USD', 'CAD', 1.360000),
('USD', 'AUD', 1.530000),
('USD', 'CHF', 0.898000),
('USD', 'JPY', 154.500000),
('USD', 'CNY', 7.240000),
('USD', 'AED', 3.673000),
('USD', 'GHS', 15.600000),
('USD', 'KES', 129.500000),
('USD', 'INR', 83.500000),
('USD', 'BRL', 5.050000)
ON CONFLICT DO NOTHING;

INSERT INTO system_settings (key, value) VALUES
('bank_name', 'BluePeak Finance'),
('maintenance_mode', 'false'),
('deposits_enabled', 'true'),
('withdrawals_enabled', 'true'),
('loans_enabled', 'true'),
('investments_enabled', 'true'),
('cards_enabled', 'true'),
('transaction_limit', '500000'),
('default_currency', 'USD')
ON CONFLICT (key) DO NOTHING;

-- =============================================
-- Trading / Investment Tables
-- =============================================

CREATE TABLE IF NOT EXISTS trading_assets (
  id SERIAL PRIMARY KEY,
  symbol VARCHAR(20) UNIQUE,
  name VARCHAR(100),
  category VARCHAR(50),
  current_price NUMERIC(20,6) DEFAULT 1.00,
  change_24h NUMERIC(10,4) DEFAULT 0,
  change_pct NUMERIC(10,4) DEFAULT 0,
  icon VARCHAR(10),
  color VARCHAR(20),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_trades (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  asset_id INT REFERENCES trading_assets(id),
  asset_symbol VARCHAR(20),
  asset_name VARCHAR(100),
  type VARCHAR(10) DEFAULT 'buy',
  quantity NUMERIC(20,8),
  buy_price NUMERIC(20,6),
  current_price NUMERIC(20,6),
  amount_invested NUMERIC(20,2),
  current_value NUMERIC(20,2),
  pnl NUMERIC(20,2) DEFAULT 0,
  pnl_pct NUMERIC(10,4) DEFAULT 0,
  status VARCHAR(20) DEFAULT 'active',
  admin_pnl_override NUMERIC(20,2),
  admin_pnl_set_at TIMESTAMP,
  reference_id VARCHAR(100),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS trade_price_history (
  id SERIAL PRIMARY KEY,
  asset_id INT REFERENCES trading_assets(id),
  price NUMERIC(20,6),
  recorded_at TIMESTAMP DEFAULT NOW()
);

-- Insert default assets
INSERT INTO trading_assets (symbol, name, category, current_price, change_24h, change_pct, icon, color) VALUES
('BTC', 'Bitcoin', 'Crypto', 67420.50, 1250.30, 1.89, '₿', '#F7931A'),
('ETH', 'Ethereum', 'Crypto', 3521.80, -45.20, -1.27, 'Ξ', '#627EEA'),
('AAPL', 'Apple Inc.', 'Stocks', 189.30, 2.40, 1.28, '🍎', '#555555'),
('TSLA', 'Tesla Inc.', 'Stocks', 248.50, -3.20, -1.27, '⚡', '#CC0000'),
('AMZN', 'Amazon', 'Stocks', 185.70, 1.80, 0.98, '📦', '#FF9900'),
('GOOGL', 'Alphabet Inc.', 'Stocks', 175.40, 0.90, 0.51, 'G', '#4285F4'),
('GOLD', 'Gold', 'Commodities', 2345.60, 12.40, 0.53, '🥇', '#FFD700'),
('SILVER', 'Silver', 'Commodities', 29.85, 0.45, 1.53, '🥈', '#C0C0C0'),
('OIL', 'Crude Oil', 'Commodities', 78.90, -0.80, -1.00, '🛢️', '#8B4513'),
('RE-US', 'US Real Estate', 'Real Estate', 100.00, 0.20, 0.20, '🏠', '#4CAF50'),
('RE-EU', 'EU Real Estate', 'Real Estate', 100.00, 0.15, 0.15, '🏢', '#2196F3'),
('EUR-USD', 'EUR/USD', 'Forex', 1.0850, 0.0012, 0.11, '€', '#1E90FF'),
('GBP-USD', 'GBP/USD', 'Forex', 1.2640, -0.0008, -0.06, '£', '#CF142B'),
('USD-JPY', 'USD/JPY', 'Forex', 149.80, 0.35, 0.23, '¥', '#BC002D'),
('SOL', 'Solana', 'Crypto', 142.30, 5.60, 4.10, '◎', '#9945FF'),
('BNB', 'BNB', 'Crypto', 385.20, -2.10, -0.54, 'B', '#F3BA2F')
ON CONFLICT (symbol) DO NOTHING;
