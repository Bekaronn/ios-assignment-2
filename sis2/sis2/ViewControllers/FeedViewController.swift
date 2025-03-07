import UIKit

class FeedViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeedItemCell.self, forCellReuseIdentifier: FeedItemCell.identifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 750
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var feedItems: [FeedItem] = []
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        loadMockData()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        tableView.refreshControl = refreshControl

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func loadMockData() {
        let mockPosts = [
            Post(id: UUID(), authorId: UUID(), content: "Enjoying a beautiful sunset! 🌅 #nature #peace", likes: 1234),
            Post(id: UUID(), authorId: UUID(), content: "Just finished my morning workout 💪 #fitness #motivation", likes: 856),
            Post(id: UUID(), authorId: UUID(), content: "New recipe I tried today! 🍳 #cooking #foodie", likes: 2431),
            Post(id: UUID(), authorId: UUID(), content: "Weekend vibes with friends 🎉 #weekend #friends", likes: 1678)
        ]
        
        let placeholderUser = UserProfile(id: UUID(), username: "Anonymous", bio: "", followers: 0)
        
        feedItems = mockPosts.map { post in
            FeedItem(post: post, author: placeholderUser, time: "Just now") // Теперь time поддерживается
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func refreshFeed() {
        loadMockData()
        refreshControl.endRefreshing()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedItemCell.identifier, for: indexPath) as? FeedItemCell else {
            return UITableViewCell()
        }
        
        let feedItem = feedItems[indexPath.row]
        cell.configure(with: feedItem)
        return cell
    }
}
