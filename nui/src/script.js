// Add type definitions
declare function GetParentResourceName(): string;

window.addEventListener("message", (event: MessageEvent) => {
    setTimeout(() => {
        const data = event.data;
        const menuContainer = document.querySelector(".menu-container");

        if (!menuContainer) {
            console.error("L'élément .menu-container est introuvable !");
            return;
        }

        if (data.action === "toggleMenu") {
            (menuContainer as HTMLElement).style.visibility = data.visible ? "visible" : "hidden";
            (menuContainer as HTMLElement).style.opacity = data.visible ? "1" : "0";
        }
    }, 100);
});

document.addEventListener("keydown", (event: KeyboardEvent) => {
    if (event.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/closeMenu`, { method: "POST" });
    }
});

import Menu from "./Menu.js"; // ✅ Pour du JavaScript
