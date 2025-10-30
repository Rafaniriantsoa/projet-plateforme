-- 1. Table UTILISATEUR
CREATE TABLE UTILISATEUR (
    id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    photo VARCHAR (255),
    role ENUM('etudiant', 'formateur', 'admin') NOT NULL
);

-- 2. Table COURS
CREATE TABLE COURS (
    id_cours INT AUTO_INCREMENT PRIMARY KEY,
    id_formateur INT NOT NULL,
    titre VARCHAR(255) NOT NULL,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_formateur) REFERENCES UTILISATEUR(id_utilisateur)
);

-- 3. Table LECON (rattachée directement à COURS, nécessite l'attribut 'ordre')
CREATE TABLE LECON (
    id_lecon INT AUTO_INCREMENT PRIMARY KEY,
    id_cours INT NOT NULL,
    titre_lecon VARCHAR(255) NOT NULL,
    contenu VARCHAR(255), -- Lien vers le fichier/URL
    ordre INT NOT NULL,  -- ESSENTIEL pour définir la séquence dans le cours
    FOREIGN KEY (id_cours) REFERENCES COURS(id_cours) ON DELETE CASCADE
);

-- 4. Table QUIZ (rattachée directement à COURS)
CREATE TABLE QUIZ (
    id_quiz INT AUTO_INCREMENT PRIMARY KEY,
    id_cours INT NOT NULL,
    titre_quiz VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_cours) REFERENCES COURS(id_cours) ON DELETE CASCADE
);

-- 5. Table QUESTION (Questions simples)
CREATE TABLE QUESTION (
    id_question INT AUTO_INCREMENT PRIMARY KEY,
    id_quiz INT NOT NULL,
    texte_question TEXT NOT NULL,
    reponse_attendue VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_quiz) REFERENCES QUIZ(id_quiz) ON DELETE CASCADE
);

-- 6. INSCRIPTION
CREATE TABLE INSCRIPTION (
    id_utilisateur INT,
    id_cours INT,
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut ENUM('En cours', 'Terminé', 'Abandonné') NOT NULL DEFAULT 'En cours',
    PRIMARY KEY (id_utilisateur, id_cours),
    FOREIGN KEY (id_utilisateur) REFERENCES UTILISATEUR(id_utilisateur) ON DELETE CASCADE,
    FOREIGN KEY (id_cours) REFERENCES COURS(id_cours) ON DELETE CASCADE
);

-- 7. PROGRESSION (Suivi des leçons)
CREATE TABLE PROGRESSION (
    id_utilisateur INT,
    id_lecon INT,
    etat_lecon ENUM('Vue', 'Terminée') NOT NULL,
    PRIMARY KEY (id_utilisateur, id_lecon),
    FOREIGN KEY (id_utilisateur) REFERENCES UTILISATEUR(id_utilisateur) ON DELETE CASCADE,
    FOREIGN KEY (id_lecon) REFERENCES LECON(id_lecon) ON DELETE CASCADE
);

-- 8. RESULTAT_QUIZ (Score global)
CREATE TABLE RESULTAT_QUIZ (
    id_resultat INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_quiz INT NOT NULL,
    score_obtenu DECIMAL(5, 2),
    date_passage TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_utilisateur) REFERENCES UTILISATEUR(id_utilisateur) ON DELETE CASCADE,
    FOREIGN KEY (id_quiz) REFERENCES QUIZ(id_quiz) ON DELETE CASCADE
);

-- 9. REPONSE_UTILISATEUR (Détail par question)
CREATE TABLE REPONSE_UTILISATEUR (
    id_utilisateur INT,
    id_question INT,
    reponse_donnee TEXT NOT NULL,
    est_correct BOOLEAN NOT NULL,
    PRIMARY KEY (id_utilisateur, id_question),
    FOREIGN KEY (id_utilisateur) REFERENCES UTILISATEUR(id_utilisateur) ON DELETE CASCADE,
    FOREIGN KEY (id_question) REFERENCES QUESTION(id_question) ON DELETE CASCADE
);

-- 10. NOTE (Évaluation)
CREATE TABLE NOTE (
    id_note INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_cours INT NOT NULL,
    valeur INT CHECK (valeur BETWEEN 1 AND 5),
    commentaire TEXT,
    date_note TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_utilisateur) REFERENCES UTILISATEUR(id_utilisateur) ON DELETE CASCADE,
    FOREIGN KEY (id_cours) REFERENCES COURS(id_cours) ON DELETE CASCADE,
    UNIQUE (id_utilisateur, id_cours)
);