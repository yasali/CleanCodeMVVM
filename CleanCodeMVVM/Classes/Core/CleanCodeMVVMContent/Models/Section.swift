struct SectionResponse: Codable {
    let title: String
    let description: String
    let links: Links
    let responseCode: ResponseCode

    enum CodingKeys: String, CodingKey {
        case title, description
        case links = "_links"
        case responseCode
    }
}

struct ResponseCode: Codable {
    let httpStatus: Int
    let statusCode: Int
    let code: Int
}

struct Links: Codable {
    let sections: [Section]
    enum CodingKeys: String, CodingKey {
        case sections = "viaplay:sections"
    }
}

struct Section: Codable {
    let id: String
    let title: String
    let href: String
    let type: String
    let sectionSort: Int
    let name: String
}
