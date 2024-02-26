struct SectionDetailsResponse: Codable {
    let sectionId: String
    let title: String
    let description: String
    let responseCode: ResponseCode

    enum CodingKeys: String, CodingKey {
        case sectionId, title, description
        case responseCode
    }
}

struct SectionDetails: Codable {
    let id: String
    let title: String
    let description: String
}

