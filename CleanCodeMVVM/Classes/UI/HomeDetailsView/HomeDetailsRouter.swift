import Foundation
import UIKit

protocol HomeDetailsRouterProtocol {
    func show(controller: UINavigationController?)
}

final class HomeDetailsRouter: HomeDetailsRouterProtocol {
    let factory = DIManager.shared.getObject(type: ViewControllerFactoryProtocol.self)!
    private weak var navigationController: UINavigationController?
    let section: HomeSection

    init(section: HomeSection) {
        self.section = section
    }

    func show(controller: UINavigationController?) {
        // View Model
        let viewModel = HomeDetailsViewModel(section: section)
        viewModel.delegate = self

        // View
        let viewController = factory.createViewController(with: .homeDetails(viewModel: viewModel))

        // Keep the Router reference in the View
        viewController.retain(object: self, key: &RetainKey.value)
        viewController.title = viewModel.navBarTitle
        
        // Private
        navigationController = controller

        // Push
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeDetailsRouter: HomeDetailsViewModelDelegate {}

// MARK: - RetainKey

private extension HomeDetailsRouter {
    enum RetainKey {
        static var value = "HomeDetailsRouter_RetainKey"
    }
}
