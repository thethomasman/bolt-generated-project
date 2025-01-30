import SwiftUI
import Supabase

@main
struct SeatSpottersApp: App {
  @StateObject private var authManager = AuthManager()
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  var body: some Scene {
    WindowGroup {
      Group {
        if authManager.isAuthenticated {
          MainTabView()
            .transition(.opacity)
        } else {
          AuthView()
            .transition(.asymmetric(
              insertion: .opacity,
              removal: .scale
            ))
        }
      }
      .animation(.easeInOut(duration: 0.3), value: authManager.isAuthenticated)
      .environmentObject(authManager)
      .preferredColorScheme(.dark)
      .onOpenURL { url in
        authManager.handleAuthCallback(url: url)
      }
      .task {
        await authManager.checkSession()
      }
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    // Configure deep links and other app setup
    return true
  }
}
