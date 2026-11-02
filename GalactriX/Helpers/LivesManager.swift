import Foundation

enum ProductID: String, CaseIterable {
    case tenLifes = "tenLives"
    case twentyFiveLifes = "25Lifes"
    case hundredLifes = "100Lifes"

    var livesToAdd: Int {
        switch self {
        case .tenLifes:
            return 10
        case .twentyFiveLifes:
            return 25
        case .hundredLifes:
            return 100
        }
    }
}

final class LivesManager {
    
    // MARK: - Properties
    let initialLives = 10
    private let lastUpdateKey = "lastLivesUpdateDate"
    private let livesKey = "currentLives"
    
    // MARK: - Init
    init() {
        checkForDailyReset()
    }
    
    // MARK: - Daily Reset Logic
    private func checkForDailyReset() {
        let now = Date()
        let lastUpdate = UserDefaults.standard.object(forKey: lastUpdateKey) as? Date ?? .distantPast
        if !Calendar.current.isDate(now, inSameDayAs: lastUpdate) {
            UserDefaults.standard.set(initialLives, forKey: livesKey)
            UserDefaults.standard.set(now, forKey: lastUpdateKey)
        }
    }
    
    // MARK: - Lives Management
    var currentLives: Int {
        get {
            return UserDefaults.standard.integer(forKey: livesKey)
        }
        set {
            guard newValue >= 0 else { return }
            UserDefaults.standard.set(newValue, forKey: livesKey)
        }
    }
    
    func decrementLife() {
        if currentLives > 0 {
            currentLives -= 1
        }
    }
    
    func isOutOfLives() -> Bool {
        return currentLives <= 0
    }
}
