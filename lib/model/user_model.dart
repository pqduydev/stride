class UserModel {
  final int? id;
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? accessToken;
  final String? refreshToken;
  final String? phone;
  final DateTime? dateOfBirth;
  final double? heightCm;
  final double? weightKg;
  final String? bio;
  final DateTime? dateJoined;

  UserModel({
    this.id,
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.fullName,
    this.accessToken,
    this.refreshToken,
    this.phone,
    this.dateOfBirth,
    this.heightCm,
    this.weightKg,
    this.bio,
    this.dateJoined,
  });

  /// Getter trả về tên hiển thị ưu tiên trên UI
  String get displayName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    final combined = '$last $first'.trim();
    return combined.isNotEmpty ? combined : username;
  }

  // Hàm lấy chữ cái đầu của last_name và first_name cho avatar
  String get displayInitials {
    final lastInitial = (lastName != null && lastName!.trim().isNotEmpty)
        ? lastName!.trim()[0].toUpperCase()
        : '';
    final firstInitial = (firstName != null && firstName!.trim().isNotEmpty)
        ? firstName!.split(' ').last[0].toUpperCase()
        : '';

    final initials = '$lastInitial$firstInitial';
    return initials.isNotEmpty ? initials : '';
  }

  /// Khởi tạo UserModel từ JSON (Tự động thích ứng cả API Login lẫn API Get Profile)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Kiểm tra JSON có cấu trúc lồng {"user": {...}} như API Login hay không
    final bool isNested =
        json.containsKey('user') && json['user'] is Map<String, dynamic>;
    final Map<String, dynamic> userData = isNested
        ? (json['user'] as Map<String, dynamic>)
        : json;

    return UserModel(
      id: userData['id'] as int?,
      username: userData['username'] as String? ?? '',
      email: userData['email'] as String?,
      firstName: userData['first_name'] as String?,
      lastName: userData['last_name'] as String?,
      fullName: userData['full_name'] as String?,

      // Token chỉ có ở root khi gọi API Login
      accessToken: json['access'] as String?,
      refreshToken: json['refresh'] as String?,

      phone: userData['phone'] as String?,
      dateOfBirth: userData['date_of_birth'] != null
          ? DateTime.tryParse(userData['date_of_birth'].toString())
          : null,
      heightCm: (userData['height_cm'] as num?)?.toDouble(),
      weightKg: (userData['weight_kg'] as num?)?.toDouble(),
      bio: userData['bio'] as String?,
      dateJoined: userData['date_joined'] != null
          ? DateTime.tryParse(userData['date_joined'].toString())
          : null,
    );
  }

  Map<String, dynamic> toUpdateProfileJson() {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T').first,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'bio': bio,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'access': accessToken,
      'refresh': refreshToken,
      'phone': phone,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T').first,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'bio': bio,
      'date_joined': dateJoined?.toIso8601String(),
    };
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? fullName,
    String? accessToken,
    String? refreshToken,
    String? phone,
    DateTime? dateOfBirth,
    double? heightCm,
    double? weightKg,
    String? bio,
    DateTime? dateJoined,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      bio: bio ?? this.bio,
      dateJoined: dateJoined ?? this.dateJoined,
    );
  }
}
