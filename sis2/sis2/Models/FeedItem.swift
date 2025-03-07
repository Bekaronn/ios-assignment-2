import UIKit

struct FeedItem {
    let post: Post
    let author: UserProfile
    let time: String
    var isLiked: Bool = false

    var formattedLikes: String {
        if post.likes >= 1000 {
            let formatted = Double(post.likes) / 1000.0
            return String(format: "%.1fK", formatted).replacingOccurrences(of: ".0", with: "")
        }
        return "\(post.likes)"
    }
}
