import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/profile/profile_models.dart';

class ProfileDatabase {
  final _db = Supabase.instance.client;

  Future<ProfileModel> loadProfile(String uid) async {
    final response = await _db
        .from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();
    if (response == null) {
      await _db.from('profiles').insert({'id': uid});
      return ProfileModel();
    }
    return ProfileModel.fromMap(response);
  }

  Future<List<SkillModel>> loadSkills(String uid) async {
    final response = await _db
        .from('skills')
        .select()
        .eq('user_id', uid)
        .order('created_at');
    return (response as List).map((e) => SkillModel.fromMap(e)).toList();
  }

  Future<List<ExperienceModel>> loadExperiences(String uid) async {
    final response = await _db
        .from('experiences')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false);
    return (response as List).map((e) => ExperienceModel.fromMap(e)).toList();
  }

  Future<ProfileStats> loadStats(String uid) async {
    final response = await _db
        .from('profile_stats')
        .select()
        .eq('user_id', uid)
        .maybeSingle();
    if (response == null) {
      await _db.from('profile_stats').insert({'user_id': uid});
      return ProfileStats();
    }
    return ProfileStats.fromMap(response);
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> updates) async {
    await _db.from('profiles').update({
      ...updates,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', uid);
  }

  Future<SkillModel> addSkill(String uid, String name) async {
    final response = await _db
        .from('skills')
        .insert({'user_id': uid, 'name': name.trim()})
        .select()
        .single();
    return SkillModel.fromMap(response);
  }

  Future<void> deleteSkill(String skillId) async {
    await _db.from('skills').delete().eq('id', skillId);
  }

  Future<ExperienceModel> addExperience(String uid, Map<String, dynamic> data) async {
    final response = await _db.from('experiences').insert({
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
    await _db.from('experiences').delete().eq('id', expId);
  }
}