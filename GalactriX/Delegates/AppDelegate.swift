import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let onboardingViewed: Bool = UserDefaults.standard.bool(forKey: "onboardingViewed")

        let onboardingViewController = OnboardingVC()
        let onboardingNavigationController = UINavigationController(rootViewController: onboardingViewController)
        
        let menuViewController = MenuViewController()
        let menuNavigationController = UINavigationController(rootViewController: menuViewController)

        if onboardingViewed {
            window?.rootViewController = menuNavigationController
        } else {
            window?.rootViewController = onboardingNavigationController
        }


        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}
}
