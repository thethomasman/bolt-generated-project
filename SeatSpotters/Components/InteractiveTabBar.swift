import SwiftUI

struct InteractiveTabBar: View {
  @Binding var selection: Int
  @Namespace private var namespace
  
  var body: some View {
    HStack {
      ForEach(0..<4) { index in
        Button {
          withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selection = index
          }
        } label: {
          VStack(spacing: 4) {
            Image(systemName: iconName(for: index))
              .font(.system(size: 20, weight: .bold))
              .foregroundColor(selection == index ? NeonTheme.neonBlue : NeonTheme.textSecondary)
            
            if selection == index {
              Capsule()
                .fill(NeonTheme.neonBlue)
                .frame(width: 24, height: 3)
                .matchedGeometryEffect(id: "tabIndicator", in: namespace)
            } else {
              Capsule()
                .fill(Color.clear)
                .frame(width: 24, height: 3)
            }
          }
          .frame(maxWidth: .infinity)
        }
      }
    }
    .padding(.vertical, 12)
    .background(
      Rectangle()
        .fill(NeonTheme.surface)
        .overlay(
          Rectangle()
            .stroke(LinearGradient(
              colors: [NeonTheme.neonBlue.opacity(0.2), NeonTheme.neonPurple.opacity(0.1)],
              startPoint: .top,
              endPoint: .bottom
            ), lineWidth: 1)
        )
        .edgesIgnoringSafeArea(.bottom)
    )
  }
  
  private func iconName(for index: Int) -> String {
    switch index {
    case 0: return "magnifyingglass"
    case 1: return "person.2.fill"
    case 2: return "chart.line.uptrend.xyaxis"
    case 3: return "gear"
    default: return "circle"
    }
  }
}
