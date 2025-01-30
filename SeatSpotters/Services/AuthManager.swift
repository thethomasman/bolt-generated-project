import Foundation
import Supabase
import AuthenticationServices

class AuthManager: ObservableObject {
  @Published var currentUser: User?
  @Published var isAuthenticated = false
  @Published var isLoading = false
  @Published var errorMessage: String?
  
  private let supabase = SupabaseManager.shared.client
  
  func signInWithApple() async {
    await handleAuthFlow(provider: .apple)
  }
  
  func signInWithGoogle() async {
    await handleAuthFlow(provider: .google)
  }
  
  private func handleAuthFlow(provider: Provider) async {
    DispatchQueue.main.async {
      self.isLoading = true
      self.errorMessage = nil
    }
    
    do {
      let session = try await supabase.auth.signInWithOAuth(
        provider: provider,
        redirectTo: URL(string: "seatspotters://auth-callback")
      )
      
      DispatchQueue.main.async {
        self.currentUser = session.user
        self.isAuthenticated = true
        self.isLoading = false
      }
    } catch {
      DispatchQueue.main.async {
        self.errorMessage = error.localizedDescription
        self.isLoading = false
      }
    }
  }
  
  func signOut() async {
    do {
      try await supabase.auth.signOut()
      DispatchQueue.main.async {
        self.currentUser = nil
        self.isAuthenticated = false
      }
    } catch {
      DispatchQueue.main.async {
        self.errorMessage = error.localizedDescription
      }
    }
  }
}

extension AuthManager {
  func handleAuthCallback(url: URL) {
    Task {
      do {
        try await supabase.auth.session(from: url)
        await checkSession()
      } catch {
        DispatchQueue.main.async {
          self.errorMessage = error.localizedDescription
        }
      }
    }
  }
  
  func checkSession() async {
    do {
      let session = try await supabase.auth.session
      DispatchQueue.main.async {
        self.currentUser = session.user
        self.isAuthenticated = session.user != nil
      }
    } catch {
      DispatchQueue.main.async {
        self.isAuthenticated = false
      }
    }
  }
}
