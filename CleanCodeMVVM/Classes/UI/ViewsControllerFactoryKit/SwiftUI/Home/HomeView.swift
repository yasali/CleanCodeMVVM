import SwiftUI

struct HomeView: View {
    final class Controller: BaseUIHostingViewCnotroller<HomeView> {
        override init(rootView: HomeView) {
            super.init(rootView: rootView)
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }

    private enum Layout {
        static let contentPaddingHorizontal: CGFloat = 16
        static let contentPadding = EdgeInsets(top: contentTopPadding, leading: contentPaddingHorizontal, bottom: 38, trailing: contentPaddingHorizontal)
        static let contentTopPadding: CGFloat = 35
        static let columnsSpacing: CGFloat = 16
        static let columnWidth: CGFloat = UIScreen.main.bounds.width / 2 - (contentPaddingHorizontal + columnsSpacing / 2)
        
        static let gridCardsRowsSpacing: CGFloat = 5
        static let gridCardCornerRadius: CGFloat = 8
        static let gridCardHeight: CGFloat = 48
    }

    private enum Style {
        static let textColor = AppTheme.Colors.primaryColor
        static let backgroundColor = AppTheme.Colors.backgroundColor
        static let gridCardTextColor = AppTheme.Colors.primaryColor
        static let gridCardBackgroundColor = AppTheme.Colors.secondaryColor
    }

    @StateObject var viewModel: HomeViewModel

    var body: some View {
        content
            .onViewDidLoad {
                viewModel.handleViewDidLoad()
            }
    }

    private var content: some View {
        ZStack {
            Color(Style.backgroundColor).ignoresSafeArea()
            if viewModel.sections.isEmpty {
                Text("No sections found")
                    .foregroundColor(Color(Style.textColor))
            } else {
                ScrollView {
                    VStack {
                        LazyVGrid(
                            columns: [
                                GridItem(.fixed(Layout.columnWidth), spacing: Layout.columnsSpacing),
                                GridItem(.fixed(Layout.columnWidth))
                            ],
                            spacing: Layout.gridCardsRowsSpacing
                        ) {
                            ForEach(viewModel.sections, id: \.self.id) { section in
                                homeSectionGrisCardView(section: section)
                                    .frame(height: Layout.gridCardHeight)
                            }
                        }
                        Spacer()
                    }
                    .padding(Layout.contentPadding)
                }
            }
            if viewModel.isLoading {
                LoadingView()
            }
        }
    }

    @ViewBuilder
    func homeSectionGrisCardView(section: HomeSection) -> some View {
        Button {
            viewModel.didTapSection(section: section)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: Layout.gridCardCornerRadius)
                                .foregroundColor(Color(Style.gridCardBackgroundColor))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text("\(section.title)")
                    .foregroundColor(Color(Style.gridCardTextColor))
            }
        }
        .buttonStyle(GridCardButtonStyle())
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
