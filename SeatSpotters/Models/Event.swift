import Foundation

struct Event: Identifiable {
  let id = UUID()
  let title: String
  let location: String
  let date: Date
  let startingPrice: Double
  let imageUrl: String
  let demandLevel: DemandLevel
}

enum DemandLevel: String {
  case low, medium, high
}

let mockEvents = [
  Event(
    title: "Global Music Festival",
    location: "Los Angeles Stadium",
    date: Date().addingTimeInterval(86400 * 3),
    startingPrice: 199,
    imageUrl: "https://example.com/event1.jpg",
    demandLevel: .high
  ),
  Event(
    title: "Championship Finals",
    location: "Madison Square Garden",
    date: Date().addingTimeInterval(86400 * 5),
    startingPrice: 299,
    imageUrl: "https://example.com/event2.jpg",
    demandLevel: .medium
  )
]
