import UIKit

class UserProfileViewController: UIViewController, ProfileUpdateDelegate {
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var profileManager: ProfileManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupProfileManager()
        updateProfile()
    }
    
    private func setupUI() {
        title = "User Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        view.addSubview(usernameLabel)
        view.addSubview(bioLabel)
        view.addSubview(followersLabel)
        
        NSLayoutConstraint.activate([
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 15),
            bioLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            followersLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 15),
            followersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupProfileManager() {
        profileManager = ProfileManager(delegate: self)
    }
    
    private func updateProfile() {
        usernameLabel.text = "Fetching..."
        bioLabel.text = "Loading profile details..."
        followersLabel.text = "Followers: --"
        
        profileManager?.loadProfile(id: "1234") { [weak self] result in
            switch result {
            case .success(let profile):
                self?.updateUI(with: profile)
            case .failure:
                self?.showError(message: "Unable to load profile data")
            }
        }
    }
    
    private func updateUI(with profile: UserProfile) {
        usernameLabel.text = profile.username
        bioLabel.text = profile.bio
        followersLabel.text = "Followers: \(profile.followers)"
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - ProfileUpdateDelegate
    
    func profileDidUpdate(_ profile: UserProfile) {
        updateUI(with: profile)
    }
    
    func profileLoadingError(_ error: Error) {
        showError(message: "Profile update failed")
    }
}
