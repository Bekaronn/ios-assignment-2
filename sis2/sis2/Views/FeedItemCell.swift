import UIKit

class FeedItemCell: UITableViewCell {
    static let identifier = "FeedItemCell"
    
    private let containerView = UIView()
    private let usernameLabel = UILabel()
    private let contentLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    private let likeCountLabel = UILabel()
    private let commentButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let hashtagsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        contentLabel.text = nil
        likeCountLabel.text = nil
        hashtagsLabel.text = nil
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .systemGray2
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        configureContainerView()
        configureLabels()
        configureButtons()
        setupConstraints()
    }
    
    private func configureContainerView() {
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
    }
    
    private func configureLabels() {
        [usernameLabel, contentLabel, likeCountLabel, hashtagsLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        usernameLabel.font = .boldSystemFont(ofSize: 16)
        contentLabel.font = .systemFont(ofSize: 15)
        contentLabel.numberOfLines = 0
        likeCountLabel.font = .systemFont(ofSize: 14)
        likeCountLabel.textColor = .secondaryLabel
        hashtagsLabel.font = .systemFont(ofSize: 14)
        hashtagsLabel.textColor = .systemBlue
    }
    
    private func configureButtons() {
        [likeButton, commentButton, shareButton].forEach {
            $0.tintColor = .systemGray2
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        commentButton.setImage(UIImage(systemName: "message"), for: .normal)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            usernameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            usernameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            contentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            hashtagsLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            hashtagsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            hashtagsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            likeButton.topAnchor.constraint(equalTo: hashtagsLabel.bottomAnchor, constant: 12),
            likeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            likeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 4),
            
            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor, constant: 16),
            commentButton.widthAnchor.constraint(equalToConstant: 24),
            commentButton.heightAnchor.constraint(equalToConstant: 24),
            
            shareButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            shareButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 16),
            shareButton.widthAnchor.constraint(equalToConstant: 24),
            shareButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupActions() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    @objc private func likeButtonTapped() {
        let wasLiked = likeButton.tintColor == .systemRed
        
        UIView.animate(withDuration: 0.1, animations: {
            self.likeButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.likeButton.transform = .identity
            }
        }
        
        likeButton.setImage(UIImage(systemName: wasLiked ? "heart" : "heart.fill"), for: .normal)
        likeButton.tintColor = wasLiked ? .systemGray2 : .systemRed
    }
    
    @objc private func commentButtonTapped() {}
    
    @objc private func shareButtonTapped() {}
    
    func configure(with feedItem: FeedItem) {
        usernameLabel.text = feedItem.author.username
        contentLabel.text = feedItem.post.content
        likeCountLabel.text = feedItem.formattedLikes
        hashtagsLabel.text = extractHashtags(from: feedItem.post.content).joined(separator: " ")
        
        likeButton.setImage(UIImage(systemName: feedItem.isLiked ? "heart.fill" : "heart"), for: .normal)
        likeButton.tintColor = feedItem.isLiked ? .systemRed : .systemGray2
    }
    
    private func extractHashtags(from text: String) -> [String] {
        text.split(separator: " ").filter { $0.starts(with: "#") }.map { String($0) }
    }
}
