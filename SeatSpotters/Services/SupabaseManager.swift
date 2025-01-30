import Foundation
import Supabase

class SupabaseManager {
  static let shared = SupabaseManager()
  
  let client = SupabaseClient(
    supabaseURL: URL(string: "https://nkskujheggjfmxahuvdv.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5rc2t1amhlZ2dqZm14YWh1dmR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgwMjc0MDUsImV4cCI6MjA1MzYwMzQwNX0.8PqaN7cIqMnVfT32u0eTRLHvoUKjfabiDxOfuOMKU1A"
  )
  
  // Website-specific tables RLS policies
  enum RLSPolicies {
    static let websiteEventsRead = """
      CREATE POLICY "Enable read access for all users" ON "website_events"
      AS PERMISSIVE FOR SELECT
      TO public
      USING (true)
      """
      
    static let userProfileOwner = """
      CREATE POLICY "User can access own profile" ON "website_user_profiles"
      AS PERMISSIVE FOR ALL
      TO public
      USING (id = auth.uid())
      """
  }
  
  func configureWebsiteRLS() async {
    do {
      try await client.database.execute(RLSPolicies.websiteEventsRead)
      try await client.database.execute(RLSPolicies.userProfileOwner)
    } catch {
      print("RLS configuration failed: \(error)")
    }
  }
  
  private init() {}
}
