import UIKit

class ProfileManager {
    private var activeProfiles: [String: UserProfile] = [:]

    // Используем weak для делегата, чтобы избежать retain cycle
    weak var delegate: ProfileUpdateDelegate?

    // Замыкание хранится как weak, чтобы избежать retain cycle
    var onProfileUpdate: ((UserProfile) -> Void)?

    init(delegate: ProfileUpdateDelegate? = nil) {
        self.delegate = delegate
    }

    func loadProfile(id: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            // Имитация загрузки профиля (можно заменить на реальный сетевой запрос)
            let profile = UserProfile(
                id: UUID(),
                username: "user_\(id)",
                bio: "Bio for user \(id)",
                followers: Int.random(in: 0...1000)
            )

            DispatchQueue.main.async {
                self.activeProfiles[id] = profile
                self.delegate?.profileDidUpdate(profile)
                self.onProfileUpdate?(profile)
                completion(.success(profile))
            }
        }
    }
}
