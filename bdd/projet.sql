-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 30 oct. 2025 à 06:02
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `projet`
--

-- --------------------------------------------------------

--
-- Structure de la table `cours`
--

CREATE TABLE `cours` (
  `id_cours` int(11) NOT NULL,
  `id_formateur` int(11) NOT NULL,
  `titre` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `date_creation` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `inscription`
--

CREATE TABLE `inscription` (
  `id_utilisateur` int(11) NOT NULL,
  `id_cours` int(11) NOT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `statut` enum('En cours','Terminé','Abandonné') NOT NULL DEFAULT 'En cours'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `lecon`
--

CREATE TABLE `lecon` (
  `id_lecon` int(11) NOT NULL,
  `id_cours` int(11) NOT NULL,
  `titre_lecon` varchar(255) NOT NULL,
  `contenu` varchar(255) DEFAULT NULL,
  `ordre` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `note`
--

CREATE TABLE `note` (
  `id_note` int(11) NOT NULL,
  `id_utilisateur` int(11) NOT NULL,
  `id_cours` int(11) NOT NULL,
  `valeur` int(11) DEFAULT NULL CHECK (`valeur` between 1 and 5),
  `commentaire` text DEFAULT NULL,
  `date_note` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `progression`
--

CREATE TABLE `progression` (
  `id_utilisateur` int(11) NOT NULL,
  `id_lecon` int(11) NOT NULL,
  `etat_lecon` enum('Vue','Terminée') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `question`
--

CREATE TABLE `question` (
  `id_question` int(11) NOT NULL,
  `id_quiz` int(11) NOT NULL,
  `texte_question` text NOT NULL,
  `reponse_attendue` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `quiz`
--

CREATE TABLE `quiz` (
  `id_quiz` int(11) NOT NULL,
  `id_cours` int(11) NOT NULL,
  `titre_quiz` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `reponse_utilisateur`
--

CREATE TABLE `reponse_utilisateur` (
  `id_utilisateur` int(11) NOT NULL,
  `id_question` int(11) NOT NULL,
  `reponse_donnee` text NOT NULL,
  `est_correct` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `resultat_quiz`
--

CREATE TABLE `resultat_quiz` (
  `id_resultat` int(11) NOT NULL,
  `id_utilisateur` int(11) NOT NULL,
  `id_quiz` int(11) NOT NULL,
  `score_obtenu` decimal(5,2) DEFAULT NULL,
  `date_passage` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id_utilisateur` int(11) NOT NULL,
  `nom_complet` varchar(255) NOT NULL,
  `email` varchar(150) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `role` enum('etudiant','formateur','admin') NOT NULL,
  `specialite` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id_utilisateur`, `nom_complet`, `email`, `mot_de_passe`, `photo`, `role`, `specialite`) VALUES
(1, 'Avotra', 'avotra@gmail', '$2y$10$Nt.rwDVhxl6JyPDy0qzatOjD8USj1g1Pk3/BCX2DeTf/cy0Yhe6na', 'uploads/photos/69025815cfbeb-2f543d2e815d2d281a0a9391f3a17b9e.png', 'formateur', 'développeur web'),
(2, 'Avotra', 'marie.lambert@example.com', '$2y$10$ZR3xpkziDMajmJ4dWAXZ7eUsH08aZTLDgM./ZvKu9b7CzZI9CqPii', 'uploads/photos/69025952ac19d-75b1ef69fd1803577d3208f0b29c054c.png', 'formateur', '45'),
(3, '45', '5@l', '$2y$10$HPmHNiTmTKhQTfYdzzf.meNE/LR/e8YFkxC2WFK5oxL9U8MPkjX5K', NULL, 'formateur', '3'),
(4, 'mpianatra', 'mpianatra@gmail.com', '$2y$10$qQHF3vIJ8SKMQ0qNie3hD.a/sFnd8A1R4Kq5UgxIEb/0bWbx8FBnS', NULL, 'etudiant', NULL),
(5, 'fghfghfghgfhfghfgh', 'gnhhgjgjhgj@hhnb', '$2y$10$20i1Z.Nax2HHB/q/0iNtfek0iEku0gEzDXTX.8HZnCPcv9KIg9aXK', NULL, 'etudiant', NULL),
(6, 'dupont', 'dupont@gmail', '$2y$10$nhz2otdUhz8uNMQ4Thd.LezfMb9FkFtYoSbbQfsqJFfKsdMd.eRo2', 'uploads/photos/690263e633a3c-460e31ea7ccc33f8de4089b99647b4e5.png', 'etudiant', NULL),
(7, 'Avotra', 'RR@FGH', '$2y$10$1Oli8OHcy3BttO4X4nf/ie1fE3fWO4OtYNwArKelB3W.GGHAIFYES', NULL, 'etudiant', NULL);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `cours`
--
ALTER TABLE `cours`
  ADD PRIMARY KEY (`id_cours`),
  ADD KEY `id_formateur` (`id_formateur`);

--
-- Index pour la table `inscription`
--
ALTER TABLE `inscription`
  ADD PRIMARY KEY (`id_utilisateur`,`id_cours`),
  ADD KEY `id_cours` (`id_cours`);

--
-- Index pour la table `lecon`
--
ALTER TABLE `lecon`
  ADD PRIMARY KEY (`id_lecon`),
  ADD KEY `id_cours` (`id_cours`);

--
-- Index pour la table `note`
--
ALTER TABLE `note`
  ADD PRIMARY KEY (`id_note`),
  ADD UNIQUE KEY `id_utilisateur` (`id_utilisateur`,`id_cours`),
  ADD KEY `id_cours` (`id_cours`);

--
-- Index pour la table `progression`
--
ALTER TABLE `progression`
  ADD PRIMARY KEY (`id_utilisateur`,`id_lecon`),
  ADD KEY `id_lecon` (`id_lecon`);

--
-- Index pour la table `question`
--
ALTER TABLE `question`
  ADD PRIMARY KEY (`id_question`),
  ADD KEY `id_quiz` (`id_quiz`);

--
-- Index pour la table `quiz`
--
ALTER TABLE `quiz`
  ADD PRIMARY KEY (`id_quiz`),
  ADD KEY `id_cours` (`id_cours`);

--
-- Index pour la table `reponse_utilisateur`
--
ALTER TABLE `reponse_utilisateur`
  ADD PRIMARY KEY (`id_utilisateur`,`id_question`),
  ADD KEY `id_question` (`id_question`);

--
-- Index pour la table `resultat_quiz`
--
ALTER TABLE `resultat_quiz`
  ADD PRIMARY KEY (`id_resultat`),
  ADD KEY `id_utilisateur` (`id_utilisateur`),
  ADD KEY `id_quiz` (`id_quiz`);

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`id_utilisateur`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `cours`
--
ALTER TABLE `cours`
  MODIFY `id_cours` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `lecon`
--
ALTER TABLE `lecon`
  MODIFY `id_lecon` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `note`
--
ALTER TABLE `note`
  MODIFY `id_note` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `question`
--
ALTER TABLE `question`
  MODIFY `id_question` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `quiz`
--
ALTER TABLE `quiz`
  MODIFY `id_quiz` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `resultat_quiz`
--
ALTER TABLE `resultat_quiz`
  MODIFY `id_resultat` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id_utilisateur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `cours`
--
ALTER TABLE `cours`
  ADD CONSTRAINT `cours_ibfk_1` FOREIGN KEY (`id_formateur`) REFERENCES `utilisateur` (`id_utilisateur`);

--
-- Contraintes pour la table `inscription`
--
ALTER TABLE `inscription`
  ADD CONSTRAINT `inscription_ibfk_1` FOREIGN KEY (`id_utilisateur`) REFERENCES `utilisateur` (`id_utilisateur`) ON DELETE CASCADE,
  ADD CONSTRAINT `inscription_ibfk_2` FOREIGN KEY (`id_cours`) REFERENCES `cours` (`id_cours`) ON DELETE CASCADE;

--
-- Contraintes pour la table `lecon`
--
ALTER TABLE `lecon`
  ADD CONSTRAINT `lecon_ibfk_1` FOREIGN KEY (`id_cours`) REFERENCES `cours` (`id_cours`) ON DELETE CASCADE;

--
-- Contraintes pour la table `note`
--
ALTER TABLE `note`
  ADD CONSTRAINT `note_ibfk_1` FOREIGN KEY (`id_utilisateur`) REFERENCES `utilisateur` (`id_utilisateur`) ON DELETE CASCADE,
  ADD CONSTRAINT `note_ibfk_2` FOREIGN KEY (`id_cours`) REFERENCES `cours` (`id_cours`) ON DELETE CASCADE;

--
-- Contraintes pour la table `progression`
--
ALTER TABLE `progression`
  ADD CONSTRAINT `progression_ibfk_1` FOREIGN KEY (`id_utilisateur`) REFERENCES `utilisateur` (`id_utilisateur`) ON DELETE CASCADE,
  ADD CONSTRAINT `progression_ibfk_2` FOREIGN KEY (`id_lecon`) REFERENCES `lecon` (`id_lecon`) ON DELETE CASCADE;

--
-- Contraintes pour la table `question`
--
ALTER TABLE `question`
  ADD CONSTRAINT `question_ibfk_1` FOREIGN KEY (`id_quiz`) REFERENCES `quiz` (`id_quiz`) ON DELETE CASCADE;

--
-- Contraintes pour la table `quiz`
--
ALTER TABLE `quiz`
  ADD CONSTRAINT `quiz_ibfk_1` FOREIGN KEY (`id_cours`) REFERENCES `cours` (`id_cours`) ON DELETE CASCADE;

--
-- Contraintes pour la table `reponse_utilisateur`
--
ALTER TABLE `reponse_utilisateur`
  ADD CONSTRAINT `reponse_utilisateur_ibfk_1` FOREIGN KEY (`id_utilisateur`) REFERENCES `utilisateur` (`id_utilisateur`) ON DELETE CASCADE,
  ADD CONSTRAINT `reponse_utilisateur_ibfk_2` FOREIGN KEY (`id_question`) REFERENCES `question` (`id_question`) ON DELETE CASCADE;

--
-- Contraintes pour la table `resultat_quiz`
--
ALTER TABLE `resultat_quiz`
  ADD CONSTRAINT `resultat_quiz_ibfk_1` FOREIGN KEY (`id_utilisateur`) REFERENCES `utilisateur` (`id_utilisateur`) ON DELETE CASCADE,
  ADD CONSTRAINT `resultat_quiz_ibfk_2` FOREIGN KEY (`id_quiz`) REFERENCES `quiz` (`id_quiz`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
