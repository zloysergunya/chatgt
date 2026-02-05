import SwiftUI

struct AIModelGridCard: View {
    let model: AIModel
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    modelIcon
                        .frame(width: 32, height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    if model.isNew {
                        Text("New")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .clipShape(Capsule())
                            .offset(x: 8, y: -4)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(model.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    HStack(spacing: 2) {
                        modelIcon
                            .frame(width: 14, height: 14)
                            .clipShape(RoundedRectangle(cornerRadius: 2))

                        Text(model.provider)
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: 0x707579))
                            .lineLimit(1)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(Color(hex: 0x0D1526).opacity(0.2))
            .glassEffect(
                .regular.interactive().tint(Color(hex: 0x0D1526).opacity(0.2)),
                in: .rect(cornerRadius: 16)
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var modelIcon: some View {
        if let iconURL = model.iconURL, let url = URL(string: iconURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(model.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                @unknown default:
                    Image(model.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        } else {
            Image(model.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

#Preview {
    ZStack {
        Color.black
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            AIModelGridCard(model: AIModel(
                id: "gpt-5",
                name: "GPT-5 nano",
                provider: "OpenAI",
                iconName: "icon_openai",
                isNew: true
            ), action: {})

            AIModelGridCard(model: AIModel(
                id: "claude",
                name: "Claude Sonnet",
                provider: "Anthropic",
                iconName: "icon_claude",
                isNew: true
            ), action: {})
        }
        .padding()
    }
}
