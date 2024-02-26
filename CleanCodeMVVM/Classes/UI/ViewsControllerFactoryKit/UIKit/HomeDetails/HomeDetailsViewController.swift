import UIKit

class HomeDetailsViewController: UIViewController {
    private enum Layout {
        static let textViewPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    private enum Style {
        static let textColor = AppTheme.Colors.primaryColor
        static let backgroundColor = AppTheme.Colors.backgroundColor
    }

    // MARK: - Init -
    private let viewModel: HomeDetailsViewModel

    init(viewModel: HomeDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var descriptionTextView: UITextView = {
        let view = UITextView()
        view.textColor = Style.textColor
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.isEditable = false
        view.textAlignment = .center
        view.textContainerInset = Layout.textViewPadding
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.handleViewDidLoad()
        setupViews()
        setupConstraints()
        bindToViewModel()
    }

    private func setupViews() {
        view.backgroundColor = Style.backgroundColor
        view.addSubview(descriptionTextView)
    }

    private func bindToViewModel() {
        viewModel.$sectionDetails
            .compactMap { $0 }
            .sink { [weak self] sectionDetails in
                self?.updateUI(with: sectionDetails)
            }
            .store(in: &viewModel.cancellables)

        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.showLoadingIndicator()
            } else {
                self.hideLoadingIndicator()
            }
        }.store(in: &viewModel.cancellables)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func updateUI(with sectionDetails: HomeSectionDetails) {
        self.descriptionTextView.text = sectionDetails.description
    }

    private func showLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }

    private func hideLoadingIndicator() {
        view.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
    }
}
