import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
    plugins: [react()],
    base: "./", // Corrige les chemins d'accès aux assets
    build: {
        outDir: "dist",
        emptyOutDir: true,
    },
    server: {
        port: 5173, // Port pour le développement
        strictPort: true,
    },
});
