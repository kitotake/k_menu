import React from "react";  
import "./styles.css";  

// Définition des types des props
interface MenuProps {
  options: string[];
  onSelect: (option: string) => void;
}

const Menu: React.FC<MenuProps> = ({ options, onSelect }) => {
  return (
    <div className="menu-container">
      <div className="menu-header">
        <h2 className="menu-title">Menu</h2>
      </div>
      <div className="menu-options">
        {options.map((option, index) => (
          <div
            key={index}
            className="menu-option"
            onClick={() => onSelect(option)}
          >
            {option}
          </div>
        ))}
      </div>
    </div>
  );
};

export default Menu;
