import SwiftUI

struct ChatView: View {
    @State private var inputText: String = ""
    @State private var showSettings: Bool = false
    @State private var showPaywall: Bool = false
    @State private var showAllModels: Bool = false
    @State private var selectedModel: AIModel?
    @State private var aiModels: [AIModel] = []

    var onLogout: (() -> Void)?

    private let modelsDataStore = ModelsDataStore.shared

    private let chatHistory: [ChatHistory] = [
        ChatHistory(id: "1", title: "Chat N1", subtitle: "See you recent convercation"),
        ChatHistory(id: "2", title: "Chat N1", subtitle: "See you recent convercation")
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        if !aiModels.isEmpty {
                            aiModelsSection
                        }
                        
                        historySection
                    }
                    .padding(.top, 24)
                }
                
                Spacer()

                ChatInputBar(
                    text: $inputText,
                    onAttachTapped: handleAttach,
                    onSendTapped: handleSend
                )
            }
        }
        .task {
            await loadModelsIfNeeded()
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView(onLogout: onLogout)
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView(
                onDismiss: { showPaywall = false },
                onPurchaseSuccess: { showPaywall = false }
            )
        }
        .fullScreenCover(isPresented: $showAllModels) {
            AllModelsView { model in
                selectedModel = model
                // TODO: Handle model selection
            }
        }
    }

    private var headerSection: some View {
        HStack {
            Text("Chat GT")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            Spacer()

            HStack(spacing: 12) {
                ProButton {
                    showPaywall = true
                }

                Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gearshape")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .cornerRadius(6)
                        .padding(6)
                        .glassEffect(
                            .regular.interactive().tint(.white.opacity(0.2)),
                            in: .rect(cornerRadius: 16)
                        )
                }
            }
        }
    }

    private var aiModelsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "AI models", action: { showAllModels = true })

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(aiModels) { model in
                        AIModelGridCard(model: model) {
                            // TODO: Update selected model
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - History Section

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "History", action: {})

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(chatHistory) { history in
                        ChatHistoryCard(history: history)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Section Header

    private func sectionHeader(title: String, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            Button(action: action) {
                Text("See All")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: 0x707579))
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Actions

    private func handleAttach() {
        // TODO: Handle attachment
    }

    private func handleSend() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        // TODO: Send message
        inputText = ""
    }

    private func loadModelsIfNeeded() async {
        if !modelsDataStore.models.isEmpty {
            aiModels = modelsDataStore.models
            return
        }

        do {
            let fetchedModels = try await ModelsService.shared.fetchModels()
            modelsDataStore.models = fetchedModels
            aiModels = fetchedModels
        } catch {
            // Handle error silently or use fallback
        }
    }
}

#Preview {
    ChatView()
}
