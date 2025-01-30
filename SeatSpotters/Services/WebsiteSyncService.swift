import Foundation
import Supabase

class WebsiteSyncService {
  static let shared = WebsiteSyncService()
  private let supabase = SupabaseManager.shared.client
  
  // MARK: - Event Synchronization
  func syncEvents() async throws -> [WebsiteEvent] {
    let events: [WebsiteEvent] = try await supabase.database
      .from("website_events")
      .select("""
        id,
        title,
        description,
        venue_name,
        start_time,
        end_time,
        base_price,
        current_price,
        ticket_types,
        ai_price_suggestion,
        seat_map_url,
        social_score,
        created_at
      """)
      .order("start_time", ascending: true)
      .execute()
      .value
    
    return events
  }
  
  // MARK: - User Profile Sync
  func fetchWebsiteUserProfile() async throws -> WebsiteUserProfile {
    guard let userId = AuthManager.shared.currentUser?.id else {
      throw NSError(domain: "Auth", code: 401)
    }
    
    let profile: WebsiteUserProfile = try await supabase.database
      .from("website_user_profiles")
      .select()
      .eq("id", userId)
      .single()
      .execute()
      .value
    
    return profile
  }
  
  // MARK: - Ticket Availability Check
  func checkTicketAvailability(eventId: String, ticketTypeId: String) async throws -> Int {
    let count: Int = try await supabase.database.rpc(
      "check_ticket_availability",
      params: ["event_id": eventId, "ticket_type_id": ticketTypeId]
    )
    .execute()
    .value
    
    return count
  }
  
  // MARK: - Real-time Website Updates
  func observeWebsiteChanges() {
    let channel = supabase.realtime.channel("website_updates")
    
    channel
      .on(.postgresChanges, schema: "public") { change in
        print("Website data changed:", change)
        NotificationCenter.default.post(
          name: .websiteDataUpdated,
          object: change
        )
      }
      .subscribe()
  }
}

extension Notification.Name {
  static let websiteDataUpdated = Notification.Name("websiteDataUpdated")
}
