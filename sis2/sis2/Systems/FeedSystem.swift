import UIKit

class FeedSystem {
    // Используем Dictionary для кэша пользователей - O(1) доступ
    private var userCache: [UUID: UserProfile] = [:]
    
    // Используем Array для постов - нужен порядок и частые вставки в начало
    private var feedPosts: [Post] = []
    
    // Используем Set для хэштегов - быстрый поиск и уникальность
    private var hashtags: Set<String> = []
    
    func addPost(_ post: Post) {
        // Добавляем пост в начало ленты
        feedPosts.insert(post, at: 0)
        
        // Извлекаем и добавляем хэштеги
        let newHashtags = extractHashtags(from: post.content)
        hashtags.formUnion(newHashtags)
    }
    
    func removePost(_ post: Post) {
        // Удаляем пост из ленты
        if let index = feedPosts.firstIndex(of: post) {
            feedPosts.remove(at: index)
        }
    }
    
    private func extractHashtags(from content: String) -> Set<String> {
        let words = content.components(separatedBy: .whitespacesAndNewlines)
        return Set(words.filter { $0.hasPrefix("#") })
    }
} 
