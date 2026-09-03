const express = require('express');
const webpush = require('web-push');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'pwa')));

// VAPID keys for Apple Web Push
const publicVapidKey = 'BIfWK15buN4jE_3C2ybpVXC2sVN-TPR1TW8Nb4jvfr5P87f3zFXXf2IwprLeKgvrHIHQAakJ242LvwXW8kRc80k';
const privateVapidKey = 'vb_yU3ig7vCZIKP98qwSv8xEzHua8JxxJdzwVGAwc2g';

webpush.setVapidDetails(
  'mailto:support@abundancedeposits.com',
  publicVapidKey,
  privateVapidKey
);

// Store active push subscriptions
let subscriptions = [];
let intervalMinutes = 15;
let dailyGoal = 5000;
let selectedTier = 999;
let activePlatforms = ['Stripe', 'Cash App', 'Shopify', 'PayPal'];

const senders = [
  'Horizon Studios', 'Aura Luxury Goods', 'Creative Apex', 'Starlight Media',
  'Elysian Ventures', 'marcus_v', 'sarah_j', 'Vanguard Direct', 'Quantum Growth Labs', 'Apex Capital'
];

app.get('/vapidPublicKey', (req, res) => {
  res.json({ publicKey: publicVapidKey });
});

// Endpoint to register iPhone push subscription
app.post('/subscribe', (req, res) => {
  const subscription = req.body;
  if (!subscriptions.some(s => s.endpoint === subscription.endpoint)) {
    subscriptions.push(subscription);
    console.log('📱 New iPhone Push Subscription registered! Total active subscribers:', subscriptions.length);
  }
  res.status(201).json({ success: true, count: subscriptions.length });
});

// Endpoint to update schedule configuration
app.post('/config', (req, res) => {
  if (req.body.interval) {
    intervalMinutes = parseInt(req.body.interval) || 15;
    console.log(`⏱️ Schedule updated to every ${intervalMinutes} minutes`);
    resetCronTimer();
  }
  if (req.body.goal) dailyGoal = req.body.goal;
  if (req.body.tier) selectedTier = req.body.tier;
  if (req.body.platforms) activePlatforms = req.body.platforms;
  res.json({ success: true, interval: intervalMinutes });
});

// Manual test trigger endpoint
app.post('/trigger-test', (req, res) => {
  console.log(`🧪 Manual test push requested for ${subscriptions.length} devices`);
  sendPushToSubscribers();
  res.json({ success: true, sentTo: subscriptions.length });
});

// Function to send background push notification to locked iPhone
function sendPushToSubscribers(customAmt = null) {
  if (subscriptions.length === 0) {
    console.log('⚠️ No active iPhone subscribers registered yet.');
    return;
  }

  const microAmounts = [25.00, 35.00, 50.00, 75.00, 100.00, 150.00, 200.00, 250.00];
  const amt = customAmt || microAmounts[Math.floor(Math.random() * microAmounts.length)];
  const platform = activePlatforms[Math.floor(Math.random() * activePlatforms.length)] || 'Stripe';
  const sender = senders[Math.floor(Math.random() * senders.length)];

  const body = platform === 'Stripe'
    ? `You received a payment of $${amt.toFixed(2)} from ${sender}`
    : `$${amt.toFixed(2)} sent from $${sender.toLowerCase().replace(/ /g, '_')} 💸`;

  const payload = JSON.stringify({
    title: 'Payment Received',
    body: body,
    icon: 'icon-192.png',
    badge: 'icon-192.png',
    amount: amt,
    platform: platform,
    sender: sender
  });

  console.log(`🚀 Sending push notification: ${body} to ${subscriptions.length} devices`);

  subscriptions.forEach(sub => {
    webpush.sendNotification(sub, payload).catch(err => {
      console.log('WebPush dispatch error:', err.statusCode || err.message);
      if (err.statusCode === 410 || err.statusCode === 404) {
        subscriptions = subscriptions.filter(s => s.endpoint !== sub.endpoint);
      }
    });
  });
}

// Background Cron Timer (runs on server even when iPhone screen is completely locked)
let serverTimer = null;
function resetCronTimer() {
  if (serverTimer) clearInterval(serverTimer);
  const intervalMs = intervalMinutes * 60 * 1000;
  serverTimer = setInterval(() => {
    console.log(`⏰ ${intervalMinutes}-minute background interval triggered!`);
    sendPushToSubscribers();
  }, intervalMs);
}

// Start initial background cron
resetCronTimer();

app.listen(PORT, () => {
  console.log(`🌟 Abundance Deposits Server with Apple Web Push running on port ${PORT}`);
});
