import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Authentication/Services/auth_service.dart';
import 'package:trust_hire_app/profile/profile_models.dart';

class ProfileDatabase {
  final client = Supabase.instance.client;
  final authService = AuthService();

  String _getRequiredUid() {
    final uid = authService.getCurrentUid();
    if (uid == null) {
      throw Exception("User is not logged in.");
    }
    return uid;
  }

  Future<ProfileModel> loadProfile() async {
    final uid = _getRequiredUid();

    final response = await client
        .from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();

    if (response == null) {
      await client.from('profiles').insert({'id': uid});
      return ProfileModel();
    }
    return ProfileModel.fromMap(response);
  }

  Future<List<SkillModel>> loadSkills() async {
    final uid = _getRequiredUid();
    final response = await client
        .from('skills')
        .select()
        .eq('user_id', uid)
        .order('created_at');
    return (response as List).map((e) => SkillModel.fromMap(e)).toList();
  }

  Future<List<ExperienceModel>> loadExperiences() async {
    final uid = _getRequiredUid();
    final response = await client
        .from('experiences')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false);
    return (response as List).map((e) => ExperienceModel.fromMap(e)).toList();
  }

  Future<ProfileStats> loadStats() async {
    final uid = _getRequiredUid();
    final response = await client
        .from('profile_stats')
        .select()
        .eq('user_id', uid)
        .maybeSingle();
    if (response == null) {
      await client.from('profile_stats').insert({'user_id': uid});
      return ProfileStats();
    }
    return ProfileStats.fromMap(response);
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    final uid = _getRequiredUid();

    await client.from('profiles').update({
      ...updates,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', uid);
  }

  Future<SkillModel> addSkill(String name) async {
    final uid = _getRequiredUid();
    final response = await client
        .from('skills')
        .insert({'user_id': uid, 'name': name.trim()})
        .select()
        .single();
    return SkillModel.fromMap(response);
  }

  Future<void> deleteSkill(String skillId) async {
    await client.from('skills').delete().eq('id', skillId);
  }

  Future<ExperienceModel> addExperience(Map<String, dynamic> data) async {
    final uid = _getRequiredUid();
    final response = await client.from('experiences').insert({
      'user_id':    uid,
      'title':      data['title'],
      'company':    data['company'],
      'start_date': data['start'],
      'end_date':   data['end'],
      'is_current': data['is_current'] ?? false,
    }).select().single();
    return ExperienceModel.fromMap(response);
  }

  Future<void> deleteExperience(String expId) async {
    await client.from('experiences').delete().eq('id', expId);
  }
}