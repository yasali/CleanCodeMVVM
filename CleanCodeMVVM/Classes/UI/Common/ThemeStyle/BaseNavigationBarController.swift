import UIKit

public class BaseNavigationBarController: UINavigationController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        let titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.tintColor = AppTheme.Colors.onbackgroundColor
        let backIndicatorImage = UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorImage = backIndicatorImage
        navigationBar.backIndicatorTransitionMaskImage = backIndicatorImage
        navigationItem.backButtonDisplayMode = .minimal
        navigationBar.topItem?.backButtonDisplayMode = .minimal

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppTheme.Colors.backgroundColor
        appearance.titleTextAttributes = titleTextAttributes
        appearance.shadowColor = .clear
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        self.delegate = self
    }
}

extension BaseNavigationBarController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: String(), style: .plain, target: nil, action: nil)
    }
}
