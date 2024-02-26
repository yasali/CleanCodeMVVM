import UIKit

class UIKitViewControllerFactory: ViewControllerFactoryProtocol {
    func createViewController(with type: ViewControllerType) -> UIViewController {
        switch type {
        case .home(let viewModel):
            return HomeViewController(viewModel: viewModel)
        case .homeDetails(let viewModel):
            return HomeDetailsViewController(viewModel: viewModel)
        }
    }
}
