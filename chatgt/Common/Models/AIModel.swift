import Foundation

enum AIModelCapability: String, Codable {
    case chat = "CHAT"
    case file = "FILE"
    case image = "IMAGE"
}

struct AIModel: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let description: String
    let supported: [AIModelCapability]

    var iconName: String {
        switch id {
        case let id where id.contains("gpt"):
            return "icon_openai"
        case let id where id.contains("deepseek"):
            return "icon_deepseek"
        default:
            return "icon_default"
        }
    }
}
