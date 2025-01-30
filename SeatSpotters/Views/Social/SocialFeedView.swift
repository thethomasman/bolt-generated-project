import SwiftUI

struct SocialFeedView: View {
  @StateObject private var socialService = SocialService()
  @State private var selectedTab = 0
  
  var body: some View {
    VStack {
      Picker("", selection: $selectedTab) {
        Text("Friends").tag(0)
        Text("Discover").tag(1)
        Text("Groups").tag(2)
      }
      .pickerStyle(.segmented)
      .padding()
      
      TabView(selection: $selectedTab) {
        FriendActivityView()
          .tag(0)
        
        DiscoverView()
          .tag(1)
        
        GroupListView()
          .tag(2)
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
    }
    .background(NeonTheme.background)
    .navigationTitle("Social Hub")
    .task {
      await socialService.fetchFriends()
      await socialService.fetchSocialFeed()
      socialService.setupRealtimeListeners()
    }
  }
}

struct FriendActivityView: View {
  @ObservedObject var socialService: SocialService
  
  var body: some View {
    List {
      Section("Friend Requests") {
        ForEach(socialService.pendingRequests) { request in
          FriendRequestRow(request: request)
        }
      }
      
      Section("Recent Activity") {
        ForEach(socialService.socialPosts) { post in
          SocialPostCard(post: post)
        }
      }
    }
    .listStyle(.insetGrouped)
  }
}

struct SocialPostCard: View {
  let post: SocialPost
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        AsyncImage(url: URL(string: post.user?.avatarUrl ?? "")) { image in
          image.resizable()
        } placeholder: {
          Image(systemName: "person.circle.fill")
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
        
        VStack(alignment: .leading) {
          Text(post.user?.username ?? "Unknown")
            .font(.subheadline.bold())
          Text(post.createdAt.formatted())
            .font(.caption)
            .foregroundColor(.gray)
        }
      }
      
      Text(post.content)
        .font(.body)
      
      HStack {
        Button {
          // Like action
        } label: {
          Label("\(post.likes)", systemImage: "heart")
        }
        
        Button {
          // Comment action
        } label: {
          Label("Comment", systemImage: "bubble.right")
        }
        
        Spacer()
        
        if let event = post.event {
          NavigationLink {
            EventDetailView(event: event)
          } label: {
            Text(event.title)
              .font(.caption)
          }
        }
      }
      .buttonStyle(.borderless)
      .foregroundColor(NeonTheme.neonBlue)
    }
    .padding()
    .background(NeonTheme.cardBackground)
    .cornerRadius(12)
  }
}
