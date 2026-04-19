/* XII Squadra · Croce Bianca Brescia — minimal service worker */
const CACHE = “xii-squadra-v1”;
const ASSETS = [
“./”,
“./index.html”,
“./manifest.webmanifest”,
“./icon-192.png”,
“./icon-512.png”,
“./icon-maskable-512.png”,
“./apple-touch-icon.png”,
“./favicon-32.png”
];

self.addEventListener(“install”, (e) => {
e.waitUntil(caches.open(CACHE).then((c) => c.addAll(ASSETS).catch(() => {})));
self.skipWaiting();
});

self.addEventListener(“activate”, (e) => {
e.waitUntil(
caches.keys().then((keys) =>
Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))
)
);
self.clients.claim();
});

self.addEventListener(“fetch”, (e) => {
const req = e.request;
if (req.method !== “GET”) return;
e.respondWith(
caches.match(req).then((cached) => {
const network = fetch(req)
.then((res) => {
const copy = res.clone();
caches.open(CACHE).then((c) => c.put(req, copy)).catch(() => {});
return res;
})
.catch(() => cached);
return cached || network;
})
);
});
