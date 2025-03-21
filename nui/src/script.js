// ✅ Suppression de `declare`, inutile en JS
window.addEventListener("message", (event) => {
    const data = event.data;
    const menuContainer = document.querySelector(".menu-container");

    if (!menuContainer) {
        console.error("⚠️ L'élément .menu-container est introuvable !");
        return;
    }

    if (data.action === "toggleMenu") {
        menuContainer.style.visibility = data.visible ? "visible" : "hidden";
        menuContainer.style.opacity = data.visible ? "1" : "0";
    }
});

// ✅ Fermeture avec Escape
document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
        event.preventDefault(); // ✅ Empêche d'autres actions liées à Escape
        fetch(`https://${GetParentResourceName()}/closeMenu`, { method: "POST" });
    }
});

// ✅ Vérification de l'import pour JS
import Menu from "./Menu.js"; // ⚠️ Assure-toi que `Menu.js` existe bien
