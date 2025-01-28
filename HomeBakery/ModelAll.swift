import Foundation

struct ChefApi: Codable {
    let records: [ChefRecord]
}

struct ChefRecord: Codable {
    let id: String
    let fields: Chef
}

struct Chef: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let password: String
}


struct APIResponse: Codable {
    let records: [Record]
}

struct Record: Codable {
    let id: String
    let fields: Course
}

struct Course: Codable, Identifiable {
    let title: String
    let description: String
    let level: String
    let imageUrl: String
    let locationName: String
    let locationLongitude: Double
    let locationLatitude: Double
    let startDate: Int
    let endDate: Int
    let chefID: String?

    // Conformance to Identifiable
    var id: String { title }

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case level
        case imageUrl = "image_url"
        case locationName = "location_name"
        case locationLongitude = "location_longitude"
        case locationLatitude = "location_latitude"
        case startDate = "start_date"
        case endDate = "end_date"
        case chefID = "chef_id"
    }
}
