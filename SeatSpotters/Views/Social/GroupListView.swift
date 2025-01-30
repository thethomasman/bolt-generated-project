import SwiftUI

struct GroupListView: View {
  @State private var groups: [Group] = []
  @State private var showingCreateGroup = false
  
  var body: some View {
    List {
      ForEach(groups) { group in
        NavigationLink {
          GroupDetailView(group: group)
        } label: {
          GroupRow(group: group)
        }
      }
    }
    .toolbar {
      Button {
        showingCreateGroup = true
      } label: {
        Image(systemName: "plus.circle.fill")
          .foregroundColor(NeonTheme.neonBlue)
      }
    }
    .sheet(isPresented: $showingCreateGroup) {
      CreateGroupView()
    }
  }
}

struct GroupDetailView: View {
  let group: Group
  
  var body: some View {
    VStack {
      // Group chat implementation
      ScrollView {
        ForEach(group.chatMessages) { message in
          ChatBubble(message: message)
        }
      }
      
      // Message input
      HStack {
        TextField("Message...", text: $newMessage)
          .textFieldStyle(.roundedBorder)
        
        Button("Send") {
          // Send message
        }
        .buttonStyle(.borderedProminent)
        .tint(NeonTheme.neonBlue)
      }
      .padding()
    }
    .navigationTitle(group.name)
  }
}
