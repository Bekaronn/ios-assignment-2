import UIKit

struct UserProfile: Hashable, Equatable {
    let id: UUID
    let username: String
    var bio: String
    var followers: Int
    
    // Используем только неизменяемые свойства для хеширования
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(username)
    }
    
    // Сравниваем профили только по id и username
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.id == rhs.id && lhs.username == rhs.username
    }
} 
