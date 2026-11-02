import UIKit

class Vibration {
    let vibrationNotification = UINotificationFeedbackGenerator()
    let vibrationImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    let vibrationImpactFeedbackGeneratorHard = UIImpactFeedbackGenerator(style: .rigid)
    let vibrationImpactFeedbackGeneratorSpeed = UIImpactFeedbackGenerator(style: .rigid)

    func vibrationSucces() {
        self.vibrationNotification.notificationOccurred(.success)
    }

    func vibrationError() {
        self.vibrationNotification.notificationOccurred(.error)
    }
    
    func vibrationStandart() {
        self.vibrationImpactFeedbackGenerator.prepare()
        self.vibrationImpactFeedbackGenerator.impactOccurred()
    }
    
    func vibrationHard() {
        self.vibrationImpactFeedbackGenerator.prepare()
        self.vibrationImpactFeedbackGenerator.impactOccurred()
    }
    
    var timer: Timer?

    func handleVibration() {
        if timer == nil {
            vibrationImpactFeedbackGeneratorSpeed.prepare()
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(vibrationSpeed), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func vibrationSpeed() {
        self.vibrationImpactFeedbackGeneratorSpeed.impactOccurred()
    }
}
