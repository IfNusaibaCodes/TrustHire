class JobModel {
  final int id;
  final String? extId;
  final int? companyId;
  final String? companyName;
  final String? companyLogo;
  final String? companyWebsiteUrl;
  final String? companyLinkedinUrl;
  final String? companyYoutubeUrl;
  final String? companyTwitterHandle;
  final String? companyGithubUrl;
  final bool? companyIsAgency;
  final String? title;
  final String? location;
  final String? typePrimary;
  final String? typeSecondary;
  final String? cityAsciiName;
  final String? cityName;
  final String? cityCountryName;
  final bool? hasRemote;
  final DateTime? published;
  final String? experienceLevel;
  final String? applicationUrl;
  final String? language;
  final String? salaryCurrency;
  final String? descriptionMd;

  const JobModel({
    required this.id,
    this.extId,
    this.companyId,
    this.companyName,
    this.companyLogo,
    this.companyWebsiteUrl,
    this.companyLinkedinUrl,
    this.companyYoutubeUrl,
    this.companyTwitterHandle,
    this.companyGithubUrl,
    this.companyIsAgency,
    this.title,
    this.location,
    this.typePrimary,
    this.typeSecondary,
    this.cityAsciiName,
    this.cityName,
    this.cityCountryName,
    this.hasRemote,
    this.published,
    this.experienceLevel,
    this.applicationUrl,
    this.language,
    this.salaryCurrency,
    this.descriptionMd,
  });

  /// Creates a [JobModel] from a Supabase row map.
  factory JobModel.fromMap(Map<String, dynamic> map) {
    // Support both flat slash-key style ("company/id") and nested map style.
    final Map<String, dynamic>? company = map['company'] as Map<String, dynamic>?;
    final List<dynamic>? types  = map['types']  as List<dynamic>?;
    final List<dynamic>? cities = map['cities'] as List<dynamic>?;

    // Safely extract typed sub-maps from lists.
    final Map<String, dynamic>? type0 =
    (types != null && types.isNotEmpty) ? types[0] as Map<String, dynamic>? : null;
    final Map<String, dynamic>? type1 =
    (types != null && types.length > 1) ? types[1] as Map<String, dynamic>? : null;
    final Map<String, dynamic>? city0 =
    (cities != null && cities.isNotEmpty) ? cities[0] as Map<String, dynamic>? : null;
    final Map<String, dynamic>? city0Country =
    city0 != null ? city0['country'] as Map<String, dynamic>? : null;

    return JobModel(
      id:                  map['id'] as int,
      extId:               map['ext_id'] as String?,
      companyId:           _parseInt(map['company/id']            ?? company?['id']),
      companyName:         _parseStr(map['company/name']          ?? company?['name']),
      companyLogo:         _parseStr(map['company/logo']          ?? company?['logo']),
      companyWebsiteUrl:   _parseStr(map['company/website_url']   ?? company?['website_url']),
      companyLinkedinUrl:  _parseStr(map['company/linkedin_url']  ?? company?['linkedin_url']),
      companyYoutubeUrl:   _parseStr(map['company/youtube_url']   ?? company?['youtube_url']),
      companyTwitterHandle:_parseStr(map['company/twitter_handle']?? company?['twitter_handle']),
      companyGithubUrl:    _parseStr(map['company/github_url']    ?? company?['github_url']),
      companyIsAgency:     (map['company/is_agency'] ?? company?['is_agency']) as bool?,
      title:               map['title']    as String?,
      location:            map['location'] as String?,
      typePrimary:         (type0?['name']       ?? map['types/0/name'])         as String?,
      typeSecondary:       (type1?['name']       ?? map['types/1/name'])         as String?,
      cityAsciiName:       (city0?['asciiname']  ?? map['cities/0/asciiname'])   as String?,
      cityName:            (city0?['name']       ?? map['cities/0/name'])        as String?,
      cityCountryName:     (city0Country?['name']?? map['cities/0/country/name'])as String?,
      hasRemote:           map['has_remote'] as bool?,
      published:           map['published'] != null
          ? DateTime.tryParse(map['published'] as String)
          : null,
      experienceLevel:     map['experience_level'] as String?,
      applicationUrl:      map['application_url']  as String?,
      language:            map['language']          as String?,
      salaryCurrency:      map['salary_currency']   as String?,
      descriptionMd:       map['description_md']    as String?,
    );
  }

  /// Converts this model back to a map suitable for Supabase inserts/updates.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'id': id};
    if (extId != null)               map['ext_id']                  = extId;
    if (companyId != null)           map['company/id']              = companyId;
    if (companyName != null)         map['company/name']            = companyName;
    if (companyLogo != null)         map['company/logo']            = companyLogo;
    if (companyWebsiteUrl != null)   map['company/website_url']     = companyWebsiteUrl;
    if (companyLinkedinUrl != null)  map['company/linkedin_url']    = companyLinkedinUrl;
    if (companyYoutubeUrl != null)   map['company/youtube_url']     = companyYoutubeUrl;
    if (companyTwitterHandle != null)map['company/twitter_handle']  = companyTwitterHandle;
    if (companyGithubUrl != null)    map['company/github_url']      = companyGithubUrl;
    if (companyIsAgency != null)     map['company/is_agency']       = companyIsAgency;
    if (title != null)               map['title']                   = title;
    if (location != null)            map['location']                = location;
    if (typePrimary != null)         map['types/0/name']            = typePrimary;
    if (typeSecondary != null)       map['types/1/name']            = typeSecondary;
    if (cityAsciiName != null)       map['cities/0/asciiname']      = cityAsciiName;
    if (cityName != null)            map['cities/0/name']           = cityName;
    if (cityCountryName != null)     map['cities/0/country/name']   = cityCountryName;
    if (hasRemote != null)           map['has_remote']              = hasRemote;
    if (published != null)           map['published']               = published!.toIso8601String();
    if (experienceLevel != null)     map['experience_level']        = experienceLevel;
    if (applicationUrl != null)      map['application_url']         = applicationUrl;
    if (language != null)            map['language']                = language;
    if (salaryCurrency != null)      map['salary_currency']         = salaryCurrency;
    if (descriptionMd != null)       map['description_md']          = descriptionMd;
    return map;
  }

  JobModel copyWith({
    int? id,
    String? extId,
    int? companyId,
    String? companyName,
    String? companyLogo,
    String? companyWebsiteUrl,
    String? companyLinkedinUrl,
    String? companyYoutubeUrl,
    String? companyTwitterHandle,
    String? companyGithubUrl,
    bool? companyIsAgency,
    String? title,
    String? location,
    String? typePrimary,
    String? typeSecondary,
    String? cityAsciiName,
    String? cityName,
    String? cityCountryName,
    bool? hasRemote,
    DateTime? published,
    String? experienceLevel,
    String? applicationUrl,
    String? language,
    String? salaryCurrency,
    String? descriptionMd,
  }) {
    return JobModel(
      id:                   id                   ?? this.id,
      extId:                extId                ?? this.extId,
      companyId:            companyId            ?? this.companyId,
      companyName:          companyName          ?? this.companyName,
      companyLogo:          companyLogo          ?? this.companyLogo,
      companyWebsiteUrl:    companyWebsiteUrl    ?? this.companyWebsiteUrl,
      companyLinkedinUrl:   companyLinkedinUrl   ?? this.companyLinkedinUrl,
      companyYoutubeUrl:    companyYoutubeUrl    ?? this.companyYoutubeUrl,
      companyTwitterHandle: companyTwitterHandle ?? this.companyTwitterHandle,
      companyGithubUrl:     companyGithubUrl     ?? this.companyGithubUrl,
      companyIsAgency:      companyIsAgency      ?? this.companyIsAgency,
      title:                title                ?? this.title,
      location:             location             ?? this.location,
      typePrimary:          typePrimary          ?? this.typePrimary,
      typeSecondary:        typeSecondary        ?? this.typeSecondary,
      cityAsciiName:        cityAsciiName        ?? this.cityAsciiName,
      cityName:             cityName             ?? this.cityName,
      cityCountryName:      cityCountryName      ?? this.cityCountryName,
      hasRemote:            hasRemote            ?? this.hasRemote,
      published:            published            ?? this.published,
      experienceLevel:      experienceLevel      ?? this.experienceLevel,
      applicationUrl:       applicationUrl       ?? this.applicationUrl,
      language:             language             ?? this.language,
      salaryCurrency:       salaryCurrency       ?? this.salaryCurrency,
      descriptionMd:        descriptionMd        ?? this.descriptionMd,
    );
  }

  @override
  String toString() => 'JobModel(id: $id, title: $title, company: $companyName)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is JobModel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  // ── helpers ──────────────────────────────────────────────────────────────

  static int? _parseInt(dynamic v) =>
      v == null ? null : int.tryParse(v.toString());

  static String? _parseStr(dynamic v) => v?.toString();
}