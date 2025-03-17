window.addEventListener("message", (event) => {
    setTimeout(() => {
        const data = event.data;
        const menuContainer = document.querySelector(".menu-container");

        if (!menuContainer) {
            console.error("L'élément .menu-container est introuvable !");
            return;
        }

        if (data.action === "toggleMenu") {
            menuContainer.style.visibility = data.visible ? "visible" : "hidden";
            menuContainer.style.opacity = data.visible ? "1" : "0";
        }
    }, 100);
});

document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/closeMenu`, { method: "POST" });
    }
});
