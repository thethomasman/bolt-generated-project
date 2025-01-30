import SwiftUI
import AuthenticationServices

struct AuthView: View {
  @EnvironmentObject var authManager: AuthManager
  
  var body: some View {
    ZStack {
      NeonTheme.background.ignoresSafeArea()
      
      VStack(spacing: 30) {
        Spacer()
        
        VStack(spacing: 20) {
          Text("Seat Spotters")
            .font(.largeTitle.bold())
            .foregroundColor(NeonTheme.neonBlue)
          
          Text("AI-Powered Ticket Marketplace")
            .font(.title3)
            .foregroundColor(.white.opacity(0.8))
        }
        
        VStack(spacing: 20) {
          SignInButton(
            icon: "applelogo",
            label: "Continue with Apple",
            action: { Task { await authManager.signInWithApple() } }
          )
          
          SignInButton(
            icon: "g.circle.fill",
            label: "Continue with Google",
            action: { Task { await authManager.signInWithGoogle() } }
          )
        }
        
        Spacer()
        
        if authManager.isLoading {
          ProgressView()
            .tint(NeonTheme.neonBlue)
            .scaleEffect(1.5)
        }
      }
      .padding()
    }
    .alert("Authentication Error", 
           isPresented: .constant(authManager.errorMessage != nil),
           presenting: authManager.errorMessage) { _ in
      Button("OK", role: .cancel) {
        authManager.errorMessage = nil
      }
    } message: { message in
      Text(message)
    }
  }
}

struct SignInButton: View {
  let icon: String
  let label: String
  let action: () -> Void
  
  var body: some View {
    Button(action: {
      UIImpactFeedbackGenerator(style: .medium).impactOccurred()
      action()
    }) {
      HStack {
        Image(systemName: icon)
          .font(.title2)
        Text(label)
          .font(.headline)
      }
      .foregroundColor(.white)
      .frame(maxWidth: .infinity)
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(NeonTheme.cardBackground)
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(NeonTheme.neonBlue, lineWidth: 1)
          )
      )
    }
  }
}
