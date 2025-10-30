import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
// Laissez useNavigate si vous voulez utiliser navigate('/') au lieu de window.location.reload()
// import { useNavigate } from 'react-router-dom'; 

const Deconnexion = () => {
    // const navigate = useNavigate(); // Décommentez si nécessaire

    // 1. État pour gérer l'ouverture/fermeture de la modale
    const [isModalOpen, setIsModalOpen] = useState(false);
    const navigate = useNavigate();
    // Fonction déclenchée par le clic sur le bouton "Déconnexion"
    const handleLogoutClick = () => {
        setIsModalOpen(true); // Ouvre la modale de confirmation
    };

    // Fonction déclenchée par la confirmation dans la modale
    const handleConfirmLogout = () => {
        // 1. Fermer la modale
        setIsModalOpen(false);

        // 2. 🗑️ Effacer l'utilisateur du stockage local
        localStorage.removeItem('utilisateur');

        setTimeout(() => {
            navigate('/')
            window.location.reload();
            // Si vous ne voulez pas recharger, utilisez navigate('/')
        }, 1000);

        // Ou : navigate('/');
    };

    return (
        <>
            {/* Bouton principal : Ouvre la modale */}
            <button
                onClick={handleLogoutClick}
                className="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-md hover:bg-red-700 transition duration-150"
            >
                Déconnexion
            </button>

            {/* 2. Affichage conditionnel de la Modale */}
            {isModalOpen && (
                // L'overlay (fond noir transparent)
                <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex justify-center items-center">

                    {/* La boîte de dialogue modale */}
                    <div className="bg-white p-6 rounded-lg shadow-2xl w-full max-w-sm">
                        <h3 className="text-xl font-bold mb-4 text-gray-800">
                            Confirmer la Déconnexion ⚠️
                        </h3>
                        <p className="mb-6 text-gray-600">
                            Êtes-vous sûr de vouloir vous déconnecter de votre compte ?
                        </p>

                        {/* Boutons d'action */}
                        <div className="flex justify-end space-x-3">
                            <button
                                // Ferme la modale sans se déconnecter
                                onClick={() => setIsModalOpen(false)}
                                className="px-4 py-2 text-sm font-medium text-gray-700 border border-gray-300 rounded-md hover:bg-gray-100 transition"
                            >
                                Annuler
                            </button>
                            <button
                                // Confirme la déconnexion
                                onClick={handleConfirmLogout}
                                className="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-md hover:bg-red-700 transition"
                            >
                                Oui, Déconnecter
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </>
    );
};

export default Deconnexion;