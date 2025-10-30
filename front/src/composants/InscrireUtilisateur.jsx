import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import axios from 'axios'; // ⬅️ N'oubliez pas d'installer : npm install axios

const InscrireUtilisateur = () => {
    // URL de votre script PHP d'inscription
    const API_URL = 'http://localhost/projet/back/api/inscrireUtilisateur.php'; 

    const [formData, setFormData] = useState({
        nomComplet: '',
        email: '',
        motDePasse: '',
        photo: null,
        specialite: '',
        role: 'etudiant',
    });

    const [errors, setErrors] = useState({});
    const [message, setMessage] = useState('');
    const [loading, setLoading] = useState(false);

    // Gère les changements dans les champs de texte et le sélecteur
    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData(prevData => ({
            ...prevData,
            [name]: value,
        }));
    };

    // Gère le changement de fichier (Photo)
    const handleFileChange = (e) => {
        setFormData(prevData => ({
            ...prevData,
            photo: e.target.files[0], // Stocke l'objet File
        }));
    };

    // 🆕 Gère la soumission et l'envoi via Axios
    const handleSubmit = async (e) => {
        e.preventDefault();
        setMessage(''); // Réinitialiser les messages
        setErrors({}); // Réinitialiser les erreurs
        setLoading(true);

        // 1. Validation front-end
        if (!formData.nomComplet || !formData.email || !formData.motDePasse) {
            setErrors({ general: "Veuillez remplir tous les champs obligatoires." });
            setLoading(false);
            return;
        }

        // 2. Création de l'objet FormData (obligatoire pour envoyer des fichiers en PHP)
        const dataToSend = new FormData();
        dataToSend.append('nomComplet', formData.nomComplet);
        dataToSend.append('email', formData.email);
        dataToSend.append('motDePasse', formData.motDePasse);
        dataToSend.append('role', formData.role);
        
        // La spécialité n'est requise que pour les formateurs
        if (formData.role === 'formateur' && formData.specialite) {
            dataToSend.append('specialite', formData.specialite);
        }

        // Ajout du fichier photo s'il est sélectionné
        if (formData.photo) {
            dataToSend.append('photo', formData.photo);
        }
        
        // 3. Envoi de la requête via Axios
        try {
            const response = await axios.post(API_URL, dataToSend, {
                headers: {
                    // Axios va gérer lui-même le Content-Type: multipart/form-data
                    // y compris la boundary nécessaire pour les fichiers.
                    'Content-Type': 'multipart/form-data' 
                }
            });

            // Gérer le succès (statut 201 Created ou 200 OK)
            setMessage(response.data.message || "Inscription réussie ! Vous pouvez vous connecter.");
            setFormData({ // Optionnel : Réinitialiser le formulaire
                nomComplet: '', email: '', motDePasse: '', photo: null, specialite: '', role: 'etudiant',
            });

        } catch (error) {
            // Gérer les erreurs (400 Bad Request, 409 Conflict, 500 Server Error)
            console.error("Erreur d'inscription:", error.response || error);
            
            let errorMessage = "Une erreur inconnue est survenue.";
            
            if (error.response && error.response.data && error.response.data.message) {
                errorMessage = error.response.data.message; // Message venant du PHP
            } else if (error.request) {
                errorMessage = "Impossible de contacter le serveur API. Vérifiez la connexion.";
            }

            setErrors({ general: errorMessage });
        } finally {
            setLoading(false);
        }
    };

    // --- Rendu du Formulaire ---
    return (
        <div className="flex justify-center items-center min-h-screen bg-gray-100 p-4">
            <div className="w-full max-w-md bg-white p-8 rounded-lg shadow-xl">
                <h2 className="text-3xl font-bold text-gray-800 mb-6 text-center">
                    Créer un Compte
                </h2>

                {/* Affichage des messages et erreurs */}
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
                    
                    {/* ... (Reste du formulaire inchangé, seul l'onChange de la photo a été adapté pour utiliser handleFileChange) ... */}
                    
                    {/* Nom Complet */}
                    <div>
                        <label htmlFor="nomComplet" className="block text-sm font-medium text-gray-700">Nom Complet</label>
                        <input
                            type="text"
                            id="nomComplet"
                            name="nomComplet"
                            value={formData.nomComplet}
                            onChange={handleChange}
                            //required 
                            className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            placeholder="Ex: Jean Dupont"
                        />
                    </div>

                    {/* Email */}
                    <div>
                        <label htmlFor="email" className="block text-sm font-medium text-gray-700">Adresse Email</label>
                        <input
                            type="email" // Changement de 'text' à 'email' pour validation HTML
                            id="email"
                            name="email"
                            value={formData.email}
                            onChange={handleChange}
                            //required
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
                            //required
                            className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            placeholder="Minimum 8 caractères"
                        />
                    </div>

                    {/* Photo (Fichier) */}
                    <div>
                        <label htmlFor="photo" className="block text-sm font-medium text-gray-700">Photo de Profil (Optionnel)</label>
                        <input
                            type="file"
                            id="photo"
                            name="photo"
                            accept="image/*"
                            onChange={handleFileChange} 
                            className="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100"
                        />
                    </div>

                    {/* Rôle */}
                    <div>
                        <label htmlFor="role" className="block text-sm font-medium text-gray-700">Je suis...</label>
                        <select
                            id="role"
                            name="role"
                            value={formData.role}
                            onChange={handleChange}
                            //required
                            className="mt-1 block w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                        >
                            <option value="etudiant">Étudiant</option>
                            <option value="formateur">Formateur</option>
                        </select>
                    </div>

                    {/* Spécialité (Affichage Conditionnel) */}
                    {formData.role === 'formateur' && (
                        <div>
                            <label htmlFor="specialite" className="block text-sm font-medium text-gray-700">Spécialité (Domaine d'expertise)</label>
                            <input
                                type="text"
                                id="specialite"
                                name="specialite"
                                value={formData.specialite}
                                onChange={handleChange}
                                //required={formData.role === 'formateur'}
                                className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                placeholder="Ex: Développement Web, Marketing Digital..."
                            />
                        </div>
                    )}

                    {/* Bouton de Soumission */}
                    <button
                        type="submit"
                        disabled={loading}
                        className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition duration-150 disabled:bg-indigo-400"
                    >
                        {loading ? 'Inscription en cours...' : "S'inscrire"}
                    </button>
                </form>

                <p className="mt-6 text-center text-sm text-gray-600">
                    Déjà un compte ? <Link to="/connexion" className="font-medium text-indigo-600 hover:text-indigo-500">Connectez-vous ici</Link>
                </p>
            </div>
        </div>
    );
};

export default InscrireUtilisateur;