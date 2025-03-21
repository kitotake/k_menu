import React, { useEffect, useState } from "react";
import "./styles.css";
import "../script.js"

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

    useEffect(() => {
        const handleMessage = (event: MessageEvent) => {
            if (event.data.action === "openTestMenu") {
                setMenuData(event.data.menuData);
            }
        };

        window.addEventListener("message", handleMessage);
        return () => window.removeEventListener("message", handleMessage);
    }, []);

    const handleOptionClick = (option: MenuOption) => {
        fetch(`https://${GetParentResourceName()}/menuOptionSelected`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ value: option.value })
        });
    };

    if (!menuData) return null;

    return (
        <div className="menu-container">
            <h1>{menuData.title}</h1>
            <p>{menuData.subtitle}</p>
            <div className="menu-options">
                {menuData.options.map((option, index) => (
                    <button key={index} onClick={() => handleOptionClick(option)}>
                        {option.label}
                    </button>
                ))}
            </div>
        </div>
    );
};

export default Menu;
