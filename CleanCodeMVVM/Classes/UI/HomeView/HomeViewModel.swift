import Foundation
import Combine

protocol HomeViewModelDelegate: AnyObject {
    func displayHomeDetailsView(section: HomeSection)
}

protocol HomeViewModelProtocol: AnyObject {
    // Setup
    func setup(delegate: HomeViewModelDelegate)

    // Lifecycle
    func handleViewDidLoad()

    // Data - Properties
    var isLoading: Bool { get }
    var sections: [HomeSection] { get }

    // User actions
    func didTapSection(section: HomeSection)
}

class HomeViewModel: ObservableObject, HomeViewModelProtocol {
    var cancellables = Set<AnyCancellable>()
    weak var delegate: HomeViewModelDelegate?
    @Published private(set) var sections: [HomeSection] = []
    @Published private(set) var isLoading = false

    let contentRepository = DIManager.shared.getObject(type: CleanCodeMVVMContentRepositoryProtocol.self)!

    // MARK: - Initialization
    init() {}

    func handleViewDidLoad() {
        loadData()
    }

    private func loadData() {
        isLoading = true
        contentRepository.getHomeSections { [weak self] dataSource in
            self?.isLoading = false
            guard let dataSource = dataSource else { return }
            self?.sections = dataSource.sections
        }
    }

    // MARK: - Bind
    func setup(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }

    // MARK: - User Actions
    func didTapSection(section: HomeSection) {
        delegate?.displayHomeDetailsView(section: section)
    }
}

