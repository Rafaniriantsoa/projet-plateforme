import React, { useState } from 'react'; // 1. Plus besoin de useEffect
import './App.css';
import NavigationVisiteur from './route/visite-route/NavigationVisiteur';
import NavigationFormateur from './route/formateur-route/NavigationFormateur';
import NavigationEtudiant from './route/etudiant-route/NavigationEtudiants';
// import { useAsyncError } from 'react-router-dom'; // Inutilisé

const getInitialUser = () => {
  try {
    const savedUser = localStorage.getItem("utilisateur");
    return savedUser ? JSON.parse(savedUser) : null;
  } catch (e) {
    console.error(e);
    return null;
  }
};

function App() {

  const [utilisateur, setUtilisateur] = useState(getInitialUser());

  const roleActif = utilisateur?.role || "";

  const idUtilisateur = utilisateur?.id_utilisateur || null;

  console.log("Rôle actuel :", roleActif);
  console.log("id :", idUtilisateur);

  let espace; 

  if (roleActif.toLowerCase() === "formateur") {
    espace = <NavigationFormateur />;
  } else if (roleActif.toLowerCase() === "etudiant") {
    espace = <NavigationEtudiant />;
  } else {
    espace = <NavigationVisiteur />;
  }

  return (
    <>
      {espace}
    </>
  );
}

export default App;