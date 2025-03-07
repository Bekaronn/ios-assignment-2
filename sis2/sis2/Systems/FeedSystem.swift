import UIKit

class FeedSystem {
    // Кэш пользователей для быстрого доступа (O(1)).
    private var userCache: [UUID: UserProfile] = [:]
    
    // Лента постов. Используем массив для сохранения порядка и частых вставок в начало.
    private var feedPosts: [Post] = []
    
    // Уникальный набор хэштегов, используется для быстрого поиска.
    private var hashtags: Set<String> = []
    
    // Добавляет новый пост в ленту.
    func addPost(_ post: Post) {
        // Вставляем пост в начало списка.
        feedPosts.insert(post, at: 0)
        
        // Извлекаем хэштеги из контента и добавляем в общий список.
        hashtags.formUnion(extractHashtags(from: post.content))
    }
    
    /// Удаляет пост из ленты.
    func removePost(_ post: Post) {
        // Проверяем, есть ли пост в списке, и удаляем его.
        feedPosts.removeAll { $0.id == post.id }
    }
    
    /// Извлекает хэштеги из текста.
    private func extractHashtags(from content: String) -> Set<String> {
        return Set(content
            .split { $0.isWhitespace } // Разбиваем текст по пробелам и новым строкам.
            .filter { $0.hasPrefix("#") } // Оставляем только слова с #
            .map { String($0) } // Преобразуем Substring в String.
        )
    }
}
