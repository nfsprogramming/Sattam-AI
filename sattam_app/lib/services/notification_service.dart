import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';

class NotificationService {
  static final _client = Supabase.instance.client;
  static const _tableName = 'notifications';

  /// Fetch all notifications for the current user, ordered by newest first
  static Future<List<AppNotification>> getUserNotifications() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List).map((e) => AppNotification.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      return [];
    }
  }

  /// Mark a single notification as read
  static Future<bool> markAsRead(String notificationId) async {
    try {
      await _client
          .from(_tableName)
          .update({'is_read': true})
          .eq('id', notificationId);
      return true;
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      return false;
    }
  }

  /// Mark all notifications as read for the current user
  static Future<bool> markAllAsRead() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      await _client
          .from(_tableName)
          .update({'is_read': true})
          .eq('user_id', userId);
      return true;
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
      return false;
    }
  }

  /// Delete a specific notification
  static Future<bool> deleteNotification(String notificationId) async {
    try {
      await _client
          .from(_tableName)
          .delete()
          .eq('id', notificationId);
      return true;
    } catch (e) {
      debugPrint('Error deleting notification: $e');
      return false;
    }
  }

  /// Setup a realtime stream to listen for new notifications
  static Stream<List<AppNotification>> streamUserNotifications() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return const Stream.empty();

    return _client
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((maps) => maps.map((e) => AppNotification.fromJson(e)).toList());
  }
}
