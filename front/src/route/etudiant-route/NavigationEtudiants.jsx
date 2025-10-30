import React from 'react'
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';
import Accueil from './Acceuil';
import Deconnexion from './Deconnexion'

const NavigationEtudiant = () => {
  return (
    <BrowserRouter>
      <>
        <nav className='flex gap-8 w'>
          <Link to="/">Accueil</Link>
          <Link to="/deconnexion">deconnexion</Link>
        </nav>

        <h1 className='text-4xl'>ESPACE D'ETUDIANT</h1>
        <div>
          <Routes>
            <Route path='/' element={<Accueil />} /> 
            <Route path='/deconnexion' element={<Deconnexion />} />
            
            <Route path='*' element={<h1>404 | Page non trouvée</h1>} />
            
          </Routes>
        </div>
      </>
    </BrowserRouter>
  );
}

export default NavigationEtudiant