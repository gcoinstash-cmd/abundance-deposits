const CACHE_NAME = 'abundance-deposits-v5';

self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(clients.claim());
});

// Real Background Push Event (Delivered from server while iPhone is locked/closed)
self.addEventListener('push', (event) => {
  let data = {};
  if (event.data) {
    try {
      data = event.data.json();
    } catch(e) {
      data = { body: event.data.text() };
    }
  }

  const title = data.title || 'Payment Received';
  const options = {
    body: data.body || 'You received a payment of $100.00',
    icon: 'icon-192.png',
    badge: 'icon-192.png',
    vibrate: [200, 100, 200, 100, 200],
    data: data,
    tag: 'deposit-' + Date.now(),
    renotify: true
  };

  event.waitUntil(self.registration.showNotification(title, options));
});

// In-app message trigger
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SEND_NOTIFICATION') {
    const title = event.data.title || 'Payment Received';
    const options = {
      body: event.data.body || 'You received a deposit',
      icon: 'icon-192.png',
      badge: 'icon-192.png',
      vibrate: [200, 100, 200, 100, 200],
      tag: 'deposit-' + Date.now(),
      renotify: true
    };
    self.registration.showNotification(title, options);
  }
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      for (const client of clientList) {
        if ('focus' in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow('./');
      }
    })
  );
});
