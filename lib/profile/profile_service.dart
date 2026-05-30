
import 'package:trust_hire_app/profile/profile_models.dart';


class ProfileService {

  Future<ProfileModel> loadProfile(String uid) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ProfileModel(
      phone: '01759613090',
      location: 'Sylhet, Bangladesh',
      university: 'Leading University',
      studyYear: '3rd Year',
      bio: 'Flutter developer passionate about building clean, user-friendly apps.',
      cvUrl: '',
      universityIdVerified: false,
    );
  }

  Future<List<SkillModel>> loadSkills(String uid) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      SkillModel(id: 'sk-1', name: 'Flutter'),
      SkillModel(id: 'sk-2', name: 'Dart'),
      SkillModel(id: 'sk-3', name: 'UI/UX'),
      SkillModel(id: 'sk-4', name: 'Firebase'),
    ];
  }

  Future<List<ExperienceModel>> loadExperiences(String uid) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      ExperienceModel(
        id: 'ex-1',
        title: 'Flutter Intern',
        company: 'TechCo BD',
        startDate: 'Jun 2024',
        endDate: 'Aug 2024',
        isCurrent: false,
      ),
      ExperienceModel(
        id: 'ex-2',
        title: 'Junior Developer',
        company: 'StartupXYZ',
        startDate: 'Sep 2024',
        endDate: 'Present',
        isCurrent: true,
      ),
    ];
  }

  Future<ProfileStats> loadStats(String uid) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ProfileStats(appliedCount: 7, profileViews: 34, savedCount: 12);
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<SkillModel> addSkill(String uid, String name) async {
    final tempId = 'local-${DateTime.now().millisecondsSinceEpoch}';
    return SkillModel(id: tempId, name: name.trim());
  }

  Future<void> deleteSkill(String skillId) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<ExperienceModel> addExperience(String uid, Map<String, dynamic> data) async {
    final tempId = 'local-${DateTime.now().millisecondsSinceEpoch}';
    return ExperienceModel(
      id: tempId,
      title: data['title'],
      company: data['company'],
      startDate: data['start'],
      endDate: data['end'],
      isCurrent: data['is_current'] ?? false,
    );
  }

  Future<void> deleteExperience(String expId) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}