import UIKit

final class OnboardingCell: UICollectionViewCell {
    // MARK: - PROPERTIES:

    private let backgroundImageView = UIImageView()
    private let promtView = UIView()
    private let promtTitleLabel = UILabel()
    private let promtDescriptionLabel = UILabel()

    private let configurationImage = UIImage.SymbolConfiguration(pointSize: 21)
    
    // MARK: - LIFECYCLE:
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        addSubviews()
        configureConstraints()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ADD SUBVIEWS:
    
    private func addSubviews() {
        contentView.addSubviews(backgroundImageView, promtView, promtTitleLabel, promtDescriptionLabel)
    }
    
    // MARK: - CONFIGURE CONSTRAINTS:
    
    private func configureConstraints() {
        
        // BACKGROUND IMAGE VIEW:
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -50).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        // PROMT VIEW:
        promtView.translatesAutoresizingMaskIntoConstraints = false
        promtView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        promtView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        promtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85).isActive = true
        promtView.bottomAnchor.constraint(equalTo: promtDescriptionLabel.bottomAnchor, constant: 25).isActive = true
        
        // PROMT TITLE LABEL:
        promtTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        promtTitleLabel.topAnchor.constraint(equalTo: promtView.topAnchor, constant: 20).isActive = true
        promtTitleLabel.centerXAnchor.constraint(equalTo: promtView.centerXAnchor).isActive = true
        
        // PROMT DESCRIPTION LABEL:
        promtDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        promtDescriptionLabel.topAnchor.constraint(equalTo: promtTitleLabel.bottomAnchor, constant: 15).isActive = true
        promtDescriptionLabel.leadingAnchor.constraint(equalTo: promtView.leadingAnchor, constant: 25).isActive = true
        promtDescriptionLabel.widthAnchor.constraint(equalTo: promtView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    // MARK: CONFIGURE UI:
    
    private func configureUI() {
        
        // BACKGROUND IMAGE VIEW:
        backgroundImageView.contentMode = .scaleAspectFill
        
        // PROMT VIEW:
        promtView.layer.masksToBounds = true
        promtView.layer.cornerRadius = 22
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        promtView.addSubview(blurEffectView)

        blurEffectView.topAnchor.constraint(equalTo: promtView.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: promtView.bottomAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: promtView.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: promtView.trailingAnchor).isActive = true

        blurEffectView.layer.opacity = 0.6
        promtView.addSubview(blurEffectView)
        promtView.addSubviews(promtTitleLabel, promtDescriptionLabel)
        
        // PROMT TITLE LABEL:
        promtTitleLabel.textColor = .white
        promtTitleLabel.textAlignment = .center
        promtTitleLabel.font = FontManager.bold(size: 32).uiFont

        // PROMT DESCRIPTION LABEL:
        promtDescriptionLabel.textColor = .white
        promtDescriptionLabel.numberOfLines = 0
        promtDescriptionLabel.textAlignment = .center
        promtDescriptionLabel.font = FontManager.regular(size: 14).uiFont
        promtDescriptionLabel.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - CONFIGURE CONTENT:
    
    func configure(title: String, description: String, image: UIImage) {
        promtTitleLabel.text = title
        promtDescriptionLabel.text = description
        backgroundImageView.image = image
    }
}
