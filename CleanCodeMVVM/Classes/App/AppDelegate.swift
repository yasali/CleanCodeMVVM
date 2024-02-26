import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        DIManager.shared.register(CleanCodeMVVMAssembly())
        AppCoordinator.shared.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppCoordinator.shared.rootViewController

        window?.makeKeyAndVisible()

        return true
    }
}

