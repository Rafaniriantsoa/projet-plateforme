import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import axios from 'axios';
// Importez useNavigate si vous prévoyez d'utiliser la navigation interne au lieu de window.location.reload()
// import { useNavigate } from 'react-router-dom'; 

const AuthentifierUtilisateur = () => {

    const API_URL = 'http://localhost/projet/back/api/authentifierUtilisateur.php';
    const navigate = useNavigate(); // Décommentez si vous utilisez navigate

    const [formData, setFormData] = useState({
        email: '',
        motDePasse: '',
    });

    const [message, setMessage] = useState('');
    const [errors, setErrors] = useState({});
    const [loading, setLoading] = useState(false);
    
    // 💡 CORRECTION 1 : Initialiser avec null
    const [user, setUser] = useState(null); 

    // Gère les changements de champs
    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData(prevData => ({
            ...prevData,
            [name]: value,
        }));
    };

    // Gère la soumission du formulaire
    const handleSubmit = async (e) => {
        e.preventDefault();
        setMessage('');
        setErrors({});
        setLoading(true);

        // Validation simple
        if (!formData.email || !formData.motDePasse) {
            setErrors({ general: "Veuillez entrer votre email et votre mot de passe." });
            setLoading(false);
            return;
        }

        try {
            const response = await axios.post(API_URL, formData);

            // Succès : Le backend doit renvoyer les données de l'utilisateur
            const userData = response.data.utilisateur;
            const successMsg = response.data.message || "Connexion réussie !";
            
            // Mettre à jour l'état (optionnel, mais bonne pratique)
            setUser(userData); 
            setMessage(successMsg);

            // 💡 CORRECTION 2 : Déplacer la logique de persistance et de redirection ici
            if (userData) { // Vérifier que l'objet utilisateur est valide
                // 1. Sauvegarde dans le localStorage
                localStorage.setItem('utilisateur', JSON.stringify(userData));
                
                setTimeout(() => {
                    navigate('/')
                    window.location.reload(); 
                    // Si vous ne voulez pas recharger, utilisez navigate('/');
                }, 1000); 
            }
            
        } catch (error) {
            console.error("Erreur de connexion:", error.response || error);

            let errorMessage = "Erreur de serveur inconnue.";
            if (error.response && error.response.data && error.response.data.message) {
                errorMessage = error.response.data.message; // Message d'erreur spécifique du PHP
            } else if (error.request) {
                errorMessage = "Impossible de contacter le serveur API. Le serveur est-il démarré ?";
            }
            setErrors({ general: errorMessage });

        } finally {
            setLoading(false);
        }
    };
    // --- Rendu du Formulaire ---
    return (
        <div className="flex justify-center items-center min-h-screen bg-gray-100 p-4">
            {/* ... (Reste du JSX inchangé) ... */}
            <div className="w-full max-w-sm bg-white p-8 rounded-lg shadow-xl">
                <h2 className="text-3xl font-bold text-gray-800 mb-6 text-center">
                    Se Connecter
                </h2>

                {/* Messages de feedback */}
                {message && (
                    <div className="p-3 mb-4 text-sm text-green-700 bg-green-100 rounded-lg">
                        {message}
                    </div>
                )}
                {errors.general && (
                    <div className="p-3 mb-4 text-sm text-red-700 bg-red-100 rounded-lg">
                        {errors.general}
                    </div>
                )}

                <form onSubmit={handleSubmit} className="space-y-4">
                    {/* Email */}
                    <div>
                        <label htmlFor="email" className="block text-sm font-medium text-gray-700">Adresse Email</label>
                        <input
                            type="email"
                            id="email"
                            name="email"
                            value={formData.email}
                            onChange={handleChange}
                            className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            placeholder="votre.email@example.com"
                        />
                    </div>

                    {/* Mot de Passe */}
                    <div>
                        <label htmlFor="motDePasse" className="block text-sm font-medium text-gray-700">Mot de Passe</label>
                        <input
                            type="password"
                            id="motDePasse"
                            name="motDePasse"
                            value={formData.motDePasse}
                            onChange={handleChange}
                            className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            placeholder="Mot de passe"
                        />
                    </div>

                    {/* Bouton de Soumission */}
                    <button
                        type="submit"
                        disabled={loading}
                        className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition duration-150 disabled:bg-indigo-400"
                    >
                        {loading ? 'Connexion en cours...' : 'Connexion'}
                    </button>
                </form>

                <p className="mt-6 text-center text-sm text-gray-600">
                    Pas encore de compte ? <Link to="/inscription" className="font-medium text-indigo-600 hover:text-indigo-500">Inscrivez-vous ici</Link>
                </p>
            </div>
        </div>
    );
};

export default AuthentifierUtilisateur;