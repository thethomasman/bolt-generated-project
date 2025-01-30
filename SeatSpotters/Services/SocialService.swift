import Foundation
import Supabase

class SocialService: ObservableObject {
  @Published var friends: [UserProfile] = []
  @Published var pendingRequests: [Friendship] = []
  @Published var socialPosts: [SocialPost] = []
  
  private let supabase = SupabaseManager.shared.client
  
  // Friend Management
  func fetchFriends() async {
    guard let userId = AuthManager.shared.currentUser?.id else { return }
    
    do {
      let friends: [Friendship] = try await supabase.database
        .from("friendships")
        .select()
        .or("userId.eq.\(userId),friendId.eq.\(userId)")
        .execute()
        .value
      
      let friendIds = friends.compactMap { $0.userId == userId ? $0.friendId : $0.userId }
      
      let profiles: [UserProfile] = try await supabase.database
        .from("user_profiles")
        .select()
        .in("userId", values: friendIds)
        .execute()
        .value
      
      DispatchQueue.main.async {
        self.friends = profiles
      }
    } catch {
      print("Error fetching friends: \(error)")
    }
  }
  
  func sendFriendRequest(friendId: String) async {
    guard let userId = AuthManager.shared.currentUser?.id else { return }
    
    let newRequest = Friendship(
      id: UUID(),
      userId: userId,
      friendId: friendId,
      status: .pending,
      createdAt: Date()
    )
    
    do {
      try await supabase.database
        .from("friendships")
        .insert(newRequest)
        .execute()
    } catch {
      print("Error sending friend request: \(error)")
    }
  }
  
  // Social Feed
  func fetchSocialFeed() async {
    do {
      let posts: [SocialPost] = try await supabase.database
        .from("social_posts")
        .select("*, comments(*)")
        .order("createdAt", ascending: false)
        .execute()
        .value
      
      DispatchQueue.main.async {
        self.socialPosts = posts
      }
    } catch {
      print("Error fetching social feed: \(error)")
    }
  }
  
  // Real-time Updates
  func setupRealtimeListeners() {
    supabase.realtime.connect()
    
    let channel = supabase.realtime.channel("social_updates")
    
    channel
      .on(.all) { message in
        print("Real-time update:", message)
        Task {
          await self.fetchFriends()
          await self.fetchSocialFeed()
        }
      }
      .subscribe()
  }
}
