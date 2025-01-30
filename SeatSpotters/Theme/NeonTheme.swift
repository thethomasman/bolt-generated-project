import SwiftUI

struct NeonTheme {
  // Color Palette
  static let background = Color(red: 0.03, green: 0.03, blue: 0.1)
  static let surface = Color(red: 0.08, green: 0.08, blue: 0.18)
  static let neonBlue = Color(red: 0.02, green: 0.64, blue: 1.0)
  static let neonPurple = Color(red: 0.5, green: 0.0, blue: 1.0)
  static let accent = Color(red: 0.0, green: 0.98, blue: 0.6)
  static let textPrimary = Color.white
  static let textSecondary = Color(white: 0.8)
  
  // Gradients
  static let mainGradient = LinearGradient(
    colors: [neonBlue.opacity(0.3), neonPurple.opacity(0.2)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  
  static let buttonGradient = AngularGradient(
    colors: [neonBlue, neonPurple, neonBlue],
    center: .center,
    startAngle: .degrees(0),
    endAngle: .degrees(360)
  )
  
  // Typography
  enum Typography {
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 16, weight: .medium, design: .default)
    static let caption = Font.system(size: 12, weight: .light, design: .monospaced)
  }
  
  // Shadows
  static let glow = Shadow(color: neonBlue.opacity(0.4), radius: 12, x: 0, y: 0)
  static let subtleGlow = Shadow(color: neonBlue.opacity(0.2), radius: 6, x: 0, y: 0)
  
  // Animations
  static let quickSpring = Animation.spring(response: 0.3, dampingFraction: 0.7)
  static let smoothEase = Animation.easeInOut(duration: 0.4)
  
  // Component Styles
  static func cardStyle(cornerRadius: CGFloat = 20) -> some ViewModifier {
    Modifier { content in
      content
        .background(surface)
        .overlay(
          RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(LinearGradient(
              colors: [neonBlue.opacity(0.4), neonPurple.opacity(0.2)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(color: neonBlue.opacity(0.2), radius: 10, x: 0, y: 4)
    }
  }
}

// Custom View Modifier
struct Modifier<T: View>: ViewModifier {
  let closure: (Content) -> T
  func body(content: Content) -> T {
    closure(content)
  }
}
