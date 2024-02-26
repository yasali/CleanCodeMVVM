import Foundation

protocol CleanCodeMVVMContentServiceProtocol {
    var sections: [Section] { get }
}

class CleanCodeMVVMContentService: CleanCodeMVVMContentServiceProtocol {
    public static let shared = CleanCodeMVVMContentService()
    private init() { }
    @Published var sections: [Section] = []
}

extension CleanCodeMVVMContentService {
    func getSections(completion: @escaping (Result<[Section], Error>) -> Void) {
        NetworkManager.shared.execute(urlString: "https://content.viaplay.com/ios-se") { (result: Result<SectionResponse, Error>) in
            switch result {
            case .success(let response):
                let sections = response.links.sections
                self.sections = sections
                completion(.success(sections))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getSectionDetails(url: String, completion: @escaping (Result<SectionDetails, Error>) -> Void) {
        NetworkManager.shared.execute(urlString: url) { (result: Result<SectionDetailsResponse, Error>) in
            switch result {
            case .success(let response):
                let sectionDetails = SectionDetails(id: response.sectionId, title: response.title, description: response.description)
                completion(.success(sectionDetails))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
