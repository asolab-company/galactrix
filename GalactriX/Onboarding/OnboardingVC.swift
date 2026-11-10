import UIKit
import AVFoundation

final class OnboardingVC: UIViewController {

    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    private let layout = UICollectionViewFlowLayout()
    private let continueButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
        obj.titleLabel?.font = FontManager.semibold(size: 17).uiFont
        obj.setTitleColor(.black, for: .normal)
        obj.backgroundColor = .white
        obj.layer.masksToBounds = true
        return obj
    }()
    private var index: Int = 0
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playerMusic = AVAudioPlayer()

    private let onboardingData: [(title: String, description: String, image: UIImage)] = [
        (NSLocalizedString("GalactriX", comment: ""), NSLocalizedString("Navigate your spaceship through an endless asteroid field, blasting obstacles and collecting power-ups in a fast-paced space adventure.", comment: ""), image: UIImage(resource: .onboardingOne)),
        (NSLocalizedString("GalactriX", comment: ""), NSLocalizedString("Earn points to unlock new ships, weapons, and shields as you face increasingly intense waves of asteroids and cosmic enemies.", comment: ""), image: UIImage(resource: .onboardingTwo)),
        (NSLocalizedString("GalactriX", comment: ""), NSLocalizedString("Engage in thrilling arcade-style combat with intuitive controls, vibrant graphics, and explosive effects in the depths of space.", comment: ""), image: UIImage(resource: .onboardingThree))
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        playMusic()
        setupVideoBackground()
        addSubviews()
        configureConstraints()
        configureCollectionView()
        setupActions()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BounceAnimationManager.instance.startBounceAnimation(obj: continueButton)
    }

    deinit {
        player?.currentItem?.removeObserver(self, forKeyPath: "status")
    }
    
    
    private func addSubviews() {
        view.addSubviews(collectionView, continueButton)
    }
    
    
    private func configureConstraints() {
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        continueButton.heightAnchor.constraint(equalTo: continueButton.widthAnchor, multiplier: 0.15).isActive = true
    }


    private func setupVideoBackground() {
        guard let videoURL = Bundle.main.url(forResource: "startVideo", withExtension: "mp4") else { return }
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = view.bounds

        if let layer = playerLayer {
            view.layer.insertSublayer(layer, at: 0)
        }

        player?.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        player?.play()
    }

    @objc private func playerDidFinishPlaying() {
        player?.seek(to: .zero)
        player?.play()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status",
           let item = object as? AVPlayerItem,
           item.status == .readyToPlay {
            player?.play()
        }
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        collectionView.collectionViewLayout = layout
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: "OnboardingCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
    }
    
    
    private func setupActions() {
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }

    
    @objc private func continueButtonTapped() {
        VibrationManager.instance.vibrationStandart()
        if index == self.onboardingData.count - 1 {
            playerMusic.stop()
            let menuViewController = MenuViewController()
            navigationController?.setViewControllers([menuViewController], animated: true)
        } else {
            let nextIndex = index + 1
            index = nextIndex
            let nextIndexPath = IndexPath(item: nextIndex, section: 0)
            self.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func playMusic() {
        guard let url = Bundle.main.url(forResource: "name", withExtension: "mp3"),
              let audioPlayer = try? AVAudioPlayer(contentsOf: url) else { return }
        playerMusic = audioPlayer
        audioPlayer.play()
    }
}


extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as? OnboardingCell else {
            return UICollectionViewCell()
        }
        let item = onboardingData[indexPath.item]
        cell.configure(title: item.title, description: item.description, image: item.image)
        return cell
    }
}
