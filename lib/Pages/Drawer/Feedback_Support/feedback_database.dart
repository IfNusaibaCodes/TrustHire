import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../Model/feedback_model.dart';


class FeedbackService {
  static final _client = Supabase.instance.client;

  static Future<void> submitFeedback({
    required String feature,
    required String rating,
    String? problem,
    String? suggestion,
    String? email,
    String? phone,
  }) async {
    final uid = _client.auth.currentUser?.id;

    final model = FeedbackModel(
      id:         '',
      userId:     uid,
      feature:    feature,
      rating:     rating,
      problem:    problem,
      suggestion: suggestion,
      email:      email,
      phone:      phone,
    );

    await _client.from('feedback').insert(model.toInsertMap());
  }

  static Future<List<FeedbackModel>> fetchAllFeedback() async {
    final data = await _client
        .from('feedback')
        .select()
        .order('created_at', ascending: false);
    return (data as List).map((e) => FeedbackModel.fromMap(e)).toList();
  }

  static Future<void> deleteFeedback(String id) async {
    await _client.from('feedback').delete().eq('id', id);
  }
}
