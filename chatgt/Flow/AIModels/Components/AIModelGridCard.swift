import SwiftUI

struct AIModelGridCard: View {
    let model: AIModel
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Image(model.iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 4) {
                    Text(model.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(model.description)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: 0x707579))
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: 163, alignment: .leading)
            .padding(10)
            .background(Color(hex: 0x0D1526).opacity(0.2))
            .glassEffect(
                .clear.interactive().tint(Color(hex: 0x0D1526).opacity(0.2)),
                in: .rect(cornerRadius: 16)
            )
        }
        .buttonStyle(.plain)
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
                description: "Универсальная чат-модель",
                supported: [.chat, .file]
            ), action: {})

            AIModelGridCard(model: AIModel(
                id: "deepseek-chat",
                name: "DeepSeek Chat",
                description: "Универсальная чат-модель",
                supported: [.chat, .file, .image]
            ), action: {})
        }
        .padding()
    }
}
