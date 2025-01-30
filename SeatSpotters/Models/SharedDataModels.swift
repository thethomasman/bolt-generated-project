import Foundation

// MARK: - Unified Data Models
struct WebsiteEvent: Codable, Identifiable {
  let id: String
  let title: String
  let description: String
  let venue_name: String
  let start_time: Date
  let end_time: Date
  let base_price: Double
  let current_price: Double
  let ticket_types: [TicketType]
  let ai_price_suggestion: Double?
  let seat_map_url: String
  let social_score: Double
  let created_at: Date
}

struct TicketType: Codable {
  let id: String
  let name: String
  let price: Double
  let quantity_available: Int
  let perks: [String]
}

struct WebsiteUserProfile: Codable {
  let id: String
  let website_id: String
  let social_connections: [String]
  let ticket_wallet: [OwnedTicket]
  let purchase_history: [Transaction]
  let ai_preferences: AIPreferences
}

struct AIPreferences: Codable {
  let favorite_genres: [String]
  let price_sensitivity: Double
  let preferred_venues: [String]
  let social_activity_level: Double
}

struct OwnedTicket: Codable {
  let ticket_id: String
  let event_id: String
  let transfer_status: String
  let purchase_date: Date
}

struct Transaction: Codable {
  let id: String
  let amount: Double
  let payment_method: String
  let status: String
  let timestamp: Date
}
