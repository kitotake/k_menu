import { useState, useEffect } from "react";
import "./styles.css"; // Assurez-vous que ce fichier existe

interface MenuProps {
    title: string;
    subtitle: string;
    options: { label: string }[];
}

const Menu = () => {
    const [menu, setMenu] = useState<MenuProps | null>(null);

    useEffect(() => {
        const handleMessage = (event: MessageEvent) => {
            const data = event.data;
            if (data.action === "toggleMenu") {
                setMenu(data.visible ? {
                    title: data.title,
                    subtitle: data.subtitle,
                    options: data.options || []
                } : null);
            }
        };

        window.addEventListener("message", handleMessage);
        return () => window.removeEventListener("message", handleMessage);
    }, []);

    const handleOptionClick = (index: number) => {
        fetch(`https://${(window as any).GetParentResourceName()}/selectOption`, {
            method: "POST",
            body: JSON.stringify({ index }),
        });
    };

    if (!menu) return null;

    return (
        <div className={`menu-container ${menu ? "active" : ""}`}>
            <h1 className="menu-title">{menu.title}</h1>
            <h2 className="menu-subtitle">{menu.subtitle}</h2>
            {menu.options.map((option, index) => (
                <button key={index} className="menu-button" onClick={() => handleOptionClick(index)}>
                    {option.label}
                </button>
            ))}
        </div>
    );
};

export default Menu;
