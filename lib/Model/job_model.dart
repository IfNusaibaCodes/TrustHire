class JobModel {
  JobModel({
    required this.id,
    required this.extId,
    required this.company,
    required this.title,
    required this.location,
    required this.types,
    required this.cities,
    required this.states,
    required this.countries,
    required this.regions,
    required this.hasRemote,
    required this.published,
    required this.experienceLevel,
    required this.applicationUrl,
    required this.language,
    required this.salaryMin,
    required this.salaryMax,
    required this.salaryCurrency,
    required this.descriptionMd,
  });

  final int? id;
  final String? extId;
  final Company? company;
  final String? title;
  final String? location;
  final List<Region> types;
  final List<City> cities;
  final List<States> states;
  final List<Country> countries;
  final List<Region> regions;
  final bool? hasRemote;
  final DateTime? published;
  final String? experienceLevel;
  final String? applicationUrl;
  final String? language;
  final dynamic salaryMin;
  final dynamic salaryMax;
  final String? salaryCurrency;
  final String? descriptionMd;

  factory JobModel.fromJson(Map<String, dynamic> json){
    return JobModel(
      id: json["id"],
      extId: json["ext_id"],
      company: json["company"] == null ? null : Company.fromJson(json["company"]),
      title: json["title"],
      location: json["location"],
      types: json["types"] == null ? [] : List<Region>.from(json["types"]!.map((x) => Region.fromJson(x))),
      cities: json["cities"] == null ? [] : List<City>.from(json["cities"]!.map((x) => City.fromJson(x))),
      states: json["states"] == null ? [] : List<States>.from(json["states"]!.map((x) => States.fromJson(x))),
      countries: json["countries"] == null ? [] : List<Country>.from(json["countries"]!.map((x) => Country.fromJson(x))),
      regions: json["regions"] == null ? [] : List<Region>.from(json["regions"]!.map((x) => Region.fromJson(x))),
      hasRemote: json["has_remote"],
      published: DateTime.tryParse(json["published"] ?? ""),
      experienceLevel: json["experience_level"],
      applicationUrl: json["application_url"],
      language: json["language"],
      salaryMin: json["salary_min"],
      salaryMax: json["salary_max"],
      salaryCurrency: json["salary_currency"],
      descriptionMd: json["description_md"],
    );
  }

}

class City {
  City({
    required this.geonameid,
    required this.asciiname,
    required this.name,
    required this.country,
    required this.state,
    required this.timezone,
    required this.latitude,
    required this.longitude,
    required this.population,
  });

  final int? geonameid;
  final String? asciiname;
  final String? name;
  final Country? country;
  final States? state;
  final String? timezone;
  final String? latitude;
  final String? longitude;
  final int? population;

  factory City.fromJson(Map<String, dynamic> json){
    return City(
      geonameid: json["geonameid"],
      asciiname: json["asciiname"],
      name: json["name"],
      country: json["country"] == null ? null : Country.fromJson(json["country"]),
      state: json["state"] == null ? null : States.fromJson(json["state"]),
      timezone: json["timezone"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      population: json["population"],
    );
  }

}

class Country {
  Country({
    required this.id,
    required this.code,
    required this.name,
    required this.region,
  });

  final int? id;
  final String? code;
  final String? name;
  final Region? region;

  factory Country.fromJson(Map<String, dynamic> json){
    return Country(
      id: json["id"],
      code: json["code"],
      name: json["name"],
      region: json["region"] == null ? null : Region.fromJson(json["region"]),
    );
  }

}

class Region {
  Region({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  factory Region.fromJson(Map<String, dynamic> json){
    return Region(
      id: json["id"],
      name: json["name"],
    );
  }

}

class States {
  States({
    required this.geonameid,
    required this.code,
    required this.asciiname,
    required this.name,
    required this.country,
  });

  final int? geonameid;
  final String? code;
  final String? asciiname;
  final String? name;
  final Country? country;

  factory States.fromJson(Map<String, dynamic> json){
    return States(
      geonameid: json["geonameid"],
      code: json["code"],
      asciiname: json["asciiname"],
      name: json["name"],
      country: json["country"] == null ? null : Country.fromJson(json["country"]),
    );
  }

}

class Company {
  Company({
    required this.id,
    required this.sourceId,
    required this.name,
    required this.logo,
    required this.websiteUrl,
    required this.linkedinUrl,
    required this.youtubeUrl,
    required this.twitterHandle,
    required this.githubUrl,
    required this.isAgency,
  });

  final int? id;
  final int? sourceId;
  final String? name;
  final String? logo;
  final String? websiteUrl;
  final String? linkedinUrl;
  final String? youtubeUrl;
  final String? twitterHandle;
  final dynamic githubUrl;
  final bool? isAgency;

  factory Company.fromJson(Map<String, dynamic> json){
    return Company(
      id: json["id"],
      sourceId: json["source_id"],
      name: json["name"],
      logo: json["logo"],
      websiteUrl: json["website_url"],
      linkedinUrl: json["linkedin_url"],
      youtubeUrl: json["youtube_url"],
      twitterHandle: json["twitter_handle"],
      githubUrl: json["github_url"],
      isAgency: json["is_agency"],
    );
  }

}
