import Foundation
import Combine

protocol CleanCodeMVVMContentRepositoryProtocol {
    func getHomeSections(completion: @escaping (HomeViewDataSource?) -> Void)
    func getHomeSectionDetails(for section: HomeSection, completion: @escaping (HomeDetailsViewDataSource?) -> Void)
}

class CleanCodeMVVMContentRepository: CleanCodeMVVMContentRepositoryProtocol {
    private var cancellables = Set<AnyCancellable>()
    let dataManager = DIManager.shared.getObject(type: DataManagerProtocol.self)!

    func getHomeSections(completion: @escaping (HomeViewDataSource?) -> Void) {
        if NetworkManager.shared.isOnline() {
            CleanCodeMVVMContentService.shared.getSections { [weak self] result in
                switch result {
                case .success(let sections):
                    self?.dataManager.saveSections(sections: sections)
                    completion(self?.createHomeSections(sections: sections))
                case .failure(_):
                    completion(self?.createHomeSectionsFromPersistance())
                }
            }
        } else {
            completion(self.createHomeSectionsFromPersistance())
        }
    }

    func getHomeSectionDetails(for section: HomeSection, completion: @escaping (HomeDetailsViewDataSource?) -> Void) {
        if NetworkManager.shared.isOnline() {
            CleanCodeMVVMContentService.shared.getSectionDetails(url: section.url) { [weak self] result in
                switch result {
                case .success(let sectionDetails):
                    self?.dataManager.saveSectionDetails(sectionDetails: sectionDetails)
                    completion(self?.createHomeSectionDetails(sectionDetails: sectionDetails))
                case .failure(_):
                    completion(self?.createHomeSectionDetailsFromPersistance(id: section.id))
                }
            }
        } else {
            completion(self.createHomeSectionDetailsFromPersistance(id: section.id))
        }
    }
}

// MARK: - Private methods - createHomeSections

extension CleanCodeMVVMContentRepository {
    private func createHomeSections(sections: [Section]) -> HomeViewDataSource? {
        let homeSections = sections.map { section in
            return HomeSection(id: section.id, title: section.title, name: section.name, href: section.href)
        }
        return HomeViewDataSource(sections: homeSections)
    }

    private func createHomeSectionsFromPersistance() -> HomeViewDataSource? {
        if let sections = dataManager.fetchSections() {
            return self.createHomeSections(sections: sections)
        }
        return nil
    }
}

// MARK: - Private methods - createHomeSectionDetails

extension CleanCodeMVVMContentRepository {
    private func createHomeSectionDetails(sectionDetails: SectionDetails) -> HomeDetailsViewDataSource? {
        return HomeDetailsViewDataSource(sectionDetails: HomeSectionDetails(id: sectionDetails.id, title: sectionDetails.title, description: sectionDetails.title))
    }

    private func createHomeSectionDetailsFromPersistance(id: String) -> HomeDetailsViewDataSource? {
        if let sectionsDetails = dataManager.fetchSectionDetails(id: id) {
            return self.createHomeSectionDetails(sectionDetails: sectionsDetails)
        }
        return nil
    }
}
