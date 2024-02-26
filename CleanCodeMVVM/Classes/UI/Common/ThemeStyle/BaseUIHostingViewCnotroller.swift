import SwiftUI
import UIKit

class BaseUIHostingViewCnotroller<Content: View>: UIHostingController<Content> {
    // MARK: - Initialization
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(rootView: Content) {
        super.init(rootView: rootView)
    }
}
