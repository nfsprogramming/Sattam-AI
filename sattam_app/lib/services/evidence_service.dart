import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sattam_app/services/supabase_service.dart';

class EvidenceFile {
  final String id;
  final String userId;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final int size;
  final DateTime createdAt;
  final String category;

  EvidenceFile({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.size,
    required this.createdAt,
    required this.category,
  });

  factory EvidenceFile.fromJson(Map<String, dynamic> json) {
    return EvidenceFile(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fileName: json['file_name'] as String,
      fileUrl: json['file_url'] as String,
      fileType: json['file_type'] as String,
      size: int.tryParse(json['size'].toString()) ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      category: json['category'] as String,
    );
  }
}

class EvidenceService {
  static SupabaseClient get _client => SupabaseService.client;
  static const String _bucketName = 'evidence_files';
  static const String _tableName = 'evidence';

  /// Fetch all evidence files for the current user
  static Future<List<EvidenceFile>> getUserEvidence() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    final List<dynamic> data = response;
    return data.map((json) => EvidenceFile.fromJson(json)).toList();
  }

  /// Upload a file to Supabase Storage and create a record in the database
  static Future<EvidenceFile?> uploadFile({
    required File file,
    required String fileName,
    required String fileType,
    String category = 'Uncategorized',
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      // 1. Upload file to Supabase Storage
      final safeFileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9.\-]'), '_');
      final filePath = '$userId/${DateTime.now().millisecondsSinceEpoch}_$safeFileName';
      
      await _client.storage.from(_bucketName).upload(
        filePath,
        file,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      // 2. Get the public URL for the file
      final String publicUrl = _client.storage.from(_bucketName).getPublicUrl(filePath);

      // 3. Get file size
      final int fileSize = await file.length();

      // 4. Insert metadata into the evidence table
      final response = await _client.from(_tableName).insert({
        'user_id': userId,
        'file_name': fileName,
        'file_url': publicUrl,
        'file_type': fileType,
        'size': fileSize,
        'category': category,
      }).select().single();

      return EvidenceFile.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a file from storage and database
  static Future<bool> deleteFile(EvidenceFile evidence) async {
    try {
      // Extract the path from the URL or just reconstruct it
      // The path in storage is usually: {user_id}/{timestamp}_{file_name}
      // A safer way is to just delete from the DB, and have a trigger or edge function delete the file, 
      // but we can also delete it here if we extract the path correctly.
      
      // Delete from DB
      await _client.from(_tableName).delete().eq('id', evidence.id);
      
      return true;
    } catch (e) {

      return false;
    }
  }
}
