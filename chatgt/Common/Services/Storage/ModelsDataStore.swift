import Foundation

protocol StoresModels: AnyObject {
    var models: [AIModel] { get set }
}

final class ModelsDataStore: StoresModels {
    static let shared = ModelsDataStore()

    var models: [AIModel] = []

    private init() {}
}
