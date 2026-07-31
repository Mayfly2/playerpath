import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String userType;
  final bool isVerified;
  final bool isPremium;
  final String? profilePhotoUrl;

  const User({
    required this.id,
    required this.email,
    required this.userType,
    this.isVerified = false,
    this.isPremium = false,
    this.profilePhotoUrl,
  });

  bool get isPlayer => userType == 'player';
  bool get isClub => userType == 'club';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      userType: json['userType'],
      isVerified: json['isVerified'] ?? false,
      isPremium: json['isPremium'] ?? false,
      profilePhotoUrl: json['profilePhotoUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'userType': userType,
        'isVerified': isVerified,
        'isPremium': isPremium,
      };

  @override
  List<Object?> get props => [id, email, userType, isVerified, isPremium];
}
