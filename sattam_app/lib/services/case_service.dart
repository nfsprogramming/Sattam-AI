import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_case.dart';

class CaseService {
  static final _supabase = Supabase.instance.client;

  /// Fetches all cases for the currently authenticated user
  static Future<List<UserCase>> getUserCases() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('cases')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => UserCase.fromJson(json)).toList();
  }

  /// Adds a new case to Supabase
  static Future<UserCase> addCase({
    required String title,
    String? description,
    String status = 'Active',
    DateTime? nextHearingDate,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('cases')
        .insert({
          'user_id': userId,
          'title': title,
          'description': description,
          'status': status,
          'next_hearing_date': nextHearingDate?.toIso8601String(),
        })
        .select()
        .single();

    return UserCase.fromJson(response);
  }

  /// Updates the status or hearing date of a case
  static Future<void> updateCase({
    required String caseId,
    String? status,
    DateTime? nextHearingDate,
  }) async {
    final updates = <String, dynamic>{};
    if (status != null) updates['status'] = status;
    if (nextHearingDate != null) updates['next_hearing_date'] = nextHearingDate.toIso8601String();

    if (updates.isNotEmpty) {
      await _supabase.from('cases').update(updates).eq('id', caseId);
    }
  }

  /// Deletes a case
  static Future<void> deleteCase(String caseId) async {
    await _supabase.from('cases').delete().eq('id', caseId);
  }
}
