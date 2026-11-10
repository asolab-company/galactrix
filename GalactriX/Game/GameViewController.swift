import GameplayKit
import Lottie
import SpriteKit
import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    private var gameBG = LottieAnimationView(name: "GameBG")
    private let pauseButton = UIButton()
    private let vibrationOn = Vibration()
    var pauseViewController: MenuViewController!
    var gameOverViewControoler: GameOverViewController!
    var gameScene: GameScene!
    var scoreValue: Int = 0
    var player: AVAudioPlayer?
    var flightTheme = FlightTheme.selected
    var statusMusic: Bool = true
    
    
    override func loadView() {
        self.view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameStart()
        addSubviews()
        configureConstraints()
        configureUI()
        setMusic()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    private func gameStart() {
        if let view = view as? SKView {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                gameScene = scene as? GameScene
                gameScene.gameDelegate = self
                gameScene.flightTheme = flightTheme
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
            createLottieBackground()
        }
    }

    
    private func addSubviews() {
        view.addSubview(pauseButton)
    }
    

    private func configureConstraints() {
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive = true
        pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        pauseButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        pauseButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
    }

    
    private func configureUI() {
        pauseButton.setImage(UIImage(resource: .pause), for: .normal)
        pauseButton.accessibilityLabel = "Pause"
        pauseButton.accessibilityIdentifier = "pause-game"
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func pauseButtonTapped() {
        VibrationManager.instance.vibrationStandart()
        gameScene.pauseTheGame()
        let pauseViewController = PauseViewController()
        pauseViewController.gameScene = gameScene
        pauseViewController.modalTransitionStyle = .crossDissolve
        pauseViewController.modalPresentationStyle = .fullScreen
        present(pauseViewController, animated: true)
    }
    
    
    func showVC(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.bounds = view.bounds
        viewController.view.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            viewController.view.alpha = 1
        }
    }
    
    
    func hidePauseScreen(viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()

        viewController.view.alpha = 1
        UIView.animate(withDuration: 0.5) {
            viewController.view.alpha = 0
        } completion: { _ in
            viewController.view.removeFromSuperview()
        }
    }
    
    
    private func createLottieBackground() {
        view.addSubview(gameBG)
        gameBG.translatesAutoresizingMaskIntoConstraints = false
        gameBG.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gameBG.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gameBG.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        gameBG.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        gameBG.play()
        gameBG.loopMode = .autoReverse
        gameBG.contentMode = .scaleAspectFill
        gameBG.layer.opacity = 0.1
        gameBG.isUserInteractionEnabled = false
        view.addSubview(pauseButton)
    }
    
    private func setMusic() {
        if statusMusic {
            UserDefaults.standard.setValue("backgroundMusic", forKey: "music")
            statusMusic.toggle()
        } else {
            UserDefaults.standard.setValue("backgroundMusic", forKey: "music")
        }
    }
}


extension GameViewController: GameOverVCDelegate, FinishVCDelegate {
    
    func restartGame() {
        if let view = view as? SKView {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                gameScene = scene as? GameScene
                gameScene.gameDelegate = self
                gameScene.flightTheme = flightTheme
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
            player?.play()
        }
    }
    
    func showGameOverViewController(withScore distance: Int) {
        let gameOverViewController = GameOverViewController()
        gameOverViewController.delegate = self
        gameOverViewController.score = distance
        gameOverViewController.isModalInPresentation = true
        present(gameOverViewController, animated: true, completion: nil)
    }
    
    func showFinishViewController(withDistance distance: Int) {
        let finishViewController = FinishVC()
        finishViewController.delegate = self
        finishViewController.score = distance
        finishViewController.isModalInPresentation = true
        present(finishViewController, animated: true, completion: nil)
    }
}

extension GameViewController: GameSceneDelegate {
    func gameDidEnd(withDistance distance: Int) {
        UserDefaults.standard.set(distance, forKey: "lastFlightScore")
        player?.stop()
        showGameOverViewController(withScore: distance)
    }
    
    func gameDidFinish(withDistance distance: Int) {
        UserDefaults.standard.set(distance, forKey: "lastFlightScore")
        player?.stop()
        showFinishViewController(withDistance: distance)
    }
}
