import Foundation
import Combine

@MainActor
final class AllModelsViewModel: ObservableObject {

    @Published var models: [AIModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func loadModels() async {
        isLoading = true
        errorMessage = nil

        // TODO: Replace with actual API call
        // Simulating network delay
        try? await Task.sleep(nanoseconds: 500_000_000)

        models = [
            AIModel(id: "gpt-5-nano", name: "GPT-5 nano", provider: "OpenAI", iconName: "icon_openai", isNew: true),
            AIModel(id: "leonardo", name: "Leonardo", provider: "Leonardo.Ai", iconName: "icon_leonardo", isNew: true),
            AIModel(id: "grok-4", name: "Grok 4", provider: "xAi", iconName: "icon_grok", isNew: true),
            AIModel(id: "claude-sonnet", name: "Claude Sonnet", provider: "Anthropic", iconName: "icon_claude", isNew: true),
            AIModel(id: "deepseek-v", name: "DeepSeek V", provider: "DeepSeek", iconName: "icon_deepseek", isNew: true),
            AIModel(id: "gemini-2.5-flash", name: "Gemini 2.5 Flash", provider: "Google", iconName: "icon_gemini", isNew: true),
            AIModel(id: "meta", name: "Meta", provider: "OpenAI", iconName: "icon_meta", isNew: false),
            AIModel(id: "midjourney", name: "Midjorney", provider: "Midjourney, Inc", iconName: "icon_midjourney", isNew: false),
            AIModel(id: "gpt-4o", name: "GPT-4o", provider: "OpenAI", iconName: "icon_openai", isNew: false),
            AIModel(id: "perplexity", name: "Perplexity", provider: "Perplexity", iconName: "icon_perplexity", isNew: false),
            AIModel(id: "gpt-4o-mini", name: "GPT-4o mini", provider: "OpenAI", iconName: "icon_openai", isNew: false),
            AIModel(id: "gpt-4.1-nano", name: "GPT-4.1 nano", provider: "OpenAI", iconName: "icon_openai", isNew: false)
        ]

        isLoading = false
    }
}
