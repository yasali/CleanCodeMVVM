import UIKit

class SwiftUIViewControllerFactory: ViewControllerFactoryProtocol {
    func createViewController(with type: ViewControllerType) -> UIViewController {
        switch type {
        case .home(let viewModel):
            return HomeView.Controller(rootView: HomeView(viewModel: viewModel))
        case .homeDetails(let viewModel):
            return HomeDetailsView.Controller(rootView: HomeDetailsView(viewModel: viewModel))
        }
    }
}
