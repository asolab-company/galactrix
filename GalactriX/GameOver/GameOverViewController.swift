import UIKit
import Lottie
import AudioToolbox
import AVFoundation

protocol GameOverVCDelegate: AnyObject {
    func showGameOverViewController(withScore: Int)
    func restartGame()
}

class GameOverViewController: UIViewController {
    
    var recordLabel = UILabel()
    var recordScore: Int = 0
    var livesLabel = UILabel()
    var scoreLabel = UILabel()
    let restartButton = UIButton()
    let resetRecordButton = UIButton()
    var score: Int = 0
    let menuButton = UIButton()
    weak var delegate: GameOverVCDelegate?
    private let backgroundLottie = LottieAnimationView(name: "Background")
    private let newRecord = LottieAnimationView(name: "NewRecord")
    private let vibrationOn = Vibration()
    private let livesManager = LivesManager()
    private var player = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureConstraints()
        configureUI()
        handleGameOver()
        playFinishMusic()
    }

    
    private func addSubviews() {
        view.addSubview(backgroundLottie)
        view.addSubview(newRecord)
        view.addSubview(recordLabel)
        view.addSubview(scoreLabel)
        view.addSubview(livesLabel)
        view.addSubview(restartButton)
        view.addSubview(resetRecordButton)
        view.addSubview(menuButton)
    }
    
    
    private func configureConstraints() {
        
        backgroundLottie.translatesAutoresizingMaskIntoConstraints = false
        backgroundLottie.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundLottie.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundLottie.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundLottie.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        newRecord.translatesAutoresizingMaskIntoConstraints = false
        newRecord.centerXAnchor.constraint(equalTo: recordLabel.centerXAnchor).isActive = true
        newRecord.centerYAnchor.constraint(equalTo: recordLabel.centerYAnchor).isActive = true
        newRecord.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        recordLabel.translatesAutoresizingMaskIntoConstraints = false
        recordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        livesLabel.translatesAutoresizingMaskIntoConstraints = false
        livesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        livesLabel.topAnchor.constraint(equalTo: restartButton.topAnchor, constant: -50).isActive = true
        
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        restartButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        restartButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        resetRecordButton.translatesAutoresizingMaskIntoConstraints = false
        resetRecordButton.topAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: 15).isActive = true
        resetRecordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetRecordButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        resetRecordButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.topAnchor.constraint(equalTo: resetRecordButton.bottomAnchor, constant: 15).isActive = true
        menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    
    private func configureUI() {
        
        backgroundLottie.play()
        backgroundLottie.loopMode = .loop
        backgroundLottie.animationSpeed = 1
        backgroundLottie.contentMode = .scaleAspectFill
        
        newRecord.isHidden = true
        
        view.backgroundColor = .systemMint
        scoreLabel.font = .systemFont(ofSize: 20, weight: .medium, width: .standard)
        scoreLabel.textColor = .white
        scoreLabel.text = "Your score: " + String(score)
        
        recordLabel.font = .systemFont(ofSize: 20, weight: .medium, width: .standard)
        recordLabel.textColor = .white
        recordLabel.text = "Record: " + calculateRecord(score: score)
        
        livesLabel.font = .systemFont(ofSize: 20, weight: .medium, width: .standard)
        livesLabel.textColor = .black
        
        restartButton.setImage(UIImage(resource: .restart), for: .normal)
        restartButton.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
        
        resetRecordButton.setImage(UIImage(resource: .resetRecord), for: .normal)
        resetRecordButton.addTarget(self, action: #selector(resetRecordButtonTapped), for: .touchUpInside)
        
        menuButton.setImage(UIImage(resource: .menu), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }
    
    private func calculateRecord(score: Int) -> String {
        let savedRecord = UserDefaults.standard.integer(forKey: "record")
        if score > savedRecord {
            UserDefaults.standard.set(score, forKey: "record")
            newRecord.isHidden = false
            newRecord.play()
            newRecord.loopMode = .playOnce
            newRecord.animationSpeed = 0.5
            vibrationOn.vibrationSucces()
        } else if score < savedRecord {
            vibrationOn.vibrationError()
        }
        
        return String(max(score, savedRecord))
    }
    
    private func resetRecord(score: Int) -> String {
        let record = 0
        UserDefaults.standard.set(record, forKey: "record")
        return String(record)
    }
    

    @objc private func restartButtonTapped1() {
        delegate?.restartGame()
        dismiss(animated: true, completion: nil)
        vibrationOn.vibrationStandart()
    }
    
    @objc func restartButtonTapped() {
        if livesManager.isOutOfLives() {
            let paywall = PaywallViewController()
            present(paywall, animated: true, completion: nil)
        } else {
            delegate?.restartGame()
            dismiss(animated: true, completion: nil)
            VibrationManager.instance.vibrationStandart()
            player.pause()
        }
    }
    
    @objc private func resetRecordButtonTapped() {
        recordLabel.text = "Record: " + resetRecord(score: 0)
        vibrationOn.vibrationStandart()
    }
    
    private func handleGameOver() {
        livesManager.decrementLife()
        if livesManager.isOutOfLives() {
            showOutOfLivesAlert()
        } else {
            updateLivesDisplay()
        }
    }
    
    private func showOutOfLivesAlert() {
        let alert = UIAlertController(title: NSLocalizedString("You've run out of lives", comment: ""), message: NSLocalizedString("Try it tomorrow or get extra lives.", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .default))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Buy", comment: ""), style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            VibrationManager.instance.vibrationStandart()
            let paywall = PaywallViewController()
            present(paywall, animated: true, completion: nil)
        }))
        present(alert, animated: true)
    }
    
    private func updateLivesDisplay() {
        livesLabel.text = NSLocalizedString("Counts of races: ", comment: "") + String(livesManager.currentLives)
    }
    
    private func playFinishMusic() {
        guard let url = Bundle.main.url(forResource: "gameOverMusic", withExtension: "mp3"),
              let audioPlayer = try? AVAudioPlayer(contentsOf: url) else { return }
        player = audioPlayer
        audioPlayer.play()
    }
    
    @objc func menuButtonTapped() {
        VibrationManager.instance.vibrationStandart()
        player.stop()
        if let window = view.window {
            window.rootViewController = MenuViewController()
            window.makeKeyAndVisible()
        }
    }
}
