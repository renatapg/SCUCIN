// Registra el Service Worker para habilitar la instalación PWA.
if ("serviceWorker" in navigator) { window.addEventListener("load", () => { navigator.serviceWorker.register("/scucin/service-worker.js", {scope:"/scucin/"}).catch(error => console.error("No se pudo registrar SCUCIN PWA:", error)); }); }
