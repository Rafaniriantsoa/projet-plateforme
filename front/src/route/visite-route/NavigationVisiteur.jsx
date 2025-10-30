import React from 'react';
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';

import Accueil from './Accueil';
import Connecter from './Connecter';
import Inscrire from './Inscrire';

const NavigationVisiteur = () => {
  return (
    <BrowserRouter>
      <>
        
        <nav className='flex gap-8 w'>
          <Link to="/">Accueil</Link>
          <Link to="/connexion">Se connecter</Link>
          <Link to="/inscription">S'inscrire</Link>
        </nav>

        <h1 className='text-4xl'>ESPACE de Visiteur</h1>
        <div>
          <Routes>
            <Route path='/' element={<Accueil />} /> 
            <Route path='/accueil' element={<Accueil />} /> 
            <Route path='/connexion' element={<Connecter />} />
            <Route path='/inscription' element={<Inscrire />} />
            
            <Route path='*' element={<h1>404 | Page non trouvée</h1>} />
            
          </Routes>
        </div>
      </>
    </BrowserRouter>
  );
}

export default NavigationVisiteur;