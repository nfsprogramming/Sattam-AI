import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SupabaseService {
  static const String _supabaseUrl = 'https://gtfctrbfbkcubsswfhze.supabase.co';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd0ZmN0cmJmYmtjdWJzc3dmaHplIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM3ODEyMzksImV4cCI6MjA5OTM1NzIzOX0.kgaBxdTjkggcFvN_yUc7Q6VF280bdgEtiO9joiQxsFk';

  // TODO: Replace these with your actual Client IDs from Google Cloud Console
  static const String _webClientId = '507974029556-435akl98gipvl52dvuomj9meqm68b7p1.apps.googleusercontent.com';
  static const String _iosClientId = 'YOUR_IOS_CLIENT_ID_HERE.apps.googleusercontent.com';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      // ignore: deprecated_member_use
      anonKey: _supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  // ==========================================
  // AUTHENTICATION API
  // ==========================================

  static Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: _webClientId,
      clientId: _iosClientId,
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in was canceled.');
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) {
      throw Exception('No ID Token found.');
    }

    await client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  // ==========================================
  // CASES API
  // ==========================================

  static Future<List<Map<String, dynamic>>> getCases() async {
    final response = await client
        .from('cases')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> createCase({
    required String title,
    String status = 'Pending',
    String? nextHearing,
    String? description,
  }) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not logged in');

    await client.from('cases').insert({
      'user_id': userId,
      'title': title,
      'status': status,
      'next_hearing': ?nextHearing,
      'description': ?description,
    });
  }

  // ==========================================
  // CHAT HISTORY API
  // ==========================================

  static Future<List<Map<String, dynamic>>> getChatSessions() async {
    final response = await client
        .from('chat_sessions')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<String> createChatSession({String title = 'New Conversation'}) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not logged in');

    final response = await client.from('chat_sessions').insert({
      'user_id': userId,
      'title': title,
    }).select('id').single();
    
    return response['id'] as String;
  }

  static Future<List<Map<String, dynamic>>> getMessages(String sessionId) async {
    final response = await client
        .from('messages')
        .select()
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> saveMessage({
    required String sessionId,
    required String role,
    required String content,
  }) async {
    await client.from('messages').insert({
      'session_id': sessionId,
      'role': role,
      'content': content,
    });
  }

  // ==========================================
  // PHASE 3: LAWYERS & PROFILES API
  // ==========================================

  static Future<Map<String, dynamic>?> getProfile() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return null;
    
    try {
      final response = await client.from('profiles').select().eq('id', userId).maybeSingle();
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<void> createProfile(String name) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not logged in');

    await client.from('profiles').upsert({
      'id': userId,
      'name': name,
      'role': 'citizen',
    });
  }

  static Future<List<Map<String, dynamic>>> getVerifiedLawyers() async {
    final response = await client
        .from('lawyers')
        .select()
        .eq('status', 'verified')
        .order('rating', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> applyForLawyerVerification({
    required String name,
    required String barCouncilId,
    required String specialization,
    required String experience,
    required String location,
  }) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not logged in');

    await client.from('lawyers').upsert({
      'id': userId,
      'name': name,
      'bar_council_id': barCouncilId,
      'specialization': specialization,
      'experience': experience,
      'location': location,
      'status': 'pending',
    });
    
    // Optionally update profile role to lawyer
    await client.from('profiles').update({'role': 'lawyer'}).eq('id', userId);
  }
}
