import SwiftUI

struct AllModelsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AllModelsViewModel()

    var onModelSelected: ((AIModel) -> Void)?

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)

                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(.white)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.models) { model in
                                AIModelGridCard(model: model) {
                                    onModelSelected?(model)
                                    dismiss()
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                    }
                }
            }
        }
        .task {
            await viewModel.loadModels()
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .glassEffect(
                        .regular.tint(.white.opacity(0.2)),
                        in: .circle
                    )
            }

            Spacer()

            Text("AI models")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            ProButton {
                // TODO: Show paywall
            }
        }
    }
}

#Preview {
    AllModelsView()
}
