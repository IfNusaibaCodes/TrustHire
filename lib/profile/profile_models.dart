class ProfileModel {
  final String?   id;
  final String?   firstName;
  final String?   lastName;
  final String?   email;
  final String?   phone;
  final String?   location;
  final String?   university;
  final String?   studyYear;
  final String?   bio;
  final String?   cvUrl;
  final bool      universityIdVerified;
  final DateTime? updatedAt;

  const ProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.location,
    this.university,
    this.studyYear,
    this.bio,
    this.cvUrl,
    this.universityIdVerified = false,
    this.updatedAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id:                   map['id']                      as String?,
      firstName:            map['first_name']              as String?,
      lastName:             map['last_name']               as String?,
      email:                map['email']                   as String?,
      phone:                map['phone']                   as String?,
      location:             map['location']                as String?,
      university:           map['university']              as String?,
      studyYear:            map['study_year']              as String?,
      bio:                  map['bio']                     as String?,
      cvUrl:                map['cv_url']                  as String?,
      universityIdVerified:(map['university_id_verified']  as bool?) ?? false,
      updatedAt:            map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null)                  map['id']                     = id;
    if (firstName != null)           map['first_name']             = firstName;
    if (lastName != null)            map['last_name']              = lastName;
    if (email != null)               map['email']                  = email;
    if (phone != null)               map['phone']                  = phone;
    if (location != null)            map['location']               = location;
    if (university != null)          map['university']             = university;
    if (studyYear != null)           map['study_year']             = studyYear;
    if (bio != null)                 map['bio']                    = bio;
    if (cvUrl != null)               map['cv_url']                 = cvUrl;
    map['university_id_verified'] = universityIdVerified;
    if (updatedAt != null)           map['updated_at']             = updatedAt!.toIso8601String();
    return map;
  }

  ProfileModel copyWith(Map<String, dynamic> updates) {
    return ProfileModel(
      id:                   id,
      firstName:            updates['first_name']             as String? ?? firstName,
      lastName:             updates['last_name']              as String? ?? lastName,
      email:                updates['email']                  as String? ?? email,
      phone:                updates['phone']                  as String? ?? phone,
      location:             updates['location']               as String? ?? location,
      university:           updates['university']             as String? ?? university,
      studyYear:            updates['study_year']             as String? ?? studyYear,
      bio:                  updates['bio']                    as String? ?? bio,
      cvUrl:                updates['cv_url']                 as String? ?? cvUrl,
      universityIdVerified: updates['university_id_verified'] as bool?   ?? universityIdVerified,
      updatedAt:            updatedAt,
    );
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  String get initials {
    final f = (firstName ?? '').trim();
    final l = (lastName  ?? '').trim();
    if (f.isNotEmpty && l.isNotEmpty) return '${f[0]}${l[0]}'.toUpperCase();
    if (f.isNotEmpty) return f[0].toUpperCase();
    return '?';
  }

  @override
  String toString() => 'ProfileModel(id: $id, name: $fullName, email: $email)';
}


class SkillModel {
  final String    id;
  final String    userId;
  final String    name;
  final DateTime? createdAt;

  const SkillModel({
    required this.id,
    required this.userId,
    required this.name,
    this.createdAt,
  });

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      id:        map['id']      as String,
      userId:    map['user_id'] as String,
      name:      map['name']    as String,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id':      id,
      'user_id': userId,
      'name':    name,
    };
    if (createdAt != null) map['created_at'] = createdAt!.toIso8601String();
    return map;
  }
}


class ExperienceModel {
  final String    id;
  final String    userId;
  final String    title;
  final String    company;
  final String?   startDate;
  final String?   endDate;
  final bool      isCurrent;
  final DateTime? createdAt;

  const ExperienceModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.company,
    this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.createdAt,
  });

  factory ExperienceModel.fromMap(Map<String, dynamic> map) {
    return ExperienceModel(
      id:        map['id']         as String,
      userId:    map['user_id']    as String,
      title:     map['title']      as String,
      company:   map['company']    as String,
      startDate: map['start_date'] as String?,
      endDate:   map['end_date']   as String?,
      isCurrent:(map['is_current'] as bool?) ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id':         id,
      'user_id':    userId,
      'title':      title,
      'company':    company,
      'is_current': isCurrent,
    };
    if (startDate != null) map['start_date'] = startDate;
    if (endDate   != null) map['end_date']   = endDate;
    if (createdAt != null) map['created_at'] = createdAt!.toIso8601String();
    return map;
  }
}


class ProfileStats {
  final String? userId;
  final int     appliedCount;
  final int     profileViews;
  final int     savedCount;

  const ProfileStats({
    this.userId,
    this.appliedCount = 0,
    this.profileViews = 0,
    this.savedCount   = 0,
  });

  factory ProfileStats.fromMap(Map<String, dynamic> map) {
    return ProfileStats(
      userId:       map['user_id']       as String?,
      appliedCount:(map['applied_count'] as int?) ?? 0,
      profileViews:(map['profile_views'] as int?) ?? 0,
      savedCount:  (map['saved_count']   as int?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'applied_count': appliedCount,
      'profile_views': profileViews,
      'saved_count':   savedCount,
    };
    if (userId != null) map['user_id'] = userId;
    return map;
  }
}