import SwiftUI

struct ChatView: View {
    @State private var inputText: String = ""
    @State private var showSettings: Bool = false
    @State private var showPaywall: Bool = false

    private let aiModels: [AIModel] = [
        AIModel(id: "gpt-5", name: "GPT-5", provider: "OpenAI", iconName: "icon_openai", isNew: true),
        AIModel(id: "perplexity", name: "Perplexity", provider: "Perplexity", iconName: "icon_perplexity", isNew: true),
        AIModel(id: "leonardo", name: "Leonardo", provider: "Leonardo", iconName: "icon_leonardo", isNew: false)
    ]

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
                        aiModelsSection
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
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView(
                onDismiss: { showPaywall = false },
                onPurchaseSuccess: { showPaywall = false }
            )
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

    // MARK: - AI Models Section

    private var aiModelsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "AI models", action: {})

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(aiModels) { model in
                        AIModelCard(model: model)
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
}

#Preview {
    ChatView()
}
