import { jsx as _jsx } from "react/jsx-runtime";
import React from "react";
import ReactDOM from "react-dom/client";
import "./components/styles.css";
import Menu from "./Menu"; // ✅ Correct si Menu.js est dans le même dossier
ReactDOM.createRoot(document.getElementById("root")).render(_jsx(React.StrictMode, { children: _jsx(Menu, {}) }));
