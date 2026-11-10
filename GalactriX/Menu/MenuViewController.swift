import AVFoundation
import UIKit

final class MenuViewController: UIViewController {
    private let livesManager = LivesManager()
    private let livesLabel = UILabel()
    private let soundButton = UIButton(type: .system)
    private var player: AVAudioPlayer?
    private var soundEnabled = true
    private var selectedTheme = FlightTheme.selected
    private var themeButtons: [ThemeButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = PinPalette.background
        buildMenu()
        configureMusic()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLivesDisplay),
                                               name: Notification.Name("livesUpdated"), object: nil)
        UserDefaults.standard.set(true, forKey: "onboardingViewed")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        updateLivesDisplay()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private func buildMenu() {
        let scroll = UIScrollView()
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        let content = UIStackView()
        content.axis = .vertical
        content.spacing = 10
        view.addSubview(scroll)
        scroll.addSubview(content)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        content.translatesAutoresizingMaskIntoConstraints = false

        let contentWidth = content.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -40)
        contentWidth.priority = .defaultHigh
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.contentLayoutGuide.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor),
            content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 3),
            content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -44),
            content.centerXAnchor.constraint(equalTo: scroll.contentLayoutGuide.centerXAnchor),
            content.widthAnchor.constraint(lessThanOrEqualTo: scroll.frameLayoutGuide.widthAnchor, constant: -40),
            content.widthAnchor.constraint(lessThanOrEqualToConstant: 500),
            contentWidth
        ])

        let play = makeButton("Play", icon: "play.fill", fill: PinPalette.arcadeRed, tint: .white, arcade: true)
        let results = makeButton("Results", icon: "trophy.fill", fill: PinPalette.mint, tint: PinPalette.background, arcade: true)
        play.accessibilityIdentifier = "play"
        results.accessibilityIdentifier = "results"
        play.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        results.addTarget(self, action: #selector(resultsTapped), for: .touchUpInside)

        let actions = UIStackView(arrangedSubviews: [play, results])
        actions.axis = .vertical
        actions.spacing = 8

        let controls = makeControls()
        [controls, makeNeonTitle(), makeGuide(), makeRocket(), actions, makeThemeSection(), makeFooter()]
            .forEach(content.addArrangedSubview)
        content.setCustomSpacing(3, after: controls)
        content.setCustomSpacing(16, after: actions)
    }

    private func makeNeonTitle() -> UIView {
        let title = makeLabel("PIN GAME", size: 36, weight: .black, color: PinPalette.neonPink, style: .largeTitle)
        let italic = title.font.fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) ?? title.font.fontDescriptor
        title.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont(descriptor: italic, size: 36))
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.45
        title.accessibilityTraits.insert(.header)

        let underline = UIView()
        underline.backgroundColor = PinPalette.mint
        underline.layer.cornerRadius = 1.5
        underline.layer.shadowColor = PinPalette.mint.cgColor
        underline.layer.shadowRadius = 5
        underline.layer.shadowOpacity = 0.8
        underline.layer.shadowOffset = .zero
        underline.heightAnchor.constraint(equalToConstant: 3).isActive = true

        let sign = UIStackView(arrangedSubviews: [title, underline])
        sign.axis = .vertical
        sign.spacing = 2
        sign.isLayoutMarginsRelativeArrangement = true
        sign.directionalLayoutMargins = .init(top: 8, leading: 20, bottom: 10, trailing: 20)
        sign.backgroundColor = PinPalette.surface
        sign.layer.cornerRadius = 10
        sign.layer.borderWidth = 2.5
        sign.layer.borderColor = PinPalette.neonPink.cgColor
        sign.layer.shadowColor = PinPalette.neonPink.cgColor
        sign.layer.shadowRadius = 9
        sign.layer.shadowOpacity = 0.75
        sign.layer.shadowOffset = .zero

        let wrapper = UIView()
        wrapper.addSubview(sign)
        sign.translatesAutoresizingMaskIntoConstraints = false
        let preferredWidth = sign.widthAnchor.constraint(equalTo: wrapper.widthAnchor, multiplier: 0.84)
        preferredWidth.priority = .defaultHigh
        NSLayoutConstraint.activate([
            sign.topAnchor.constraint(equalTo: wrapper.topAnchor),
            sign.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
            sign.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
            sign.widthAnchor.constraint(lessThanOrEqualToConstant: 290),
            preferredWidth
        ])
        return wrapper
    }

    private func makeControls() -> UIStackView {
        livesLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .bold)
        livesLabel.textColor = PinPalette.cream
        livesLabel.setContentHuggingPriority(.required, for: .horizontal)
        livesLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        let heart = UIImageView(image: UIImage(systemName: "heart.fill"))
        heart.tintColor = PinPalette.red
        heart.preferredSymbolConfiguration = .init(pointSize: 12, weight: .bold)
        heart.isAccessibilityElement = false
        heart.contentMode = .scaleAspectFit
        heart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heart.widthAnchor.constraint(equalToConstant: 14),
            heart.heightAnchor.constraint(equalTo: heart.widthAnchor)
        ])
        let lifeChip = row([heart, livesLabel], spacing: 6)
        lifeChip.alignment = .center
        lifeChip.backgroundColor = PinPalette.surface
        lifeChip.layer.cornerRadius = 15
        lifeChip.layer.borderWidth = 1
        lifeChip.layer.borderColor = PinPalette.stroke.cgColor
        lifeChip.isLayoutMarginsRelativeArrangement = true
        lifeChip.directionalLayoutMargins = .init(top: 8, leading: 10, bottom: 8, trailing: 10)
        lifeChip.setContentHuggingPriority(.required, for: .horizontal)

        var soundConfig = UIButton.Configuration.plain()
        soundConfig.baseForegroundColor = PinPalette.cream
        soundConfig.contentInsets = .zero
        soundConfig.preferredSymbolConfigurationForImage = .init(pointSize: 15, weight: .semibold)
        soundButton.configuration = soundConfig
        soundButton.addTarget(self, action: #selector(soundTapped), for: .touchUpInside)
        soundButton.accessibilityIdentifier = "music"
        NSLayoutConstraint.activate([
            soundButton.widthAnchor.constraint(equalToConstant: 44),
            soundButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        let controls = row([lifeChip, soundButton], spacing: 3)
        controls.alignment = .center
        controls.setContentHuggingPriority(.required, for: .horizontal)
        let header = row([UIView(), controls], spacing: 0)
        header.alignment = .center
        return header
    }

    private func makeGuide() -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = "How to play"
        config.subtitle = "Tap to steer. Dodge asteroids."
        config.image = UIImage(systemName: "info.circle.fill")
        config.imagePadding = 10
        config.preferredSymbolConfigurationForImage = .init(pointSize: 21, weight: .semibold)
        config.baseForegroundColor = PinPalette.mint
        config.contentInsets = .init(top: 7, leading: 11, bottom: 7, trailing: 11)
        config.background.backgroundColor = PinPalette.surface
        config.background.cornerRadius = 6
        config.titleTextAttributesTransformer = .init { attributes in
            var result = attributes
            result.font = .preferredFont(forTextStyle: .subheadline)
            return result
        }
        config.subtitleTextAttributesTransformer = .init { attributes in
            var result = attributes
            result.font = .preferredFont(forTextStyle: .footnote)
            result.foregroundColor = PinPalette.muted
            return result
        }
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = PinPalette.stroke.cgColor
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        button.accessibilityLabel = "How to play"
        button.accessibilityHint = "Opens flight controls and the winning score"
        button.accessibilityIdentifier = "how-to-play"
        button.addTarget(self, action: #selector(guideTapped), for: .touchUpInside)
        return button
    }

    private func makeRocket() -> UIImageView {
        let rocket = UIImageView(image: UIImage(named: "PinGameRocket"))
        rocket.contentMode = .scaleAspectFit
        rocket.isAccessibilityElement = false
        rocket.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        rocket.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        rocket.heightAnchor.constraint(equalTo: rocket.widthAnchor, multiplier: 0.61).isActive = true
        return rocket
    }

    private func makeThemeSection() -> UIStackView {
        let title = makeLabel("Flight themes", size: 24, weight: .heavy, color: PinPalette.cream, style: .title2)
        title.accessibilityTraits.insert(.header)
        let subtitle = makeLabel("Choose your in-game background", size: 13, weight: .medium, color: PinPalette.muted, style: .footnote)
        subtitle.numberOfLines = 0
        let heading = UIStackView(arrangedSubviews: [title, subtitle])
        heading.axis = .vertical
        heading.spacing = 3

        themeButtons = FlightTheme.allCases.map { theme in
            let button = ThemeButton(theme: theme)
            button.addAction(UIAction { [weak self] _ in self?.select(theme) }, for: .touchUpInside)
            return button
        }
        let groups = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
            ? [Array(themeButtons.prefix(2)), Array(themeButtons.suffix(2))]
            : [themeButtons]
        let tiles = groups.map { buttons in
            let strip = row(buttons, spacing: 8)
            strip.distribution = .fillEqually
            return strip
        }
        let section = UIStackView(arrangedSubviews: [heading] + tiles)
        section.axis = .vertical
        section.spacing = 10
        updateThemeButtons()
        return section
    }

    private func makeFooter() -> UIStackView {
        let policy = makeButton("Privacy Policy", icon: "arrow.up.right", fill: .clear, tint: PinPalette.muted)
        var config = policy.configuration
        config?.imagePlacement = .trailing
        config?.titleTextAttributesTransformer = .init { attributes in
            var result = attributes
            result.font = UIFont.preferredFont(forTextStyle: .footnote)
            return result
        }
        policy.configuration = config
        policy.accessibilityIdentifier = "privacy-policy"
        policy.addTarget(self, action: #selector(policyTapped), for: .touchUpInside)

        let credit = makeLabel("GALACTRIX  /  ANDREW MALYSHEW", size: 9, weight: .semibold, color: PinPalette.muted, style: .caption2)
        credit.textAlignment = .center
        credit.numberOfLines = 0
        let footer = UIStackView(arrangedSubviews: [policy, credit])
        footer.axis = .vertical
        footer.alignment = .center
        return footer
    }

    private func row(_ views: [UIView], spacing: CGFloat) -> UIStackView {
        let row = UIStackView(arrangedSubviews: views)
        row.spacing = spacing
        return row
    }

    private func makeButton(_ title: String, icon: String, fill: UIColor, tint: UIColor, arcade: Bool = false) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = arcade ? title.uppercased() : title
        config.image = UIImage(systemName: icon)
        config.imagePadding = 8
        config.preferredSymbolConfigurationForImage = .init(pointSize: 13, weight: .bold)
        config.baseBackgroundColor = fill
        config.baseForegroundColor = tint
        config.cornerStyle = .fixed
        config.background.cornerRadius = arcade ? 7 : 12
        config.contentInsets = .init(top: 14, leading: 10, bottom: 14, trailing: 10)
        config.titleTextAttributesTransformer = .init { attributes in
            var result = attributes
            result.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: .systemFont(ofSize: 16, weight: .heavy))
            return result
        }
        let button = arcade ? ArcadeActionButton(arcadeConfiguration: config) : UIButton(configuration: config)
        button.accessibilityLabel = title
        button.layer.cornerRadius = arcade ? 7 : 12
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: arcade ? 52 : 48).isActive = true
        return button
    }

    @objc private func playTapped() {
        VibrationManager.instance.vibrationStandart()
        if livesManager.isOutOfLives() {
            present(PaywallViewController(), animated: true)
            return
        }
        let game = GameViewController()
        game.flightTheme = selectedTheme
        game.player = soundEnabled ? player : nil
        game.modalTransitionStyle = .crossDissolve
        game.modalPresentationStyle = .fullScreen
        present(game, animated: true)
    }

    @objc private func resultsTapped() {
        let defaults = UserDefaults.standard
        let best = defaults.integer(forKey: "record")
        let last = defaults.object(forKey: "lastFlightScore") as? Int
        let lastLine = last.map { "Last flight: \($0) points" } ?? "Finish a flight to see your latest score."
        showDetails("Results", message: "Personal best: \(best) points\n\n\(lastLine)")
    }

    @objc private func guideTapped() {
        showDetails("How to play", message: "Tap anywhere in the flight area to move your ship. Avoid the falling asteroids.\n\nEach asteroid that passes scores 1 point. The field gets faster as your score climbs. Reach 300 points to win.")
    }

    private func showDetails(_ title: String, message: String) {
        VibrationManager.instance.vibrationStandart()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func policyTapped() {
        present(UINavigationController(rootViewController: PrivacyWebViewController()), animated: true)
    }

    private func select(_ theme: FlightTheme) {
        selectedTheme = theme
        UserDefaults.standard.set(theme.rawValue, forKey: FlightTheme.preferenceKey)
        VibrationManager.instance.vibrationStandart()
        updateThemeButtons()
    }

    private func updateThemeButtons() {
        themeButtons.forEach { $0.isSelected = $0.theme == selectedTheme }
    }

    private func configureMusic() {
        soundEnabled = UserDefaults.standard.object(forKey: "menuMusicEnabled") as? Bool ?? true
        if let url = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") {
            player = try? AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
        }
        updateMusic()
    }

    @objc private func soundTapped() {
        VibrationManager.instance.vibrationStandart()
        soundEnabled.toggle()
        UserDefaults.standard.set(soundEnabled, forKey: "menuMusicEnabled")
        updateMusic()
    }

    private func updateMusic() {
        if soundEnabled { player?.play() } else { player?.pause() }
        soundButton.configuration?.image = UIImage(systemName: soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
        soundButton.accessibilityLabel = "Music"
        soundButton.accessibilityValue = soundEnabled ? "On" : "Off"
    }

    @objc private func updateLivesDisplay() {
        let lives = livesManager.currentLives
        livesLabel.text = String(lives)
        livesLabel.accessibilityLabel = "\(lives) lives remaining"
    }
}
