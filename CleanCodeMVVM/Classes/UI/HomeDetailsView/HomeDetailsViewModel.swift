import Foundation
import Combine

protocol HomeDetailsViewModelDelegate: AnyObject {}

protocol HomeDetailsViewModelProtocol: AnyObject {
    // Setup
    func setup(delegate: HomeDetailsViewModelDelegate)

    // Lifecycle
    func handleViewDidLoad()

    // Data - Properties
    var isLoading: Bool { get }
    var sectionDetails: HomeSectionDetails? { get }
}

class HomeDetailsViewModel: ObservableObject, HomeDetailsViewModelProtocol {
    var cancellables = Set<AnyCancellable>()
    weak var delegate: HomeDetailsViewModelDelegate?
    @Published private(set) var isLoading = false
    @Published private(set) var sectionDetails: HomeSectionDetails?

    let contentRepository = DIManager.shared.getObject(type: CleanCodeMVVMContentRepositoryProtocol.self)!
    let section: HomeSection

    var navBarTitle: String {
        return section.title
    }

    // MARK: - Initialization
    init(section: HomeSection) {
        self.section = section
    }

    func handleViewDidLoad() {
        loadData()
    }

    private func loadData() {
        isLoading = true
        contentRepository.getHomeSectionDetails(for: section) { [weak self] dataSource in
            self?.isLoading = false
            guard let dataSource = dataSource else { return }
            self?.sectionDetails = dataSource.sectionDetails
        }
    }

    // MARK: - Bind
    func setup(delegate: HomeDetailsViewModelDelegate) {
        self.delegate = delegate
    }

}

