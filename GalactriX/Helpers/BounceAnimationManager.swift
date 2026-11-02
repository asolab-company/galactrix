import UIKit

final class BounceAnimationManager {
    // MARK: - STATIC:

    static let instance = BounceAnimationManager()

    // MARK: - PRIVATE INIT:

    private init() {}

    // MARK: - PUBLIC METHODS:

    func startBounceAnimation(obj: UIView) {
        obj.layer.removeAllAnimations()

        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
            obj.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }, completion: { _ in
            obj.transform = .identity
        })
    }
}
