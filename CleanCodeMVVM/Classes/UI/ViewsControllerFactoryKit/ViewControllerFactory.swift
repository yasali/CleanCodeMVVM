import UIKit

enum ViewControllerType {
    case home(viewModel: HomeViewModel)
    case homeDetails(viewModel: HomeDetailsViewModel)
}

protocol ViewControllerFactoryProtocol {
    func createViewController(with type: ViewControllerType) -> UIViewController
}
