import React, { useState } from "react";
import ReactDOM from "react-dom/client";
import Menu from "./Menu"; // Assure-toi que ce chemin est correct

const App: React.FC = () => {
  const [selected, setSelected] = useState<string | null>(null);

  const handleSelect = (option: string) => {
    console.log("Selected:", option);
    setSelected(option);
  };

  return (
    <div>
      <Menu options={["Option 1", "Option 2", "Option 3"]} onSelect={handleSelect} />
      {selected && <p>Choix : {selected}</p>}
    </div>
  );
};

ReactDOM.createRoot(document.getElementById("root")!).render(<App />);
