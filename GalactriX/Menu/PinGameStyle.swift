import UIKit

enum PinPalette {
    static let background = UIColor(red: 0.045, green: 0.056, blue: 0.073, alpha: 1)
    static let surface = UIColor(red: 0.086, green: 0.102, blue: 0.127, alpha: 1)
    static let stroke = UIColor(white: 1, alpha: 0.13)
    static let cream = UIColor(red: 1, green: 0.965, blue: 0.929, alpha: 1)
    static let muted = UIColor(red: 0.65, green: 0.69, blue: 0.75, alpha: 1)
    static let red = UIColor(red: 0.91, green: 0.25, blue: 0.30, alpha: 1)
    static let neonPink = UIColor(red: 1, green: 0.28, blue: 0.57, alpha: 1)
    static let arcadeRed = UIColor(red: 0.80, green: 0.14, blue: 0.12, alpha: 1)
    static let mint = UIColor(red: 0.36, green: 0.96, blue: 0.77, alpha: 1)
}

enum FlightTheme: String, CaseIterable {
    case neonOrbit = "NeonOrbit"
    case solarFlare = "SolarFlare"
    case deepSpace = "DeepSpace"
    case goldenDawn = "GoldenDawn"

    static let preferenceKey = "flightTheme"

    static var selected: FlightTheme {
        UserDefaults.standard.string(forKey: preferenceKey).flatMap(FlightTheme.init(rawValue:)) ?? .neonOrbit
    }

    var title: String {
        switch self {
        case .neonOrbit: "Neon Orbit"
        case .solarFlare: "Solar Flare"
        case .deepSpace: "Deep Space"
        case .goldenDawn: "Golden Dawn"
        }
    }

    var tint: UIColor {
        switch self {
        case .neonOrbit: PinPalette.mint
        case .solarFlare: UIColor(red: 1, green: 0.42, blue: 0.40, alpha: 1)
        case .deepSpace: UIColor(red: 0.65, green: 0.60, blue: 1, alpha: 1)
        case .goldenDawn: UIColor(red: 1, green: 0.77, blue: 0.36, alpha: 1)
        }
    }

    var backdrop: String { rawValue + "Backdrop" }
    var card: String { rawValue + "Card" }
}

func makeLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor,
               style: UIFont.TextStyle) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: .systemFont(ofSize: size, weight: weight))
    label.adjustsFontForContentSizeCategory = true
    label.textColor = color
    return label
}

final class ThemeButton: UIButton {
    let theme: FlightTheme
    private let selectionMark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    private let shade = CAGradientLayer()

    override var isSelected: Bool {
        didSet {
            selectionMark.isHidden = !isSelected
            layer.borderWidth = isSelected ? 2 : 1
            layer.borderColor = (isSelected ? theme.tint : theme.tint.withAlphaComponent(0.35)).cgColor
            accessibilityTraits = isSelected ? [.button, .selected] : .button
        }
    }

    override var isHighlighted: Bool {
        didSet { alpha = isHighlighted ? 0.75 : 1 }
    }

    init(theme: FlightTheme) {
        self.theme = theme
        super.init(frame: .zero)
        clipsToBounds = true
        layer.cornerRadius = 12
        accessibilityIdentifier = theme.rawValue
        accessibilityLabel = theme.title
        accessibilityHint = "Changes the in-game background"

        let art = UIImageView(image: UIImage(named: theme.card))
        art.contentMode = .scaleAspectFill
        art.clipsToBounds = true
        art.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        art.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        let aspect = self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.55)
        aspect.priority = UILayoutPriority(749)
        aspect.isActive = true
        shade.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.88).cgColor]
        shade.locations = [0.37, 1]
        art.layer.addSublayer(shade)
        let label = makeLabel(theme.title, size: 13, weight: .heavy, color: PinPalette.cream, style: .subheadline)
        label.numberOfLines = 0
        label.textAlignment = .center
        selectionMark.tintColor = theme.tint
        selectionMark.preferredSymbolConfiguration = .init(pointSize: 17, weight: .bold)
        [art, label, selectionMark].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = false
            $0.isAccessibilityElement = false
        }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 70),
            heightAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.55),
            art.leadingAnchor.constraint(equalTo: leadingAnchor),
            art.trailingAnchor.constraint(equalTo: trailingAnchor),
            art.topAnchor.constraint(equalTo: topAnchor),
            art.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            label.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 30),
            selectionMark.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            selectionMark.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shade.frame = bounds
    }

    required init?(coder: NSCoder) { nil }
}


final class ArcadeActionButton: UIButton {
    private let innerBorder = CAShapeLayer()
    private let studs = CAShapeLayer()

    init(arcadeConfiguration: UIButton.Configuration) {
        super.init(frame: .zero)
        configuration = arcadeConfiguration
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
        innerBorder.fillColor = UIColor.clear.cgColor
        innerBorder.strokeColor = UIColor.black.withAlphaComponent(0.55).cgColor
        innerBorder.lineWidth = 1.5
        studs.fillColor = UIColor(red: 1, green: 0.79, blue: 0.31, alpha: 1).cgColor
        studs.strokeColor = UIColor.black.withAlphaComponent(0.65).cgColor
        studs.lineWidth = 1
        layer.addSublayer(innerBorder)
        layer.addSublayer(studs)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        innerBorder.frame = bounds
        innerBorder.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 5, dy: 5), cornerRadius: 4).cgPath
        studs.frame = bounds
        let corners = UIBezierPath(ovalIn: CGRect(x: 5, y: 5, width: 7, height: 7))
        corners.append(UIBezierPath(ovalIn: CGRect(x: bounds.width - 12, y: 5, width: 7, height: 7)))
        studs.path = corners.cgPath
    }

    required init?(coder: NSCoder) { nil }
}
