import SwiftUI

struct WebsiteSyncView: View {
  @StateObject private var syncService = WebsiteSyncService()
  @State private var websiteEvents: [WebsiteEvent] = []
  @State private var userProfile: WebsiteUserProfile?
  
  var body: some View {
    List {
      Section("Synced Events") {
        ForEach(websiteEvents) { event in
          WebsiteEventRow(event: event)
        }
      }
      
      Section("Your Website Profile") {
        if let profile = userProfile {
          UserProfileSection(profile: profile)
        }
      }
    }
    .task {
      await loadData()
      syncService.observeWebsiteChanges()
    }
    .onReceive(NotificationCenter.default.publisher(for: .websiteDataUpdated)) { _ in
      Task { await loadData() }
    }
  }
  
  private func loadData() async {
    do {
      websiteEvents = try await syncService.syncEvents()
      userProfile = try await syncService.fetchWebsiteUserProfile()
    } catch {
      print("Sync error: \(error)")
    }
  }
}

struct WebsiteEventRow: View {
  let event: WebsiteEvent
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(event.title)
          .font(.headline)
        
        Spacer()
        
        Text(event.current_price.formatted(.currency(code: "USD")))
          .foregroundColor(NeonTheme.neonBlue)
      }
      
      Text(event.venue_name)
        .font(.subheadline)
      
      HStack {
        Text(event.start_time.formatted(date: .abbreviated, time: .shortened))
        Text("-")
        Text(event.end_time.formatted(date: .abbreviated, time: .shortened))
      }
      .font(.caption)
    }
  }
}
