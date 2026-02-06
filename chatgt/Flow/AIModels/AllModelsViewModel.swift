import Foundation
import Combine

@MainActor
final class AllModelsViewModel: ObservableObject {

    @Published var models: [AIModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let modelsService = ModelsService.shared
    private let modelsDataStore = ModelsDataStore.shared

    init() {
        self.models = modelsDataStore.models
    }

    func loadModels() async {
        if !modelsDataStore.models.isEmpty {
            models = modelsDataStore.models
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let fetchedModels = try await modelsService.fetchModels()
            modelsDataStore.models = fetchedModels
            models = fetchedModels
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func refreshModels() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedModels = try await modelsService.fetchModels()
            modelsDataStore.models = fetchedModels
            models = fetchedModels
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
