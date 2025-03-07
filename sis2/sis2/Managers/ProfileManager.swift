import UIKit

class ProfileManager {
    private var activeProfiles: [String: UserProfile] = [:]
    
    // Используем weak для делегата чтобы избежать retain cycle
    weak var delegate: ProfileUpdateDelegate?
    
    // Замыкание хранится как weak чтобы избежать retain cycle
    var onProfileUpdate: ((UserProfile) -> Void)?
    
    init(delegate: ProfileUpdateDelegate) {
        self.delegate = delegate
    }
    
    func loadProfile(id: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        // Используем [weak self] чтобы избежать retain cycle
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            // Имитация загрузки профиля
            let profile = UserProfile(id: UUID(), 
                                   username: "user_\(id)", 
                                   bio: "Bio for user \(id)", 
                                   followers: 0)
            
            DispatchQueue.main.async {
                self.activeProfiles[id] = profile
                self.delegate?.profileDidUpdate(profile)
                completion(.success(profile))
            }
        }
    }
} 
