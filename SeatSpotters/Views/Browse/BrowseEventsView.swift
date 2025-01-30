import SwiftUI

struct BrowseEventsView: View {
  @State private var searchText = ""
  @Namespace private var namespace
  
  var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        SearchBar(text: $searchText)
          .padding(.horizontal)
          .padding(.bottom)
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 16)], spacing: 16) {
          ForEach(filteredEvents) { event in
            EventCard(event: event)
              .matchedGeometryEffect(id: event.id, in: namespace)
              .transition(.asymmetric(
                insertion: .opacity.combined(with: .scale(0.9)),
                removal: .opacity
              ))
          }
        }
        .padding(.horizontal)
      }
      .background(NeonTheme.mainGradient)
    }
    .background(NeonTheme.background)
    .navigationTitle("Discover")
    .navigationBarTitleDisplayMode(.large)
  }
  
  private var filteredEvents: [Event] {
    guard !searchText.isEmpty else { return mockEvents }
    return mockEvents.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
  }
}

struct SearchBar: View {
  @Binding var text: String
  @FocusState private var isFocused: Bool
  
  var body: some View {
    HStack {
      TextField("Search events...", text: $text)
        .focused($isFocused)
        .textFieldStyle(.plain)
        .padding(12)
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(NeonTheme.surface)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(NeonTheme.neonBlue.opacity(0.3), lineWidth: 1)
            )
        )
        .overlay(alignment: .trailing) {
          if !text.isEmpty {
            Button {
              text = ""
            } label: {
              Image(systemName: "xmark.circle.fill")
                .foregroundColor(NeonTheme.textSecondary)
            }
            .padding(.trailing, 8)
          }
        }
      
      if isFocused {
        Button("Cancel") {
          isFocused = false
          text = ""
        }
        .transition(.move(edge: .trailing))
      }
    }
    .animation(NeonTheme.smoothEase, value: isFocused)
    .foregroundColor(NeonTheme.textPrimary)
  }
}
