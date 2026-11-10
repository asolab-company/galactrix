import UIKit

private func pinGameOrientations(for window: UIWindow?) -> UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .pad { return .all }
    return window?.rootViewController is StartupWebViewController ? .allButUpsideDown : .portrait
}

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting session: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: session.role)
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }

    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        pinGameOrientations(for: window)
    }
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    @available(iOS 27.0, *)
    func supportedInterfaceOrientations(for windowScene: UIWindowScene) -> UIInterfaceOrientationMask {
        pinGameOrientations(for: window)
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let splash = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
            ?? UIViewController()
        splash.view.backgroundColor = splash.view.backgroundColor ?? .black
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = PinPalette.mint
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.accessibilityLabel = "Loading Pin Game"
        splash.view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: splash.view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: splash.view.centerYAnchor, constant: 115)
        ])
        spinner.startAnimating()
        window.rootViewController = splash
        window.makeKeyAndVisible()

        Task { @MainActor [weak self, weak window] in
            async let route = StartupRoute.load()
            try? await Task.sleep(for: .milliseconds(650))
            guard let self, let window else { return }
            switch await route {
            case .game:
                self.showGame(in: window)
            case .website(let url):
                let browser = StartupWebViewController(url: url) { [weak self, weak window] in
                    if let self, let window { self.showGame(in: window) }
                }
                self.show(browser, in: window)
            }
        }
    }

    private func showGame(in window: UIWindow) {
        let onboardingViewed = UserDefaults.standard.bool(forKey: "onboardingViewed")
        let firstScreen: UIViewController = onboardingViewed ? MenuViewController() : OnboardingVC()
        let navigation = UINavigationController(rootViewController: firstScreen)
        navigation.setNavigationBarHidden(true, animated: false)
        show(navigation, in: window)
    }

    private func show(_ controller: UIViewController, in window: UIWindow) {
        UIView.transition(with: window, duration: UIAccessibility.isReduceMotionEnabled ? 0 : 0.18,
                          options: .transitionCrossDissolve) {
            window.rootViewController = controller
        }
        controller.setNeedsUpdateOfSupportedInterfaceOrientations()
        if pinGameOrientations(for: window) == .portrait {
            window.windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        }
    }
}
