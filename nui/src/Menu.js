import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import { useState, useEffect } from 'react';
import './styles.css';
var Menu = function () {
    var _a = useState(null), menuData = _a[0], setMenuData = _a[1];
    var _b = useState(0), selectedIndex = _b[0], setSelectedIndex = _b[1];
    // Listen for NUI messages from Lua
    useEffect(function () {
        window.addEventListener('message', handleMessage);
        return function () { return window.removeEventListener('message', handleMessage); };
    }, []);
    var handleMessage = function (event) {
        var data = event.data;
        if (data.action === 'toggleMenu') {
            if (data.menuData) {
                setMenuData(data.menuData);
                setSelectedIndex(0);
            }
            else if (data.visible === false) {
                setMenuData(null);
            }
        }
        else if (data.action === 'closeAllMenus') {
            setMenuData(null);
        }
    };
    var handleOptionClick = function (index) {
        if (!menuData)
            return;
        // Send callback to Lua
        fetch("https://".concat(GetParentResourceName(), "/executeOption"), {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                menuId: menuData.id,
                optionIndex: index + 1, // Lua tables are 1-indexed
            }),
        }).catch(function (e) { return console.error('Error executing option:', e); });
    };
    var handleKeyDown = function (e) {
        if (!menuData || !menuData.options.length)
            return;
        switch (e.key) {
            case 'ArrowUp':
                setSelectedIndex(function (prev) { return (prev > 0 ? prev - 1 : menuData.options.length - 1); });
                break;
            case 'ArrowDown':
                setSelectedIndex(function (prev) { return (prev < menuData.options.length - 1 ? prev + 1 : 0); });
                break;
            case 'Enter':
                handleOptionClick(selectedIndex);
                break;
            case 'Escape':
                fetch("https://".concat(GetParentResourceName(), "/closeMenu"), {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({}),
                }).catch(function (e) { return console.error('Error closing menu:', e); });
                break;
        }
    };
    if (!menuData || !menuData.visible)
        return null;
    return (_jsxs("div", { className: "menu-container", tabIndex: 0, onKeyDown: handleKeyDown, autoFocus: true, children: [_jsxs("div", { className: "menu-header", children: [_jsx("h2", { className: "menu-title", children: menuData.title }), _jsx("p", { className: "menu-subtitle", children: menuData.subtitle })] }), _jsx("div", { className: "menu-options", children: menuData.options.map(function (option, index) { return (_jsx("div", { className: "menu-option ".concat(selectedIndex === index ? 'selected' : ''), onClick: function () { return handleOptionClick(index); }, children: option.label }, index)); }) })] }));
};
export default Menu;
