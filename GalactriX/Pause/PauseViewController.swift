import UIKit

final class PauseViewController: UIViewController {
    
    // MARK: - PROPERTIES:
    
    private let backgroundImageView = UIImageView()
    private let resumeButton = UIButton()
    private let menuButton = UIButton()
    var gameScene: GameScene?
    
    // MARK: - LIFYCYCLE:
    
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
    
    // MARK: - ADD SUBVIEWS:
    
    private func addSubviews() {
        view.addSubviews(backgroundImageView, resumeButton, menuButton)
    }
    
    // MARK: - CONFIGURE CONSTRAINTS:
    
    private func configureConstraints() {
        
        // BACKGROUND IMAGE:
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // RESUME BUTTON:
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        resumeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resumeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        resumeButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        resumeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // MENU BUTTON:
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.topAnchor.constraint(equalTo: resumeButton.bottomAnchor, constant: 15).isActive = true
        menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    // MARK: - CONFIGURE UI:
    
    private func configureUI() {
        
        // VIEW:
        view.backgroundColor = .systemBlue
        
        // BACKGROUND IMAGE:
        backgroundImageView.image = UIImage(resource: .pauseBackground)
        backgroundImageView.contentMode = .scaleAspectFill
        
        // RESUME BUTTON:
        resumeButton.setImage(UIImage(resource: .resume), for: .normal)
        resumeButton.addTarget(self, action: #selector(resumeButtonTapped), for: .touchUpInside)
        
        // MENU BUTTON:
        menuButton.setImage(UIImage(resource: .menu), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - HELPERS:
    
    // RESUME BUTTON TAPPED:
    @objc private func resumeButtonTapped() {
        VibrationManager.instance.vibrationStandart()
        gameScene?.unpauseTheGame()
        dismiss(animated: true)
    }
    
    // MENU BUTTON TAPPED:
    @objc func menuButtonTapped() {
        VibrationManager.instance.vibrationStandart()
        if let window = view.window {
            window.rootViewController = MenuViewController()
            window.makeKeyAndVisible()
        }
    }
}
