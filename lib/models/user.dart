class User {
  final int? id;
  final String nombre;
  final String email;
  final int edad;

  User({
    this.id,
    required this.nombre,
    required this.email,
    required this.edad,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'edad': edad,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nombre: map['nombre'],
      email: map['email'],
      edad: map['edad'],
    );
  }
}