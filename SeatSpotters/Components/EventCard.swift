import SwiftUI

struct EventCard: View {
  let event: Event
  @State private var isHovered = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      AsyncImage(url: URL(string: event.imageUrl)) { phase in
        if let image = phase.image {
          image
            .resizable()
            .aspectRatio(16/9, contentMode: .fill)
            .overlay(gradientOverlay)
        } else if phase.error != nil {
          Color.gray
        } else {
          ProgressView()
        }
      }
      .frame(height: 200)
      .clipped()
      
      VStack(alignment: .leading, spacing: 12) {
        Text(event.title)
          .font(NeonTheme.Typography.title)
          .lineLimit(2)
        
        HStack {
          Label(event.location, systemImage: "mappin.and.ellipse")
            .font(NeonTheme.Typography.caption)
          
          Spacer()
          
          CountdownBadge(date: event.date)
        }
        
        HStack {
          PriceIndicator(price: event.startingPrice)
          
          Spacer()
          
          DemandIndicator(demand: event.demandLevel)
        }
      }
      .padding()
    }
    .background(NeonTheme.surface)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .strokeBorder(NeonTheme.neonBlue.opacity(0.3), lineWidth: 1)
    )
    .scaleEffect(isHovered ? 1.02 : 1)
    .animation(NeonTheme.quickSpring, value: isHovered)
    .onHover { hovering in
      isHovered = hovering
    }
    .onTapGesture {
      // Handle navigation
    }
  }
  
  private var gradientOverlay: some View {
    LinearGradient(
      colors: [.clear, .black.opacity(0.7)],
      startPoint: .top,
      endPoint: .bottom
    )
  }
}

struct CountdownBadge: View {
  let date: Date
  
  var body: some View {
    HStack(spacing: 6) {
      Image(systemName: "clock")
      Text(countdownString)
        .font(NeonTheme.Typography.caption)
    }
    .padding(.vertical, 4)
    .padding(.horizontal, 8)
    .background(
      Capsule()
        .fill(NeonTheme.neonBlue.opacity(0.2))
        .stroke(NeonTheme.neonBlue.opacity(0.4), lineWidth: 1)
    )
  }
  
  private var countdownString: String {
    let components = Calendar.current.dateComponents([.day, .hour], from: Date(), to: date)
    return "\(components.day ?? 0)d \(components.hour ?? 0)h"
  }
}
