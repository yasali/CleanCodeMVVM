import Foundation
import UIKit

protocol HomeRouterProtocol {
    var viewController: UIViewController { get }
}

final class HomeRouter: HomeRouterProtocol {
    let factory = DIManager.shared.getObject(type: ViewControllerFactoryProtocol.self)!

    lazy var viewController: UIViewController = {
        // View Model
        let viewModel = HomeViewModel()
        viewModel.setup(delegate: self)

        // View
        let viewController = factory.createViewController(with: .home(viewModel: viewModel))

        viewController.title = "CleanCodeMVVM"

        // Keep the Router reference in the View
        viewController.retain(object: self, key: &RetainKey.value)

        return viewController
    }()
}

extension HomeRouter: HomeViewModelDelegate {
    func displayHomeDetailsView(section: HomeSection) {
        DIManager.shared.getObject(type: HomeDetailsRouterProtocol.self, argument: section)!.show(controller: AppCoordinator.shared.mainNavigationController)
    }
}

// MARK: - RetainKey

private extension HomeRouter {
    enum RetainKey {
        static var value = "HomeRouter_RetainKey"
    }
}
