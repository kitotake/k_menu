import React, { useEffect, useState } from "react";
import "./styles.css";
import "../script.js";

interface MenuOption {
    label: string;
    value: string;
}

interface MenuData {
    title: string;
    subtitle: string;
    options: MenuOption[];
}

const Menu: React.FC = () => {
    const [menuData, setMenuData] = useState<MenuData | null>(null);
    const [isClosing, setIsClosing] = useState(false);

    useEffect(() => {
        const handleMessage = (event: MessageEvent) => {
            if (event.data.action === "openTestMenu") {
                setIsClosing(false);
                setMenuData(event.data.menuData);
            } else if (event.data.action === "closeUI") {
                handleClose();
            }
        };

        window.addEventListener("message", handleMessage);
        return () => window.removeEventListener("message", handleMessage);
    }, []);

    useEffect(() => {
        const handleEscape = (e: KeyboardEvent) => {
            if (e.key === "Escape") {
                e.preventDefault();
                fetch(`https://${GetParentResourceName()}/closeMenu`, {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({})
                });
                handleClose();
            }
        };

        document.addEventListener("keydown", handleEscape);
        return () => document.removeEventListener("keydown", handleEscape);
    }, []);

    const handleClose = () => {
        setIsClosing(true);
        setTimeout(() => {
            setMenuData(null);
            setIsClosing(false);
        }, 300); // Durée de l'animation CSS
    };

    const handleOptionClick = (option: MenuOption) => {
        fetch(`https://${GetParentResourceName()}/menuOptionSelected`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ value: option.value })
        });
        // 🚨 Suppression de la fermeture automatique ici 🚨
    };

    if (!menuData) return null;

    return (
        <div className={`menu-container ${isClosing ? 'closing' : ''}`}>
            <div className="menu-header">
                <h1 className="menu-title">{menuData.title}</h1>
                <p className="menu-subtitle">{menuData.subtitle}</p>
            </div>
            <div className="menu-options">
                {menuData.options.map((option, index) => (
                    <div 
                        key={index} 
                        className="menu-option"
                        onClick={() => handleOptionClick(option)}
                    >
                        {option.label}
                    </div>
                ))}
            </div>
        </div>
    );
};

export default Menu;
