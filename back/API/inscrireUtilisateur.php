<?php
// ===================================================
// 1. CONFIGURATION DE L'API ET DE LA BASE DE DONNÉES
// ===================================================

header("Access-Control-Allow-Origin: *"); 
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, OPTIONS"); // Inclure OPTIONS ici
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// 💡 GESTION DE LA REQUÊTE PRÉLIMINAIRE (OPTIONS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200); // Répondre immédiatement avec un statut OK (200)
    exit(); // Stopper l'exécution du reste du script
}

// --- Paramètres de connexion MySQL ---
$host = "localhost";
$db_name = "projet";
$username = "root";
$password = "";

// Nom de la table
$table_name = "UTILISATEUR"; // J'utilise 'UTILISATEUR' par cohérence avec le reste

// Connexion à la base de données
try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $exception) {
    http_response_code(500);
    echo json_encode(["message" => "Erreur de connexion à la base de données: " . $exception->getMessage()]);
    exit();
}

// ===============================================
// 2. RÉCUPÉRATION ET PRÉPARATION DES DONNÉES
// ===============================================

// Vérifier si la méthode est POST (après le bloc OPTIONS)
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["message" => "Méthode non autorisée. Seul POST est accepté."]);
    exit();
}

// Les données JSON du frontend React
$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    // Si la requête est multipart/form-data (pour le fichier), $data sera vide
    $data = $_POST;
}

// Vérification des champs obligatoires
if (empty($data['nomComplet']) || empty($data['email']) || empty($data['motDePasse']) || empty($data['role'])) {
    http_response_code(400);
    echo json_encode(["message" => "Veuillez fournir un nom complet, email, mot de passe et rôle."]);
    exit();
}

// Nettoyage et hachage
$nomComplet = trim($data['nomComplet']);
$email = filter_var($data['email'], FILTER_SANITIZE_EMAIL);
$role = $data['role']; 

// 🐛 CORRECTION DE LA CLÉ INDÉFINIE (Warning: Undefined array key "specialite")
// Utilise l'opérateur de coalescence nul (??) pour garantir que $specialite est une chaîne vide si la clé n'existe pas
$specialite = $data['specialite'] ?? '';

$mot_de_passe_hache = password_hash($data['motDePasse'], PASSWORD_BCRYPT);
$photo_path = null;


// ===============================================
// 3. GESTION DU TÉLÉCHARGEMENT DE LA PHOTO
// ===============================================

// ... (La section 3 reste inchangée, elle est déjà correcte) ...

if (isset($_FILES['photo']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
    $upload_dir = 'uploads/photos/';
    if (!is_dir($upload_dir)) {
        mkdir($upload_dir, 0777, true);
    }

    $file_tmp = $_FILES['photo']['tmp_name'];
    $file_ext = strtolower(pathinfo($_FILES['photo']['name'], PATHINFO_EXTENSION));
    $allowed_extensions = ['jpg', 'jpeg', 'png', 'gif'];

    if (in_array($file_ext, $allowed_extensions)) {
        // Nom unique basé sur l'email (pour éviter les doublons)
        $file_name = uniqid() . '-' . md5($email) . '.' . $file_ext;
        $photo_path = $upload_dir . $file_name;

        if (!move_uploaded_file($file_tmp, $photo_path)) {
             http_response_code(500);
             echo json_encode(["message" => "Erreur lors du déplacement du fichier photo."]);
             exit();
        }
    } else {
        http_response_code(400);
        echo json_encode(["message" => "Format de fichier non autorisé. Utilisez JPG, PNG ou GIF."]);
        exit();
    }
}


// ===============================================
// 4. INSERTION DANS LA BASE DE DONNÉES
// ===============================================

$query = "INSERT INTO " . $table_name . " 
          SET nom_complet = :nomComplet,
              email = :email, 
              mot_de_passe = :mot_de_passe,
              photo = :photo,
              role = :role,
              specialite = :specialite";

$stmt = $conn->prepare($query);

// Liaison des paramètres (Binding)
$stmt->bindParam(':nomComplet', $nomComplet);
$stmt->bindParam(':email', $email);
$stmt->bindParam(':mot_de_passe', $mot_de_passe_hache);
$stmt->bindParam(':photo', $photo_path);
$stmt->bindParam(':role', $role);
$stmt->bindParam(':specialite', $specialite);

try {
    if ($stmt->execute()) {
        http_response_code(201); // Created
        echo json_encode(["message" => "Inscription réussie. Utilisateur créé."]);
    } else {
        http_response_code(500);
        echo json_encode(["message" => "Échec de l'inscription."]);
    }
} catch (PDOException $e) {
    // ⭐ GESTION EXPLICITE DU DOUBLON D'EMAIL (CONTRAINTE UNIQUE)
    if ($e->getCode() == '23000') { 
        http_response_code(409); // Conflict
        echo json_encode(["message" => "L'adresse email est déjà utilisée."]);
    } else {
        http_response_code(500);
        echo json_encode(["message" => "Erreur base de données: " . $e->getMessage()]);
    }
}

// Fin du script PHP
?>