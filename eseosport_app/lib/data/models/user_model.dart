class UserModel {
  final int? id;
  final String nom;
  final String prenom;
  final String email;

  UserModel({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Méthode pour convertir un UserModel en Map, pour l'insertion dans la base de données
  Map<String, dynamic> toMap() {
    return {
      'id_user': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }

  // Méthode pour créer un UserModel à partir d'une Map, pour la récupération depuis la base de données
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id_user'],
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
    );
  }
}
