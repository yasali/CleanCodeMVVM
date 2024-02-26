import UIKit

class HomeViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Layout.contentPadding
        layout.minimumLineSpacing = Layout.contentPadding
        layout.sectionInset = UIEdgeInsets(top: Layout.contentPadding, left: Layout.contentPadding, bottom: Layout.contentPadding, right: Layout.contentPadding)
        let itemWidth = (view.bounds.width - (Layout.contentPadding * 3)) / 2
        layout.itemSize = CGSize(width: itemWidth, height: Layout.gridCardHeight)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(SectionCell.self, forCellWithReuseIdentifier: SectionCell.reuseIdentifier)
        return collectionView
    }()

    private enum Layout {
        static let contentPadding: CGFloat = 24
        static let gridCardHeight: CGFloat = 48
    }

    private enum Style {
        static let textColor = AppTheme.Colors.primaryColor
        static let backgroundColor = AppTheme.Colors.backgroundColor
    }

    // MARK: - Init -
    private let viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.handleViewDidLoad()
        setupViews()
        setupConstraints()
        bindToViewModel()
    }

    private func setupViews() {
        view.backgroundColor = Style.backgroundColor
        view.addSubview(collectionView)
    }

    func bindToViewModel() {
        viewModel.$sections.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }.store(in: &viewModel.cancellables)

        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.showLoadingIndicator()
            } else {
                self.hideLoadingIndicator()
            }
        }.store(in: &viewModel.cancellables)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = viewModel.sections[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCell.reuseIdentifier, for: indexPath)
        if let sectionCell = cell as? SectionCell {
            sectionCell.button.setTitle(section.name, for: .normal)
            sectionCell.button.tag = indexPath.item
            sectionCell.button.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        }
        return cell
    }

    @objc private func sectionButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index < viewModel.sections.count else { return }
        let tappedSection = viewModel.sections[index]
        viewModel.didTapSection(section: tappedSection)
    }
}

fileprivate class SectionCell: UICollectionViewCell {
    static let reuseIdentifier = "SectionCell"
    private enum Layout {
        static let gridCardCornerRadius: CGFloat = 8
    }

    private enum Style {
        static let gridCardTextColor = AppTheme.Colors.primaryColor
        static let gridCardBackgroundColor = AppTheme.Colors.secondaryColor
    }

    let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(Style.gridCardTextColor, for: .normal)
        button.backgroundColor = Style.gridCardBackgroundColor
        button.layer.cornerRadius = Layout.gridCardCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
