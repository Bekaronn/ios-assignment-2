import UIKit

struct Post: Hashable, Equatable {
    let id: UUID
    let authorId: UUID
    var content: String
    var likes: Int
    
    // Используем только неизменяемые свойства для хеширования
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Посты равны, если у них одинаковые id
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
} 
