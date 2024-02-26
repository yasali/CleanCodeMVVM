import Foundation
import UIKit
import Swinject

public class AppCoordinator {
    public static let shared = AppCoordinator()
    private var navigationController: BaseNavigationBarController!
    private lazy var homeViewController: UIViewController = {
        return DIManager.shared.getObject(type: HomeRouterProtocol.self)!.viewController
    }()

    private init() {
        navigationController = BaseNavigationBarController(rootViewController: homeViewController)
    }

    // MARK: Public methods

    public func start() {
        CleanCodeMVVMContentService.shared.getSections { _ in }
    }

    public var rootViewController: UIViewController {
        return navigationController
    }

    public var mainNavigationController: UINavigationController {
        return navigationController
    }
}


