import UIKit

final class PauseViewController: UIViewController {
    
    
    private let backgroundImageView = UIImageView()
    private let resumeButton = UIButton()
    private let menuButton = UIButton()
    var gameScene: GameScene?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureConstraints()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BounceAnimationManager.instance.startBounceAnimation(obj: resumeButton)
    }
    
    
    private func addSubviews() {
        view.addSubviews(backgroundImageView, resumeButton, menuButton)
    }
    
    
    private func configureConstraints() {
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        resumeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resumeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        resumeButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        resumeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.topAnchor.constraint(equalTo: resumeButton.bottomAnchor, constant: 15).isActive = true
        menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    
    private func configureUI() {
        
        view.backgroundColor = .systemBlue
        
        backgroundImageView.image = UIImage(resource: .pauseBackground)
        backgroundImageView.contentMode = .scaleAspectFill
        
        resumeButton.setImage(UIImage(resource: .resume), for: .normal)
        resumeButton.accessibilityLabel = "Resume"
        resumeButton.addTarget(self, action: #selector(resumeButtonTapped), for: .touchUpInside)
        
        menuButton.setImage(UIImage(resource: .menu), for: .normal)
        menuButton.accessibilityLabel = "Menu"
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func resumeButtonTapped() {
        VibrationManager.instance.vibrationStandart()
        gameScene?.unpauseTheGame()
        dismiss(animated: true)
    }
    
    @objc func menuButtonTapped() {
        VibrationManager.instance.vibrationStandart()
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
}
