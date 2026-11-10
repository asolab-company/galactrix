import UIKit
import Lottie
import AudioToolbox
import AVFoundation

protocol FinishVCDelegate: AnyObject {
    func showFinishViewController(withDistance: Int)
    func restartGame()
}

final class FinishVC: UIViewController {
    
    private let promtView = UIView()
    private let promtTitleLabel = UILabel()
    private let promtDescriptionLabel = UILabel()
    
    var recordLabel = UILabel()
    var scoreLabel = UILabel()
    let menuButton = UIButton(type: .system)
    let resetRecordButton = UIButton(type: .system)
    
    private let promtViewBottom = UIView()
    private let promtTitleLabelBottom = UILabel()
    private let promtImageView = UIImageView()
    
    var score: Int = 300
    weak var delegate: FinishVCDelegate?
    private let newRecord = LottieAnimationView(name: "NewRecord")
    private let finishLottie = LottieAnimationView(name: "FinishLottie")
    private let backgroundImageVIew = UIImageView()
    private let vibrationOn = Vibration()
    private var player = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureConstraints()
        configureUI()
        playFinishMusic()
        setFinishStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BounceAnimationManager.instance.startBounceAnimation(obj: menuButton)
    }

    
    private func addSubviews() {
        view.addSubviews(backgroundImageVIew, finishLottie, newRecord, recordLabel, scoreLabel, menuButton, resetRecordButton, promtView, promtTitleLabel, promtDescriptionLabel, promtViewBottom, promtTitleLabelBottom, promtImageView)
    }
    
    
    private func configureConstraints() {
        
        backgroundImageVIew.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageVIew.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageVIew.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageVIew.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageVIew.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        finishLottie.translatesAutoresizingMaskIntoConstraints = false
        finishLottie.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        finishLottie.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        finishLottie.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        finishLottie.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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
        
        promtView.translatesAutoresizingMaskIntoConstraints = false
        promtView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive = true
        promtView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        promtView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        promtView.heightAnchor.constraint(equalTo: promtView.widthAnchor, multiplier: 0.45).isActive = true
        
        promtTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        promtTitleLabel.topAnchor.constraint(equalTo: promtView.topAnchor, constant: 25).isActive = true
        promtTitleLabel.leadingAnchor.constraint(equalTo: promtView.leadingAnchor, constant: 25).isActive = true
        
        promtDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        promtDescriptionLabel.topAnchor.constraint(equalTo: promtTitleLabel.bottomAnchor, constant: 15).isActive = true
        promtDescriptionLabel.leadingAnchor.constraint(equalTo: promtView.leadingAnchor, constant: 25).isActive = true
        promtDescriptionLabel.widthAnchor.constraint(equalTo: promtView.widthAnchor, multiplier: 0.8).isActive = true
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        resetRecordButton.translatesAutoresizingMaskIntoConstraints = false
        resetRecordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
        resetRecordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetRecordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        resetRecordButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        promtViewBottom.translatesAutoresizingMaskIntoConstraints = false
        promtViewBottom.bottomAnchor.constraint(equalTo: resetRecordButton.topAnchor, constant: -20).isActive = true
        promtViewBottom.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        promtViewBottom.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        promtViewBottom.heightAnchor.constraint(equalTo: promtViewBottom.widthAnchor, multiplier: 0.55).isActive = true
        
        promtTitleLabelBottom.translatesAutoresizingMaskIntoConstraints = false
        promtTitleLabelBottom.topAnchor.constraint(equalTo: promtViewBottom.topAnchor, constant: 25).isActive = true
        promtTitleLabelBottom.leadingAnchor.constraint(equalTo: promtViewBottom.leadingAnchor, constant: 25).isActive = true
        promtTitleLabelBottom.widthAnchor.constraint(equalTo: promtViewBottom.widthAnchor, multiplier: 0.9).isActive = true
        
        promtImageView.translatesAutoresizingMaskIntoConstraints = false
        promtImageView.topAnchor.constraint(equalTo: promtTitleLabelBottom.bottomAnchor, constant: -25).isActive = true
        promtImageView.centerXAnchor.constraint(equalTo: promtViewBottom.centerXAnchor).isActive = true
        promtImageView.widthAnchor.constraint(equalTo: promtViewBottom.widthAnchor, multiplier: 0.5).isActive = true
        promtImageView.heightAnchor.constraint(equalTo: promtImageView.widthAnchor, multiplier: 1).isActive = true
    }
    
    
    private func configureUI() {
        
        backgroundImageVIew.image = UIImage(named: "background3")
        backgroundImageVIew.contentMode = .scaleAspectFill
        
        newRecord.isHidden = true
        
        finishLottie.play()
        finishLottie.loopMode = .loop
        
        promtView.layer.masksToBounds = true
        promtView.layer.cornerRadius = 22
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = promtView.bounds
        blurEffectView.layer.opacity = 0.6
        promtView.addSubview(blurEffectView)
        promtView.addBlurEffect(.dark)
        
        promtView.addSubviews(promtTitleLabel, promtDescriptionLabel)
        promtTitleLabel.text = NSLocalizedString("Finish!", comment: "")
        promtTitleLabel.textColor = .lightGray
        promtTitleLabel.font = .systemFont(ofSize: 16, weight: .bold)

        promtDescriptionLabel.text = NSLocalizedString("You reached 300 points and completed the flight.", comment: "")
        promtDescriptionLabel.textColor = .white
        promtDescriptionLabel.numberOfLines = 0
        promtDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        view.backgroundColor = .systemMint
        scoreLabel.font = .systemFont(ofSize: 20, weight: .medium, width: .standard)
        scoreLabel.textColor = .white
        scoreLabel.text = NSLocalizedString("Your score: ", comment: "") + String(score)
        scoreLabel.isHidden = true
        
        recordLabel.font = .systemFont(ofSize: 20, weight: .medium, width: .standard)
        recordLabel.textColor = .white
        recordLabel.text = NSLocalizedString("Record: ", comment: "") + calculateRecord(score: score)
        recordLabel.isHidden = true
        
        menuButton.setTitle(NSLocalizedString("Menu", comment: ""), for: .normal)
        menuButton.backgroundColor = .systemBlue
        menuButton.layer.masksToBounds = true
        menuButton.layer.cornerRadius = 24
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        
        resetRecordButton.setTitle(NSLocalizedString("Reset record", comment: ""), for: .normal)
        resetRecordButton.backgroundColor = .systemBlue
        resetRecordButton.layer.masksToBounds = true
        resetRecordButton.layer.cornerRadius = 24
        resetRecordButton.addTarget(self, action: #selector(resetRecordButtonTapped), for: .touchUpInside)
        resetRecordButton.isHidden = true
        
        promtViewBottom.layer.masksToBounds = true
        promtViewBottom.layer.cornerRadius = 22
        
        let blurEffectViewBottom = UIVisualEffectView(effect: blurEffect)
        blurEffectViewBottom.frame = promtViewBottom.bounds
        blurEffectViewBottom.layer.opacity = 0.6
        promtViewBottom.addSubview(blurEffectViewBottom)
        promtViewBottom.addBlurEffect(.dark)
        
        promtViewBottom.addSubviews(promtTitleLabelBottom, promtImageView)
        promtTitleLabelBottom.text = NSLocalizedString("Congratulations, pilot!", comment: "")
        promtTitleLabelBottom.numberOfLines = 0
        promtTitleLabelBottom.textColor = .lightGray
        promtTitleLabelBottom.font = .systemFont(ofSize: 16, weight: .bold)

        promtImageView.image = UIImage()
        promtImageView.contentMode = .scaleAspectFill
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
        }
        return String(max(score, savedRecord))
    }

    private func resetRecord() -> String {
        UserDefaults.standard.set(0, forKey: "record")
        return "0"
    }


    @objc func menuButtonTapped() {
        vibrationOn.vibrationStandart()
        player.stop()
        if let window = view.window {
            window.rootViewController = MenuViewController()
            window.makeKeyAndVisible()
        }
    }
    
    @objc private func resetRecordButtonTapped() {
        recordLabel.text = "Record: " + resetRecord()
        vibrationOn.vibrationStandart()
    }
    
    private func playFinishMusic() {
        guard let url = Bundle.main.url(forResource: "finishSound", withExtension: "mp3"),
              let audioPlayer = try? AVAudioPlayer(contentsOf: url) else { return }
        player = audioPlayer
        audioPlayer.play()
    }
    
    
    private func setFinishStatus() {
        UserDefaults.standard.setValue(true, forKey: "finishStatus")
    }
}
