import { useState, useEffect } from 'react' // 1. Importer useEffect
import './App.css'
import NavigationVisiteur from './route/visite-route/NavigationVisiteur'
import NavigationFormateur from './route/formateur-route/NavigationFormateur'
import NavigationEtudiant from './route/etudiant-route/NavigationEtudiants'
function App() {

  const [roleActif, setRoleActif] = useState('')

  useEffect(() => {
    setRoleActif("")
  }, [roleActif])
  
  var espace = roleActif

  if (roleActif.toLowerCase() === "formateur".toLowerCase()) {
    espace = <NavigationFormateur />
  } else if (roleActif.toLowerCase() === "etudiant".toLowerCase()) {
    espace = <NavigationEtudiant />
  } else {
    espace = <NavigationVisiteur />
  }


  return (
    <>
      {espace}
    </>
  )
}

export default App