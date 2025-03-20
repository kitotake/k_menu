import React, { useState, useEffect } from 'react';
import './styles.css';

// Declaration for FiveM's NUI functions
declare function GetParentResourceName(): string;

interface MenuOption {
  label: string;
  callback?: () => void;
}

interface MenuData {
  id: string;
  title: string;
  subtitle: string;
  options: MenuOption[];
  visible: boolean;
}

const Menu: React.FC = () => {
  const [menuData, setMenuData] = useState<MenuData | null>(null);
  const [selectedIndex, setSelectedIndex] = useState(0);
  
  // Listen for NUI messages from Lua
  useEffect(() => {
    window.addEventListener('message', handleMessage);
    return () => window.removeEventListener('message', handleMessage);
  }, []);
  
  const handleMessage = (event: MessageEvent) => {
    const data = event.data;
    
    if (data.action === 'toggleMenu') {
      if (data.menuData) {
        setMenuData(data.menuData);
        setSelectedIndex(0);
      } else if (data.visible === false) {
        setMenuData(null);
      }
    } else if (data.action === 'closeAllMenus') {
      setMenuData(null);
    }
  };
  
  const handleOptionClick = (index: number) => {
    if (!menuData) return;
    
    // Send callback to Lua
    fetch(`https://${GetParentResourceName()}/executeOption`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({
        menuId: menuData.id,
        optionIndex: index + 1, // Lua tables are 1-indexed
      }),
    }).catch(e => console.error('Error executing option:', e));
  };
  
  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (!menuData || !menuData.options.length) return;
    
    switch (e.key) {
      case 'ArrowUp':
        setSelectedIndex(prev => (prev > 0 ? prev - 1 : menuData.options.length - 1));
        break;
      case 'ArrowDown':
        setSelectedIndex(prev => (prev < menuData.options.length - 1 ? prev + 1 : 0));
        break;
      case 'Enter':
        handleOptionClick(selectedIndex);
        break;
      case 'Escape':
        fetch(`https://${GetParentResourceName()}/closeMenu`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: JSON.stringify({}),
        }).catch(e => console.error('Error closing menu:', e));
        break;
    }
  };
  
  if (!menuData || !menuData.visible) return null;
  
  return (
    <div 
      className="menu-container" 
      tabIndex={0} 
      onKeyDown={handleKeyDown}
      autoFocus
    >
      <div className="menu-header">
        <h2 className="menu-title">{menuData.title}</h2>
        <p className="menu-subtitle">{menuData.subtitle}</p>
      </div>
      
      <div className="menu-options">
        {menuData.options.map((option, index) => (
          <div
            key={index}
            className={`menu-option ${selectedIndex === index ? 'selected' : ''}`}
            onClick={() => handleOptionClick(index)}
          >
            {option.label}
          </div>
        ))}
      </div>
    </div>
  );
};

export default Menu;