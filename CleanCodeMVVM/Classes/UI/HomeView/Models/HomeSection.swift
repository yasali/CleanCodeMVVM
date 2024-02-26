struct HomeSection: Identifiable {
    let id: String
    let title: String
    let name: String
    let href: String
    var url: String {
        return href.replacingOccurrences(of: "{?dtg,productsPerPage}", with: "")
    }
}
