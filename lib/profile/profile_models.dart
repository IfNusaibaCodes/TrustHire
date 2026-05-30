
class ProfileModel {
  final String? phone;
  final String? location;
  final String? university;
  final String? studyYear;
  final String? bio;
  final String? cvUrl;
  final bool universityIdVerified;

  ProfileModel({
    this.phone,
    this.location,
    this.university,
    this.studyYear,
    this.bio,
    this.cvUrl,
    this.universityIdVerified = false,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) => ProfileModel(
    phone: map['phone'],
    location: map['location'],
    university: map['university'],
    studyYear: map['study_year'],
    bio: map['bio'],
    cvUrl: map['cv_url'],
    universityIdVerified: map['university_id_verified'] ?? false,
  );

  Map<String, dynamic> toMap() => {
    'phone': phone,
    'location': location,
    'university': university,
    'study_year': studyYear,
    'bio': bio,
    'cv_url': cvUrl,
    'university_id_verified': universityIdVerified,
  };

  ProfileModel copyWith(Map<String, dynamic> updates) => ProfileModel.fromMap({
    ...toMap(),
    ...updates,
  });
}

// ─────────────────────────────────────────────────────────────

class SkillModel {
  final String id;
  final String name;

  SkillModel({required this.id, required this.name});

  factory SkillModel.fromMap(Map<String, dynamic> map) => SkillModel(
    id: map['id'],
    name: map['name'],
  );

  Map<String, dynamic> toMap() => {'id': id, 'name': name};
}

// ─────────────────────────────────────────────────────────────

class ExperienceModel {
  final String id;
  final String title;
  final String company;
  final String? startDate;
  final String? endDate;
  final bool isCurrent;

  ExperienceModel({
    required this.id,
    required this.title,
    required this.company,
    this.startDate,
    this.endDate,
    this.isCurrent = false,
  });

  factory ExperienceModel.fromMap(Map<String, dynamic> map) => ExperienceModel(
    id: map['id'],
    title: map['title'],
    company: map['company'],
    startDate: map['start_date'],
    endDate: map['end_date'],
    isCurrent: map['is_current'] ?? false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'company': company,
    'start_date': startDate,
    'end_date': endDate,
    'is_current': isCurrent,
  };
}

// ─────────────────────────────────────────────────────────────

class ProfileStats {
  final int appliedCount;
  final int profileViews;
  final int savedCount;

  ProfileStats({
    this.appliedCount = 0,
    this.profileViews = 0,
    this.savedCount = 0,
  });

  factory ProfileStats.fromMap(Map<String, dynamic> map) => ProfileStats(
    appliedCount: map['applied_count'] ?? 0,
    profileViews: map['profile_views'] ?? 0,
    savedCount: map['saved_count'] ?? 0,
  );
}