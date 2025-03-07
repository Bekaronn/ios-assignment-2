import UIKit

class UserProfileViewController: UIViewController, ProfileUpdateDelegate, ImageLoaderDelegate {
    // UI элементы
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Добавляем иконку плейсхолдера
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray3
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let followersIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.2.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let followersCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "Followers"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Используем сильные ссылки, т.к. ViewController владеет этими объектами
    var profileManager: ProfileManager?
    var imageLoader: ImageLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupProfileManager()
        updateProfile() // Добавлено для загрузки профиля
    }
    
    private func setupUI() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        // Добавляем элементы в иерархию view
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(bioLabel)
        view.addSubview(statsView)
        statsView.addSubview(followersIconImageView)
        statsView.addSubview(followersCountLabel)
        statsView.addSubview(followersLabel)
        
        // Устанавливаем констрейнты
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            bioLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // Stats view с информацией о подписчиках
            statsView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 30),
            statsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statsView.widthAnchor.constraint(equalToConstant: 150),
            statsView.heightAnchor.constraint(equalToConstant: 100),
            
            followersIconImageView.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 15),
            followersIconImageView.centerXAnchor.constraint(equalTo: statsView.centerXAnchor),
            followersIconImageView.widthAnchor.constraint(equalToConstant: 24),
            followersIconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            followersCountLabel.topAnchor.constraint(equalTo: followersIconImageView.bottomAnchor, constant: 8),
            followersCountLabel.centerXAnchor.constraint(equalTo: statsView.centerXAnchor),
            
            followersLabel.topAnchor.constraint(equalTo: followersCountLabel.bottomAnchor, constant: 4),
            followersLabel.centerXAnchor.constraint(equalTo: statsView.centerXAnchor),
        ])
    }
    
    func setupProfileManager() {
        profileManager = ProfileManager(delegate: self)
        imageLoader = ImageLoader()
        imageLoader?.delegate = self
    }
    
    func updateProfile() {
        usernameLabel.text = "Loading..."
        bioLabel.text = "Please wait..."
        
        // Используем [weak self] чтобы избежать retain cycle
        profileManager?.loadProfile(id: "1") { [weak self] result in
            switch result {
            case .success(let profile):
                self?.updateUI(with: profile)
            case .failure(let error):
                print("Error loading profile: \(error)")
                self?.showError(message: "Failed to load profile")
            }
        }
    }
    
    private func updateUI(with profile: UserProfile) {
        usernameLabel.text = profile.username
        bioLabel.text = profile.bio
        followersCountLabel.text = "\(profile.followers)"
        
        
        // Вместо реальной загрузки, установим случайный цвет фона для демонстрации
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let colors: [UIColor] = [.systemBlue, .systemGreen, .systemIndigo, .systemOrange, .systemPurple]
            let randomColor = colors.randomElement() ?? .systemBlue
            self?.profileImageView.backgroundColor = randomColor
            self?.profileImageView.image = nil // Убираем плейсхолдер
        }
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
        print("Profile loading error: \(error)")
        showError(message: "Failed to update profile")
    }
    
    // MARK: - ImageLoaderDelegate
    
    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage) {
        profileImageView.image = image
    }
    
    func imageLoader(_ loader: ImageLoader, didFailWith error: Error) {
        print("Image loading error: \(error)")
    }
}
