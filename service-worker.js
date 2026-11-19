/* SCUCIN PWA: solo almacena recursos estáticos; nunca guarda páginas PHP ni datos clínicos. */
const CACHE_NAME = "scucin-static-v1";
const APP_SCOPE = "/scucin/";
const STATIC_FILES = [APP_SCOPE+"offline.html",APP_SCOPE+"manifest.webmanifest",APP_SCOPE+"assets/css/estilos.css",APP_SCOPE+"assets/js/validaciones.js",APP_SCOPE+"assets/js/pwa.js",APP_SCOPE+"assets/img/logo_lasalle.png",APP_SCOPE+"assets/img/app/icon-192.png",APP_SCOPE+"assets/img/app/icon-512.png"];
self.addEventListener("install",e=>e.waitUntil(caches.open(CACHE_NAME).then(c=>c.addAll(STATIC_FILES)).then(()=>self.skipWaiting())));
self.addEventListener("activate",e=>e.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE_NAME).map(k=>caches.delete(k)))).then(()=>self.clients.claim())));
self.addEventListener("fetch",e=>{const r=e.request,u=new URL(r.url);if(r.method!=="GET"||u.origin!==self.location.origin)return;if(u.pathname.endsWith(".php")||u.pathname.includes("/api/"))return;if(r.mode==="navigate"){e.respondWith(fetch(r).catch(()=>caches.match(APP_SCOPE+"offline.html")));return;}if(STATIC_FILES.includes(u.pathname))e.respondWith(caches.match(r).then(c=>c||fetch(r)));});
