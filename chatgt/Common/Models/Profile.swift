import Foundation

struct Profile: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    let email: String
    let avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "externalId"
        case name
        case email
        case avatar
    }
}
