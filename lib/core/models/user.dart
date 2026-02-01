/// Minimal user model aligned with the backend template.
///
/// The backend sometimes uses `id` and sometimes `userId` in responses.
/// Adjust this model once the exact API response shape is finalized.
class User {
  const User({required this.id, required this.email});

  final String id;
  final String email;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] ?? json['userId']).toString(),
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'email': email};
}
