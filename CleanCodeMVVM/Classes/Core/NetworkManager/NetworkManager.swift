import Alamofire
import Combine

enum APIError: Error {
    case invalidURL
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    private var cancellables: Set<AnyCancellable> = []

    func execute<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let urlRequest = try createURLRequest(urlString: urlString)
            let publisher = URLSession.shared.dataTaskPublisher(for: urlRequest)
                .tryMap { data, response in
                    guard response is HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
            publisher
                .sink(receiveCompletion: { result in
                    switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }, receiveValue: { response in
                    completion(.success(response))
                })
                .store(in: &self.cancellables)
        } catch (let error) {
            completion(.failure(error))
        }
    }

    private func createURLRequest(urlString: String) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        return URLRequest(url: url)
    }
}

extension NetworkManager {
    func isOnline() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
