import AVFoundation
import Lottie
import SafariServices
import UIKit
import WebKit

// MARK: - PROTOCOL:

protocol PauseVCDelegate {
    func pauseViewControllerPlayButton(_ viewControole: MenuViewController)
    func pauseViewControllerSoundButton(_ viewControole: MenuViewController)
}

class MenuViewController: UIViewController {
    // MARK: - PROPERTIES:
    
    private let playButton = UIButton()
    private let soundLabel = UILabel()
    private var livesLabel = UILabel()
    private let pauseLottie = LottieAnimationView(name: "Pause")
    private let BGPauseLottie = LottieAnimationView(name: "BGPause")
    private let pauseAnimation = LottieAnimationView(name: "PauseAnimation")
    private let vibrationOn = Vibration()
    private let infoLabel = UILabel()
    private let instagramButton = UIButton()
    private let infoButton = UIButton()
    private let livesManager = LivesManager()
    var gameScene: GameScene?
    let soundButton = UIButton()
    var delegate: PauseVCDelegate!
    var player: AVAudioPlayer!
    var soundState = true
    
    // MARK: - LIFECYCLE:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureConstraints()
        configureUI()
        playMusic()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLivesDisplay), name: Notification.Name("livesUpdated"), object: nil)
        UserDefaults.standard.set(true, forKey: "onboardingViewed")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLivesDisplay()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("livesUpdated"), object: nil)
    }
    
    // MARK: - ADD SUBVIEWS:

    private func addSubviews() {
        view.addSubview(BGPauseLottie)
        view.addSubview(pauseAnimation)
        view.addSubview(pauseLottie)
        view.addSubview(playButton)
        view.addSubview(livesLabel)
        view.addSubview(soundLabel)
        view.addSubview(soundButton)
        view.addSubview(infoLabel)
        view.addSubview(infoButton)
        view.addSubview(instagramButton)
    }

    // MARK: - CONFIGURE CONSTRAINTS:

    private func configureConstraints() {
        BGPauseLottie.translatesAutoresizingMaskIntoConstraints = false
        BGPauseLottie.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        BGPauseLottie.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        BGPauseLottie.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        BGPauseLottie.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        livesLabel.translatesAutoresizingMaskIntoConstraints = false
        livesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        livesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70).isActive = true
        
        pauseAnimation.translatesAutoresizingMaskIntoConstraints = false
        pauseAnimation.topAnchor.constraint(equalTo: view.topAnchor, constant: -25).isActive = true
        pauseAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pauseAnimation.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        pauseLottie.translatesAutoresizingMaskIntoConstraints = false
        pauseLottie.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pauseLottie.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 75).isActive = true
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 75).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        soundLabel.translatesAutoresizingMaskIntoConstraints = false
        soundLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -125).isActive = true
        soundLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20).isActive = true
        
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.topAnchor.constraint(equalTo: soundLabel.bottomAnchor, constant: 15).isActive = true
        infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        soundButton.translatesAutoresizingMaskIntoConstraints = false
        soundButton.centerYAnchor.constraint(equalTo: soundLabel.centerYAnchor, constant: 0).isActive = true
        soundButton.leadingAnchor.constraint(equalTo: soundLabel.trailingAnchor, constant: 10).isActive = true
        soundButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        soundButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        instagramButton.translatesAutoresizingMaskIntoConstraints = false
        instagramButton.centerXAnchor.constraint(equalTo: infoLabel.centerXAnchor).isActive = true
        instagramButton.centerYAnchor.constraint(equalTo: infoLabel.centerYAnchor).isActive = true
        instagramButton.heightAnchor.constraint(equalTo: infoLabel.heightAnchor, multiplier: 1).isActive = true
        instagramButton.widthAnchor.constraint(equalTo: infoLabel.widthAnchor, multiplier: 1).isActive = true
    }

    // MARK: - CONFIGURE UI:

    private func configureUI() {
        BGPauseLottie.play()
        BGPauseLottie.loopMode = .autoReverse
        BGPauseLottie.animationSpeed = 0.5
        BGPauseLottie.contentMode = .scaleAspectFill
        
        livesLabel.font = .systemFont(ofSize: 20, weight: .medium, width: .standard)
        livesLabel.textColor = .white
        livesLabel.layer.shadowRadius = 10
        livesLabel.layer.shadowOpacity = 0.5
        livesLabel.layer.shadowColor = UIColor.black.cgColor
        
        pauseAnimation.play()
        pauseAnimation.loopMode = .autoReverse
        pauseAnimation.animationSpeed = 1
        
        pauseLottie.play()
        pauseLottie.loopMode = .loop
        pauseLottie.animationSpeed = 1
        pauseLottie.contentMode = .scaleAspectFill
        
        view.backgroundColor = .clear
        playButton.setImage(UIImage(resource: .play), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        soundLabel.textColor = .systemBlue
        soundLabel.text = "Music"
        soundLabel.font = .systemFont(ofSize: 30, weight: .medium, width: .standard)
        
        soundButton.setImage(UIImage(resource: .on), for: .normal)
        soundButton.addTarget(self, action: #selector(soundButtonTapped), for: .touchUpInside)
        
        infoButton.setTitle("About Game", for: .normal)
        infoButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .medium, width: .standard)
        infoButton.setTitleColor(.systemBlue, for: .normal)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        infoLabel.textColor = .black
        infoLabel.font = .systemFont(ofSize: 10, weight: .medium, width: .standard)
        infoLabel.text = "GalactriX\nMalyshew Andrew, 2024"
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        
        instagramButton.addTarget(self, action: #selector(instagramButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - HELPERS:
    
    // PLAY BUTTON TAPPED:
    @objc private func playButtonTapped() {
        VibrationManager.instance.vibrationStandart()
        if livesManager.isOutOfLives() {
            let paywall = PaywallViewController()
            present(paywall, animated: true, completion: nil)
        } else {
            let gameViewController = GameViewController()
            gameViewController.modalTransitionStyle = .crossDissolve
            gameViewController.modalPresentationStyle = .fullScreen
            gameViewController.player = player
            present(gameViewController, animated: true)
        }
    }
    
    @objc private func soundButtonTapped() {
        VibrationManager.instance.vibrationStandart()
        if soundState {
            soundButton.setImage(UIImage(resource: .off), for: .normal)
            player.stop()
        } else {
            soundButton.setImage(UIImage(resource: .on), for: .normal)
            player.play()
        }
        soundState.toggle()
    }
    
    // PLAY MUSIC:
    private func playMusic() {
        let backgroundMusicMP3 = Bundle.main.url(forResource: "backgroundMusic", withExtension: ".mp3")
        guard let backgroundMusicMP3 = backgroundMusicMP3 else { return }
        do {
            player = try AVAudioPlayer(contentsOf: backgroundMusicMP3)
            player.numberOfLoops = -1
            player.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc private func infoButtonTapped() {
        vibrationOn.vibrationStandart()
        let alert = UIAlertController(title: "GalactriX", message: "\nThere are 10 levels in the game.\nThe speed increases from 0 to 200 every 20 points\nThe speed does not change from 200 to 300 points.\nYou need to score 300 points to win!\nLet's fly!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func instagramButtonTapped() {
        vibrationOn.vibrationHard()
        guard let url = URL(string: "https://instagram.com/malyshewandrew") else { return }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        present(safariViewController, animated: true)
    }
    
    // UPDATE LIVES DISPLAY:
    @objc private func updateLivesDisplay() {
        print("Осталось жизней: \(livesManager.currentLives)")
        livesLabel.text = NSLocalizedString("Counts of lives: ", comment: "") + String(livesManager.currentLives)
    }
}

// MARK: - EXTENSION FOR SAFARI:

extension MenuViewController: SFSafariViewControllerDelegate {
    func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
        print("Open in Safari app")
    }
}
