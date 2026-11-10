import UIKit


final class VibrationManager {

    static let instance = VibrationManager()


    private init() {}


    private let vibrationNotification = UINotificationFeedbackGenerator()
    private let vibrationMedium = UIImpactFeedbackGenerator(style: .medium)


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
