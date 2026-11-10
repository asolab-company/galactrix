import AVFoundation
import Lottie
import StoreKit
import UIKit
import SafariServices
import WebKit

final class PaywallViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    private let backgroundImageView = UIImageView()
    private let backgroundLottie = LottieAnimationView(name: "BackgroundGameOver")
    private let crownLottie = LottieAnimationView(name: "PaywallCrownLottie")
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let pricesView = UIView()

    private let monthButton = UIButton(type: .system)
    private let monthDescriptionView = UIView()
    private let monthDescriptionLabel = UILabel()
    private let monthTitleLabel = UILabel()
    private let monthLineView = UIView()
    private let monthPriceLabel = UILabel()
    private let monthPriceDescriptionLabel = UILabel()
    
    private let weekButton = UIButton(type: .system)
    private let weekDescriptionView = UIView()
    private let weekDescriptionLabel = UILabel()
    private let weekTitleLabel = UILabel()
    private let weekLineView = UIView()
    private let weekPriceLabel = UILabel()
    private let weekPriceDescriptionLabel = UILabel()
    
    private let yearButton = UIButton(type: .system)
    private let yearDescriptionView = UIView()
    private let yearDescriptionLabel = UILabel()
    private let yearTitleLabel = UILabel()
    private let yearLineView = UIView()
    private let yearPriceLabel = UILabel()
    private let yearPriceDescriptionLabel = UILabel()

    private let subscribeButton = UIButton(type: .system)
    private let configurationImage = UIImage.SymbolConfiguration(pointSize: 21)
    private let continueImage = UIImageView()
    private let restoreButton = UIButton(type: .system)
    private let lineOne = UIView()
    private let termsButton = UIButton(type: .system)
    private let lineTwo = UIView()
    private let privacyButton = UIButton(type: .system)
    
    private var product: SKProduct?
    private let livesManager = LivesManager()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var five: Bool = false
    private var twentyFive: Bool = true
    private var hundred: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureConstraints()
        configureUI()
        SKPaymentQueue.default().add(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BounceAnimationManager.instance.startBounceAnimation(obj: subscribeButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        subscribeButton.layer.cornerRadius = subscribeButton.frame.height / 2
    }

    
    private func addSubviews() {
        view.addSubviews(backgroundImageView, backgroundLottie, crownLottie, titleLabel, descriptionLabel, pricesView, subscribeButton, restoreButton, lineOne, termsButton, lineTwo, privacyButton)
        pricesView.addSubviews(monthButton, weekButton, yearButton)
        monthButton.addSubviews(monthDescriptionView, monthDescriptionLabel, monthTitleLabel, monthLineView, monthPriceLabel, monthPriceDescriptionLabel)
        weekButton.addSubviews(weekDescriptionView, weekDescriptionLabel, weekTitleLabel, weekLineView, weekPriceLabel, weekPriceDescriptionLabel)
        yearButton.addSubviews(yearDescriptionView, yearDescriptionLabel, yearTitleLabel, yearLineView, yearPriceLabel, yearPriceDescriptionLabel)
        subscribeButton.addSubviews(continueImage)
    }


    private func configureConstraints() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        backgroundLottie.translatesAutoresizingMaskIntoConstraints = false
        backgroundLottie.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundLottie.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundLottie.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundLottie.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        crownLottie.translatesAutoresizingMaskIntoConstraints = false
        crownLottie.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        crownLottie.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
        crownLottie.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        crownLottie.heightAnchor.constraint(equalTo: crownLottie.widthAnchor, multiplier: 1).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: crownLottie.bottomAnchor, constant: -30).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        
        pricesView.translatesAutoresizingMaskIntoConstraints = false
        pricesView.bottomAnchor.constraint(equalTo: subscribeButton.topAnchor, constant: -10).isActive = true
        pricesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        pricesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        pricesView.heightAnchor.constraint(equalTo: pricesView.widthAnchor, multiplier: 0.7).isActive = true
        
        monthButton.translatesAutoresizingMaskIntoConstraints = false
        monthButton.trailingAnchor.constraint(equalTo: weekButton.leadingAnchor, constant: -15).isActive = true
        monthButton.bottomAnchor.constraint(equalTo: subscribeButton.topAnchor, constant: -15).isActive = true
        monthButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.28).isActive = true
        monthButton.heightAnchor.constraint(equalTo: weekButton.widthAnchor, multiplier: 1.2).isActive = true
        
        monthDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        monthDescriptionView.topAnchor.constraint(equalTo: monthButton.topAnchor, constant: 7).isActive = true
        monthDescriptionView.centerXAnchor.constraint(equalTo: monthButton.centerXAnchor).isActive = true
        monthDescriptionView.widthAnchor.constraint(equalTo: monthButton.widthAnchor, multiplier: 0.8).isActive = true
        monthDescriptionView.heightAnchor.constraint(equalTo: monthDescriptionView.widthAnchor, multiplier: 0.2).isActive = true
        
        monthDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        monthDescriptionLabel.centerXAnchor.constraint(equalTo: monthDescriptionView.centerXAnchor).isActive = true
        monthDescriptionLabel.centerYAnchor.constraint(equalTo: monthDescriptionView.centerYAnchor).isActive = true
        
        monthTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        monthTitleLabel.centerXAnchor.constraint(equalTo: monthButton.centerXAnchor).isActive = true
        monthTitleLabel.bottomAnchor.constraint(equalTo: monthButton.centerYAnchor, constant: -10).isActive = true
        monthTitleLabel.widthAnchor.constraint(equalTo: monthButton.widthAnchor, multiplier: 0.9).isActive = true
        
        monthLineView.translatesAutoresizingMaskIntoConstraints = false
        monthLineView.centerYAnchor.constraint(equalTo: monthButton.centerYAnchor).isActive = true
        monthLineView.widthAnchor.constraint(equalTo: monthButton.widthAnchor, multiplier: 1).isActive = true
        monthLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        monthPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        monthPriceLabel.topAnchor.constraint(equalTo: monthButton.centerYAnchor, constant: 10).isActive = true
        monthPriceLabel.centerXAnchor.constraint(equalTo: monthButton.centerXAnchor).isActive = true
        
        monthPriceDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        monthPriceDescriptionLabel.centerXAnchor.constraint(equalTo: monthButton.centerXAnchor).isActive = true
        monthPriceDescriptionLabel.bottomAnchor.constraint(equalTo: monthButton.bottomAnchor, constant: -10).isActive = true
        
        weekButton.translatesAutoresizingMaskIntoConstraints = false
        weekButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weekButton.bottomAnchor.constraint(equalTo: subscribeButton.topAnchor, constant: -15).isActive = true
        weekButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.28).isActive = true
        weekButton.heightAnchor.constraint(equalTo: weekButton.widthAnchor, multiplier: 1.2).isActive = true
        
        weekDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        weekDescriptionView.topAnchor.constraint(equalTo: weekButton.topAnchor, constant: 7).isActive = true
        weekDescriptionView.centerXAnchor.constraint(equalTo: weekButton.centerXAnchor).isActive = true
        weekDescriptionView.widthAnchor.constraint(equalTo: weekButton.widthAnchor, multiplier: 0.8).isActive = true
        weekDescriptionView.heightAnchor.constraint(equalTo: weekDescriptionView.widthAnchor, multiplier: 0.2).isActive = true
        
        weekDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weekDescriptionLabel.centerXAnchor.constraint(equalTo: weekDescriptionView.centerXAnchor).isActive = true
        weekDescriptionLabel.centerYAnchor.constraint(equalTo: weekDescriptionView.centerYAnchor).isActive = true
        
        weekTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        weekTitleLabel.centerXAnchor.constraint(equalTo: weekButton.centerXAnchor).isActive = true
        weekTitleLabel.bottomAnchor.constraint(equalTo: weekButton.centerYAnchor, constant: -10).isActive = true
        weekTitleLabel.widthAnchor.constraint(equalTo: weekButton.widthAnchor, multiplier: 0.9).isActive = true
        
        weekLineView.translatesAutoresizingMaskIntoConstraints = false
        weekLineView.centerYAnchor.constraint(equalTo: weekButton.centerYAnchor).isActive = true
        weekLineView.widthAnchor.constraint(equalTo: weekButton.widthAnchor, multiplier: 1).isActive = true
        weekLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        weekPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        weekPriceLabel.topAnchor.constraint(equalTo: weekButton.centerYAnchor, constant: 10).isActive = true
        weekPriceLabel.centerXAnchor.constraint(equalTo: weekButton.centerXAnchor).isActive = true
        
        weekPriceDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weekPriceDescriptionLabel.centerXAnchor.constraint(equalTo: weekButton.centerXAnchor).isActive = true
        weekPriceDescriptionLabel.bottomAnchor.constraint(equalTo: weekButton.bottomAnchor, constant: -10).isActive = true
        
        yearButton.translatesAutoresizingMaskIntoConstraints = false
        yearButton.leadingAnchor.constraint(equalTo: weekButton.trailingAnchor, constant: 15).isActive = true
        yearButton.bottomAnchor.constraint(equalTo: subscribeButton.topAnchor, constant: -15).isActive = true
        yearButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.28).isActive = true
        yearButton.heightAnchor.constraint(equalTo: weekButton.widthAnchor, multiplier: 1.2).isActive = true
        
        yearDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        yearDescriptionView.topAnchor.constraint(equalTo: yearButton.topAnchor, constant: 7).isActive = true
        yearDescriptionView.centerXAnchor.constraint(equalTo: yearButton.centerXAnchor).isActive = true
        yearDescriptionView.widthAnchor.constraint(equalTo: yearButton.widthAnchor, multiplier: 0.8).isActive = true
        yearDescriptionView.heightAnchor.constraint(equalTo: yearDescriptionView.widthAnchor, multiplier: 0.2).isActive = true
        
        yearDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        yearDescriptionLabel.centerXAnchor.constraint(equalTo: yearDescriptionView.centerXAnchor).isActive = true
        yearDescriptionLabel.centerYAnchor.constraint(equalTo: yearDescriptionView.centerYAnchor).isActive = true
        
        yearTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        yearTitleLabel.centerXAnchor.constraint(equalTo: yearButton.centerXAnchor).isActive = true
        yearTitleLabel.bottomAnchor.constraint(equalTo: yearButton.centerYAnchor, constant: -10).isActive = true
        yearTitleLabel.widthAnchor.constraint(equalTo: yearButton.widthAnchor, multiplier: 0.9).isActive = true
        
        yearLineView.translatesAutoresizingMaskIntoConstraints = false
        yearLineView.centerYAnchor.constraint(equalTo: yearButton.centerYAnchor).isActive = true
        yearLineView.widthAnchor.constraint(equalTo: yearButton.widthAnchor, multiplier: 1).isActive = true
        yearLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

        yearPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        yearPriceLabel.topAnchor.constraint(equalTo: yearButton.centerYAnchor, constant: 10).isActive = true
        yearPriceLabel.centerXAnchor.constraint(equalTo: yearButton.centerXAnchor).isActive = true
        
        yearPriceDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        yearPriceDescriptionLabel.centerXAnchor.constraint(equalTo: yearButton.centerXAnchor).isActive = true
        yearPriceDescriptionLabel.bottomAnchor.constraint(equalTo: yearButton.bottomAnchor, constant: -10).isActive = true
        
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        subscribeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        subscribeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        subscribeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        subscribeButton.heightAnchor.constraint(equalTo: subscribeButton.widthAnchor, multiplier: 0.16).isActive = true
        
        continueImage.translatesAutoresizingMaskIntoConstraints = false
        continueImage.centerYAnchor.constraint(equalTo: subscribeButton.centerYAnchor).isActive = true
        continueImage.trailingAnchor.constraint(equalTo: subscribeButton.trailingAnchor, constant: -15).isActive = true
        continueImage.heightAnchor.constraint(equalTo: subscribeButton.heightAnchor, multiplier: 0.4).isActive = true
        
        restoreButton.translatesAutoresizingMaskIntoConstraints = false
        restoreButton.trailingAnchor.constraint(equalTo: lineOne.leadingAnchor, constant: -15).isActive = true
        restoreButton.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 15).isActive = true
        
        lineOne.translatesAutoresizingMaskIntoConstraints = false
        lineOne.centerYAnchor.constraint(equalTo: termsButton.centerYAnchor).isActive = true
        lineOne.trailingAnchor.constraint(equalTo: termsButton.leadingAnchor, constant: -15).isActive = true
        lineOne.heightAnchor.constraint(equalToConstant: 10).isActive = true
        lineOne.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        termsButton.translatesAutoresizingMaskIntoConstraints = false
        termsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        termsButton.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 15).isActive = true
        
        lineTwo.translatesAutoresizingMaskIntoConstraints = false
        lineTwo.centerYAnchor.constraint(equalTo: termsButton.centerYAnchor).isActive = true
        lineTwo.leadingAnchor.constraint(equalTo: termsButton.trailingAnchor, constant: 15).isActive = true
        lineTwo.heightAnchor.constraint(equalToConstant: 10).isActive = true
        lineTwo.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        privacyButton.translatesAutoresizingMaskIntoConstraints = false
        privacyButton.leadingAnchor.constraint(equalTo: lineTwo.trailingAnchor, constant: 15).isActive = true
        privacyButton.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 15).isActive = true
    }

    
    private func configureUI() {

        backgroundImageView.image = UIImage(resource: .paywallBackground)
        backgroundImageView.contentMode = .scaleAspectFill
        
        backgroundLottie.play()
        backgroundLottie.loopMode = .loop
        backgroundLottie.contentMode = .scaleAspectFill
        backgroundLottie.layer.opacity = 0.1
        
        crownLottie.play()
        crownLottie.loopMode = .loop
        crownLottie.animationSpeed = 0.5
        crownLottie.contentMode = .scaleAspectFill
        
        titleLabel.textColor = .systemYellow
        titleLabel.font = FontManager.black(size: 36).uiFont
        titleLabel.textAlignment = .center
        titleLabel.text = NSLocalizedString("PREMIUM", comment: "")
        
        descriptionLabel.textColor = .white
        descriptionLabel.font = FontManager.regular(size: 9).uiFont
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = NSLocalizedString("Every day you get 10 free lives. But you can buy extra lives now to be able to get to the very end.", comment: "")
        
        monthButton.layer.masksToBounds = true
        monthButton.backgroundColor = UIColor.white
        monthButton.layer.cornerRadius = 30
        monthButton.layer.borderWidth = 0.5
        monthButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            VibrationManager.instance.vibrationStandart()
            
            self.monthButton.backgroundColor = .systemBlue
            self.weekButton.backgroundColor = UIColor.white
            self.yearButton.backgroundColor = UIColor.white
            
            self.monthDescriptionView.backgroundColor = UIColor.white
            self.weekDescriptionView.backgroundColor = .systemBlue
            self.yearDescriptionView.backgroundColor = .systemBlue
            
            self.monthDescriptionLabel.textColor = .systemBlue
            self.weekDescriptionLabel.textColor = UIColor.white
            self.yearDescriptionLabel.textColor = UIColor.white
            
            self.monthTitleLabel.textColor = UIColor.white
            self.weekTitleLabel.textColor = .systemBlue
            self.yearTitleLabel.textColor = .systemBlue
            
            self.monthPriceLabel.textColor = UIColor.white
            self.weekPriceLabel.textColor = UIColor.gray
            self.yearPriceLabel.textColor = UIColor.gray
            
            self.monthPriceDescriptionLabel.textColor = UIColor.white
            self.weekPriceDescriptionLabel.textColor = UIColor.gray
            self.yearPriceDescriptionLabel.textColor = UIColor.gray
            
            self.subscribeButton.setTitle(NSLocalizedString("Buy 10 lives", comment: "") + " - 3.99$", for: .normal)
            
            self.five = true
            self.twentyFive = false
            self.hundred = false
        }), for: .touchUpInside)
        
        monthDescriptionView.backgroundColor = .systemBlue
        monthDescriptionView.layer.cornerRadius = 8
        
        monthDescriptionLabel.textColor = UIColor.white
        monthDescriptionLabel.text = NSLocalizedString("Standart", comment: "")
        monthDescriptionLabel.textAlignment = .center
        monthDescriptionLabel.font = FontManager.bold(size: 8).uiFont
        monthDescriptionLabel.adjustsFontSizeToFitWidth = true

        monthTitleLabel.text = NSLocalizedString("Buy 10 lives", comment: "")
        monthTitleLabel.textAlignment = .center
        monthTitleLabel.textColor = .systemBlue
        monthTitleLabel.adjustsFontSizeToFitWidth = true
        monthTitleLabel.font = FontManager.bold(size: 16).uiFont
        monthTitleLabel.adjustsFontSizeToFitWidth = true
        
        monthLineView.backgroundColor = UIColor.gray
        
        monthPriceLabel.text = "$3.99"
        monthPriceLabel.textColor = UIColor.gray
        monthPriceLabel.font = FontManager.regular(size: 24).uiFont
        
        monthPriceDescriptionLabel.text = NSLocalizedString("One time", comment: "")
        monthPriceDescriptionLabel.textAlignment = .center
        monthPriceDescriptionLabel.font = FontManager.medium(size: 10).uiFont
        monthPriceDescriptionLabel.textColor = UIColor.gray
        
        weekButton.layer.masksToBounds = true
        weekButton.backgroundColor = .systemBlue
        weekButton.layer.cornerRadius = 30
        weekButton.layer.borderWidth = 0.5
        weekButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            VibrationManager.instance.vibrationStandart()

            self.monthButton.backgroundColor = UIColor.white
            self.weekButton.backgroundColor = .systemBlue
            self.yearButton.backgroundColor = UIColor.white
            
            self.monthDescriptionView.backgroundColor = .systemBlue
            self.weekDescriptionView.backgroundColor = UIColor.white
            self.yearDescriptionView.backgroundColor = .systemBlue
            
            self.monthDescriptionLabel.textColor = UIColor.white
            self.weekDescriptionLabel.textColor = .systemBlue
            self.yearDescriptionLabel.textColor = UIColor.white
            
            self.monthTitleLabel.textColor = .systemBlue
            self.weekTitleLabel.textColor = UIColor.white
            self.yearTitleLabel.textColor = .systemBlue
            
            self.monthPriceLabel.textColor = UIColor.gray
            self.weekPriceLabel.textColor = UIColor.white
            self.yearPriceLabel.textColor = UIColor.gray
            
            self.monthPriceDescriptionLabel.textColor = UIColor.gray
            self.weekPriceDescriptionLabel.textColor = UIColor.white
            self.yearPriceDescriptionLabel.textColor = UIColor.gray
            
            self.subscribeButton.setTitle(NSLocalizedString("Buy 25 lives", comment: "") + " - 17.99$", for: .normal)
            
            self.five = false
            self.twentyFive = true
            self.hundred = false
        }), for: .touchUpInside)
        
        weekDescriptionView.backgroundColor = UIColor.white
        weekDescriptionView.layer.cornerRadius = 8
        
        weekDescriptionLabel.textColor = UIColor.black
        weekDescriptionLabel.text = NSLocalizedString("Popular", comment: "")
        weekDescriptionLabel.textAlignment = .center
        weekDescriptionLabel.font = FontManager.bold(size: 8).uiFont
        weekDescriptionLabel.adjustsFontSizeToFitWidth = true
    
        weekTitleLabel.text = NSLocalizedString("Buy 25 lives", comment: "")
        weekTitleLabel.textAlignment = .center
        weekTitleLabel.textColor = UIColor.white
        weekTitleLabel.adjustsFontSizeToFitWidth = true
        weekTitleLabel.font = FontManager.bold(size: 16).uiFont
        
        weekLineView.backgroundColor = UIColor.gray
        
        weekPriceLabel.text = "$17.99"
        weekPriceLabel.textColor = UIColor.white
        weekPriceLabel.font = FontManager.regular(size: 24).uiFont
        
        weekPriceDescriptionLabel.text = NSLocalizedString("One time", comment: "")
        weekPriceDescriptionLabel.textAlignment = .center
        weekPriceDescriptionLabel.font = FontManager.medium(size: 10).uiFont
        weekPriceDescriptionLabel.textColor = UIColor.white
        
        yearButton.layer.masksToBounds = true
        yearButton.backgroundColor = UIColor.white
        yearButton.layer.cornerRadius = 30
        yearButton.layer.borderWidth = 0.5
        yearButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            VibrationManager.instance.vibrationStandart()
            
            self.monthButton.backgroundColor = UIColor.white
            self.weekButton.backgroundColor = UIColor.white
            self.yearButton.backgroundColor = .systemBlue
            
            self.monthDescriptionView.backgroundColor = .systemBlue
            self.weekDescriptionView.backgroundColor = .systemBlue
            self.yearDescriptionView.backgroundColor = UIColor.white
            
            self.monthDescriptionLabel.textColor = UIColor.white
            self.weekDescriptionLabel.textColor = UIColor.white
            self.yearDescriptionLabel.textColor = .systemBlue
            
            self.monthTitleLabel.textColor = .systemBlue
            self.weekTitleLabel.textColor = .systemBlue
            self.yearTitleLabel.textColor = UIColor.white
            
            self.monthPriceLabel.textColor = UIColor.gray
            self.weekPriceLabel.textColor = UIColor.gray
            self.yearPriceLabel.textColor = UIColor.white
            
            self.monthPriceDescriptionLabel.textColor = UIColor.gray
            self.weekPriceDescriptionLabel.textColor = UIColor.gray
            self.yearPriceDescriptionLabel.textColor = UIColor.white
            
            self.subscribeButton.setTitle(NSLocalizedString("Buy 100 lives", comment: "") + " - 49.99$", for: .normal)
            
            self.five = false
            self.twentyFive = false
            self.hundred = true
        }), for: .touchUpInside)
        
        yearDescriptionView.backgroundColor = .systemBlue
        yearDescriptionView.layer.cornerRadius = 8
        
        yearDescriptionLabel.textColor = UIColor.white
        yearDescriptionLabel.text = NSLocalizedString("Best", comment: "")
        yearDescriptionLabel.textAlignment = .center
        yearDescriptionLabel.font = FontManager.bold(size: 8).uiFont
        yearDescriptionLabel.adjustsFontSizeToFitWidth = true
        
        yearTitleLabel.text = NSLocalizedString("Buy 100 lives", comment: "")
        yearTitleLabel.textAlignment = .center
        yearTitleLabel.textColor = .systemBlue
        yearTitleLabel.adjustsFontSizeToFitWidth = true
        yearTitleLabel.font = FontManager.bold(size: 16).uiFont
        
        yearLineView.backgroundColor = UIColor.gray
        
        yearPriceLabel.text = "$49.99"
        yearPriceLabel.textColor = UIColor.gray
        yearPriceLabel.font = FontManager.regular(size: 24).uiFont
        
        yearPriceDescriptionLabel.text = NSLocalizedString("One time", comment: "")
        yearPriceDescriptionLabel.textAlignment = .center
        yearPriceDescriptionLabel.font = FontManager.medium(size: 10).uiFont
        yearPriceDescriptionLabel.textColor = UIColor.gray
        
        subscribeButton.setTitle(NSLocalizedString("Buy 25 lives", comment: "") + " - 17.99$", for: .normal)
        subscribeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        subscribeButton.titleLabel?.font = FontManager.semibold(size: 17).uiFont
        subscribeButton.setTitleColor(UIColor.systemBlue, for: .normal)
        subscribeButton.backgroundColor = .white
        subscribeButton.layer.masksToBounds = true
        subscribeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            VibrationManager.instance.vibrationStandart()
            if five {
                fiveLifestButtonTapped()
            } else if twentyFive {
                twentyFiveLifesButtonTapped()
            } else if hundred {
                hundredLifesButtonTapped()
            }
        }), for: .touchUpInside)
        
        continueImage.image = UIImage(systemName: "arrow.right.circle")
        continueImage.tintColor = UIColor.white
        continueImage.contentMode = .scaleAspectFill
        
        restoreButton.setTitle("Restore", for: .normal)
        restoreButton.setTitleColor(UIColor.gray, for: .normal)
        restoreButton.titleLabel?.font = FontManager.medium(size: 10).uiFont
        restoreButton.isHidden = true
        
        lineOne.backgroundColor = UIColor.gray
        lineOne.isHidden = true
        
        termsButton.setTitle("Terms and conditions", for: .normal)
        termsButton.setTitleColor(UIColor.gray, for: .normal)
        termsButton.titleLabel?.font = FontManager.medium(size: 10).uiFont
        termsButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            VibrationManager.instance.vibrationStandart()
            guard let url = URL(string: "https://google.com/") else { return }
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.delegate = self
            self.present(safariViewController, animated: true)
        }), for: .touchUpInside)
        termsButton.isHidden = true
        
        lineTwo.backgroundColor = UIColor.gray
        lineTwo.isHidden = true
        
        privacyButton.setTitle("Privacy", for: .normal)
        privacyButton.setTitleColor(UIColor.gray, for: .normal)
        privacyButton.titleLabel?.font = FontManager.medium(size: 10).uiFont
        privacyButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            VibrationManager.instance.vibrationStandart()
            guard let url = URL(string: "https://youtube.com/") else { return }
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.delegate = self
            self.present(safariViewController, animated: true)
        }), for: .touchUpInside)
        privacyButton.isHidden = true
    }


    @objc private func fiveLifestButtonTapped() {
        VibrationManager.instance.vibrationStandart()
        startActivityIndicator()
        view.addSubview(activityIndicator)
        purchaseProduct(with: .tenLifes)
    }

    @objc private func twentyFiveLifesButtonTapped() {
        VibrationManager.instance.vibrationStandart()
        startActivityIndicator()
        view.addSubview(activityIndicator)
        purchaseProduct(with: .twentyFiveLifes)
    }

    @objc private func hundredLifesButtonTapped() {
        VibrationManager.instance.vibrationStandart()
        startActivityIndicator()
        view.addSubview(activityIndicator)
        purchaseProduct(with: .hundredLifes)
    }

    func purchaseProduct(with productID: ProductID) {
        let request = SKProductsRequest(productIdentifiers: [productID.rawValue])
        request.delegate = self
        request.start()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let fetchedProduct = response.products.first {
            product = fetchedProduct
            let payment = SKPayment(product: fetchedProduct)
            SKPaymentQueue.default().add(payment)
        } else {
            showErrorAlert()
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                handlePurchase(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                showErrorAlert()
            case .restored, .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }

    private func handlePurchase(_ transaction: SKPaymentTransaction) {
        guard let productID = ProductID(rawValue: transaction.payment.productIdentifier) else {
            stopActivityIndicator()
            return
        }
        let additionalLives = productID.livesToAdd
        livesManager.currentLives += additionalLives
        let alert = UIAlertController(title: "Success", message: "Your lives have been increased by \(additionalLives)!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.stopActivityIndicator()
        }))
        present(alert, animated: true)
        NotificationCenter.default.post(name: Notification.Name("livesUpdated"), object: nil)
    }

    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Purchase error", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.stopActivityIndicator()
        }))
        present(alert, animated: true)
    }

    private func startActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}


extension PaywallViewController: SFSafariViewControllerDelegate {
    func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {}
}
