import SwiftUI

struct NeonButton: View {
  let label: String
  let icon: String
  let action: () -> Void
  @State private var isPressed = false
  
  var body: some View {
    Button(action: {
      UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
      withAnimation(NeonTheme.quickSpring) {
        isPressed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          isPressed = false
        }
      }
      action()
    }) {
      HStack(spacing: 12) {
        Image(systemName: icon)
          .font(.body.weight(.bold))
        Text(label)
          .font(NeonTheme.Typography.body)
      }
      .foregroundColor(NeonTheme.textPrimary)
      .padding(.vertical, 14)
      .padding(.horizontal, 24)
      .background(
        ZStack {
          NeonTheme.surface
          
          RoundedRectangle(cornerRadius: 16)
            .strokeBorder(
              LinearGradient(
                colors: [NeonTheme.neonBlue, NeonTheme.neonPurple],
                startPoint: .leading,
                endPoint: .trailing
              ),
              lineWidth: 2
            )
            .opacity(isPressed ? 0.5 : 1)
        }
      )
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .scaleEffect(isPressed ? 0.95 : 1)
      .contentShape(RoundedRectangle(cornerRadius: 16))
    }
    .buttonStyle(.plain)
  }
}
