import UIKit

// MARK: - CLASS:

final class VibrationManager {
    // MARK: - STATIC:

    static let instance = VibrationManager()

    // MARK: - PRIVATE INIT:

    private init() {}

    // MARK: - PROPERTIES:

    private let vibrationNotification = UINotificationFeedbackGenerator()
    private let vibrationMedium = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - PUBLIC METHODS:

    func vibrationSucces() {
        self.vibrationNotification.notificationOccurred(.success)
    }

    func vibrationError() {
        self.vibrationNotification.notificationOccurred(.error)
    }

    func vibrationStandart() {
        self.vibrationMedium.prepare()
        self.vibrationMedium.impactOccurred()
    }
}
