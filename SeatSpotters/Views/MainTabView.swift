import SwiftUI

struct MainTabView: View {
  var body: some View {
    TabView {
      BrowseEventsView()
        .tabItem {
          Label("Browse", systemImage: "magnifyingglass")
        }
      
      SocialFeedView()
        .tabItem {
          Label("Friends", systemImage: "person.2.fill")
        }
      
      AdminDashboardView()
        .tabItem {
          Label("Admin", systemImage: "chart.line.uptrend.xyaxis")
        }
      
      SettingsView()
        .tabItem {
          Label("Account", systemImage: "gear")
        }
    }
    .accentColor(.neonBlue)
  }
}

struct NeonTheme {
  static let background = Color(red: 0.05, green: 0.05, blue: 0.15)
  static let neonBlue = Color(red: 0.02, green: 0.64, blue: 1.0)
  static let cardBackground = Color(red: 0.1, green: 0.1, blue: 0.2)
}
