const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

// ─── Scheduled: Daily expiry check at 8 PM IST (2:30 PM UTC) ────────────────
exports.dailyExpiryCheck = functions.pubsub
  .schedule('30 14 * * *')
  .timeZone('Asia/Kolkata')
  .onRun(async (context) => {
    console.log('Running daily expiry check...');
    const now = new Date();

    try {
      const usersSnap = await db.collection('users').get();
      const promises = usersSnap.docs.map(async (userDoc) => {
        const userId = userDoc.id;
        const prefs = userDoc.data().notificationPreferences || {};
        if (prefs.enabled === false) return;

        const medicinesSnap = await db
          .collection('users').doc(userId)
          .collection('medicines')
          .where('notificationEnabled', '==', true)
          .get();

        const expiringSoon = [];
        const criticalMeds = [];
        const expiredMeds = [];

        medicinesSnap.docs.forEach((doc) => {
          const data = doc.data();
          const expiryDate = data.expiryDate.toDate();
          const daysLeft = Math.floor((expiryDate - now) / (1000 * 60 * 60 * 24));

          if (daysLeft < 0) expiredMeds.push({ id: doc.id, ...data, daysLeft });
          else if (daysLeft <= 7) criticalMeds.push({ id: doc.id, ...data, daysLeft });
          else if (daysLeft <= 30) expiringSoon.push({ id: doc.id, ...data, daysLeft });
        });

        // Get FCM token for this user
        const tokenDoc = await db.collection('fcmTokens').doc(userId).get();
        if (!tokenDoc.exists) return;
        const token = tokenDoc.data().token;
        if (!token) return;

        const notifications = [];

        // Expired medicines alert
        if (expiredMeds.length > 0 && prefs.notifyOnDay !== false) {
          notifications.push(sendNotification(token, {
            title: '⚠️ Expired Medicines!',
            body: `You have ${expiredMeds.length} expired medicine(s). Please remove them immediately.`,
            data: { type: 'expired', count: String(expiredMeds.length) },
          }));
        }

        // Critical (≤7 days)
        if (criticalMeds.length > 0 && prefs.notify7Days !== false) {
          notifications.push(sendNotification(token, {
            title: '🔴 Critical: Expiring Very Soon',
            body: `${criticalMeds[0].name} expires in ${criticalMeds[0].daysLeft} day(s)!`,
            data: { type: 'critical', medicineId: criticalMeds[0].id },
          }));
        }

        // Expiring soon (≤30 days)
        if (expiringSoon.length > 0 && prefs.notify30Days !== false) {
          notifications.push(sendNotification(token, {
            title: '🟡 Medicines Expiring Soon',
            body: `${expiringSoon.length} medicine(s) expire within 30 days.`,
            data: { type: 'expiringSoon', count: String(expiringSoon.length) },
          }));
        }

        // Daily summary
        if (prefs.dailySummary !== false) {
          const total = medicinesSnap.size;
          const safe = total - expiringSoon.length - criticalMeds.length - expiredMeds.length;
          notifications.push(sendNotification(token, {
            title: '💊 MedTrack Daily Summary',
            body: `${total} medicines tracked. ${safe} safe, ${expiringSoon.length + criticalMeds.length} expiring soon, ${expiredMeds.length} expired.`,
            data: { type: 'summary' },
          }));
        }

        return Promise.all(notifications);
      });

      await Promise.all(promises);
      console.log('Daily expiry check complete.');
    } catch (error) {
      console.error('Error in dailyExpiryCheck:', error);
    }
  });

// ─── Helper: Send FCM notification ───────────────────────────────────────────
async function sendNotification(token, { title, body, data }) {
  try {
    await messaging.send({
      token,
      notification: { title, body },
      data: data || {},
      android: {
        notification: {
          channelId: 'medtrack_reminders',
          priority: 'high',
          sound: 'default',
        },
      },
      apns: {
        payload: {
          aps: { sound: 'default', badge: 1 },
        },
      },
    });
  } catch (err) {
    console.error(`Failed to send to token ${token}:`, err.message);
  }
}

// ─── HTTP: Manual trigger for testing ────────────────────────────────────────
exports.triggerExpiryCheck = functions.https.onRequest(async (req, res) => {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }
  // Simple auth check via custom header
  const secret = req.headers['x-admin-secret'];
  if (secret !== functions.config().admin.secret) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  await exports.dailyExpiryCheck.run({});
  return res.status(200).json({ message: 'Expiry check triggered.' });
});
