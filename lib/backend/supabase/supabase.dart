import 'package:supabase_flutter/supabase_flutter.dart';

export 'database/database.dart';

String _kSupabaseUrl = 'https://igzdcohmreqbujqediex.supabase.co';
String _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlnemRjb2htcmVxYnVqcWVkaWV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4NTA2MDcsImV4cCI6MjA5ODQyNjYwN30.KjZ_D-VT_Mh4B65Mt5yADPfarvRwzM7adPZ29fuq4I4';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        headers: {
          'X-Client-Info': 'flutterflow',
        },
        anonKey: _kSupabaseAnonKey,
        debug: false,
        authOptions:
            FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
      );
}
