import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Replace these with your actual Supabase project credentials.
const String supabaseUrl = 'https://racmwghxjcddxyhmxfcf.supabase.co';
const String supabaseAnonKey = 'sb_publishable_YUsM8xwGrIYZkaSRAKTscA_OaT8hsaY';

/// Provides the Supabase client singleton throughout the app.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
