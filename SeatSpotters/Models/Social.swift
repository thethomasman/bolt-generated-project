import Foundation

struct UserProfile: Identifiable, Codable {
  let id: UUID
  let userId: String
  let username: String
  let avatarUrl: String?
  let bio: String?
  let favoriteTeams: [String]
}

struct Friendship: Identifiable, Codable {
  let id: UUID
  let userId: String
  let friendId: String
  let status: FriendshipStatus
  let createdAt: Date
}

enum FriendshipStatus: String, Codable {
  case pending, accepted, blocked
}

struct SocialPost: Identifiable, Codable {
  let id: UUID
  let userId: String
  let content: String
  let eventId: UUID?
  let likes: Int
  let comments: [Comment]
  let createdAt: Date
}

struct Comment: Identifiable, Codable {
  let id: UUID
  let userId: String
  let content: String
  let createdAt: Date
}

struct Group: Identifiable, Codable {
  let id: UUID
  let name: String
  let eventId: UUID?
  let members: [GroupMember]
  let chatMessages: [ChatMessage]
}

struct GroupMember: Identifiable, Codable {
  let id: UUID
  let userId: String
  let status: GroupMemberStatus
}

enum GroupMemberStatus: String, Codable {
  case invited, joined, declined
}

struct ChatMessage: Identifiable, Codable {
  let id: UUID
  let userId: String
  let content: String
  let timestamp: Date
}
