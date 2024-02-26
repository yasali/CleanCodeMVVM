import SwiftUI

struct HomeDetailsView: View {
    final class Controller: BaseUIHostingViewCnotroller<HomeDetailsView> {
        override init(rootView: HomeDetailsView) {
            super.init(rootView: rootView)
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }

    private enum Layout {
        static let contentPadding: CGFloat = 40
    }

    private enum Style {
        static let textColor = AppTheme.Colors.primaryColor
        static let backgroundColor = AppTheme.Colors.backgroundColor
    }

    @StateObject var viewModel: HomeDetailsViewModel

    var body: some View {
        content
            .onViewDidLoad {
                viewModel.handleViewDidLoad()
            }
    }

    private var content: some View {
        ZStack {
            Color(Style.backgroundColor).ignoresSafeArea()
            if let sectionDetails = viewModel.sectionDetails {
                VStack {
                    Text("\(sectionDetails.description)")
                        .foregroundColor(Color(Style.textColor))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding(Layout.contentPadding)
            } else {
                if viewModel.isLoading {
                    LoadingView()
                } else {
                    Text("No details found!")
                        .foregroundColor(Color(Style.textColor))
                }
            }
        }
    }
}
