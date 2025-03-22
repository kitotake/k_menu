// Gestionnaire d'événements pour les messages NUI
window.addEventListener("message", (event) => {
    const data = event.data;

    if (data.action === "openTestMenu") {
        // Le menu sera affiché par React
        console.log("Menu ouvert avec données:", data.menuData);
    } else if (data.action === "closeUI") {
        // Le menu sera fermé par React
        console.log("Fermeture du menu demandée");
    }
});

// Gestion de la touche Escape
document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
        event.preventDefault();
        fetch(`https://${GetParentResourceName()}/closeMenu`, { 
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({})
        });
    }
});