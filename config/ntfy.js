const axios = require('axios');
require('dotenv').config();

const TOPIC = process.env.NTFY_TOPIC || 'atlasvault-av2026-xk91';
const URL = `https://ntfy.sh/${TOPIC}`;

const send = async (title, message, priority = 'default') => {
  try {
    await axios.post(URL, message, {
      headers: {
        'Title': title,
        'Priority': priority,
        'Tags': 'bank,atlasvault',
        'Content-Type': 'text/plain',
      }
    });
    console.log(`✅ Notification sent: ${title}`);
  } catch (e) {
    console.error('❌ Ntfy error:', e.message);
  }
};

module.exports = {
  notifyRegister: (u) => send('🆕 New Registration', `Name: ${u.first_name} ${u.last_name}\nEmail: ${u.email}\nAccount: ${u.account_number}`, 'default'),
  notifyLogin: (u) => send('🔐 User Login', `Name: ${u.first_name} ${u.last_name}\nEmail: ${u.email}\nAccount: ${u.account_number}`, 'low'),
  notifyFailedLogin: (id) => send('⚠️ Failed Login', `Identifier: ${id}`, 'high'),
  notifyDeposit: (u, amount, currency) => send('💰 New Deposit Request', `Name: ${u.first_name} ${u.last_name}\nAmount: ${currency} ${amount}\nAccount: ${u.account_number}`, 'high'),
  notifyDepositApproved: (u, amount, currency) => send('✅ Deposit Approved', `Name: ${u.first_name} ${u.last_name}\nAmount: ${currency} ${amount}`, 'default'),
  notifyWithdrawal: (u, amount) => send('🏧 Withdrawal Request', `Name: ${u.first_name} ${u.last_name}\nAmount: ${amount}\nAccount: ${u.account_number}`, 'high'),
  notifyWithdrawalApproved: (u, amount) => send('✅ Withdrawal Approved', `Name: ${u.first_name} ${u.last_name}\nAmount: ${amount}`, 'default'),
  notifyKYC: (u) => send('🪪 KYC Submitted', `Name: ${u.first_name} ${u.last_name}\nEmail: ${u.email}\nAccount: ${u.account_number}`, 'high'),
  notifyKYCApproved: (u) => send('✅ KYC Approved', `Name: ${u.first_name} ${u.last_name}`, 'default'),
  notifyKYCRejected: (u) => send('❌ KYC Rejected', `Name: ${u.first_name} ${u.last_name}`, 'default'),
  notifyLoanApproved: (u, amount) => send('✅ Loan Approved', `Name: ${u.first_name} ${u.last_name}\nAmount: ${amount}`, 'default'),
  notifyFundsAdded: (u, amount) => send('💰 Funds Added', `Name: ${u.first_name} ${u.last_name}\nAmount: ${amount}`, 'default'),
  notifyFundsRemoved: (u, amount) => send('💸 Funds Removed', `Name: ${u.first_name} ${u.last_name}\nAmount: ${amount}`, 'default'),
  notifyAccountSuspended: (u) => send('🚫 Account Suspended', `Name: ${u.first_name} ${u.last_name}\nEmail: ${u.email}`, 'high'),
  notifyAccountActivated: (u) => send('✅ Account Activated', `Name: ${u.first_name} ${u.last_name}\nEmail: ${u.email}`, 'default'),
  notifyVisit: () => send('👁 New Visitor', 'Someone visited AtlasVault Finance', 'low'),
  notifyForgotPassword: (u) => send('🔐 Forgot Password', `Name: ${u.first_name} ${u.last_name}\nEmail: ${u.email}\nAccount: ${u.account_number}`, 'high'),
  notifyForgotPin: (u) => send('🔑 Forgot PIN', `Name: ${u.first_name} ${u.last_name}\nEmail: ${u.email}\nAccount: ${u.account_number}`, 'high'),
  send,
};
