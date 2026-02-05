import SwiftUI

struct AIModel: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let provider: String
    let iconName: String
    let iconURL: String?
    let isNew: Bool

    init(id: String, name: String, provider: String, iconName: String, iconURL: String? = nil, isNew: Bool) {
        self.id = id
        self.name = name
        self.provider = provider
        self.iconName = iconName
        self.iconURL = iconURL
        self.isNew = isNew
    }
}

struct AIModelCard: View {
    let model: AIModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Image(model.iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

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

            VStack(alignment: .leading, spacing: 2) {
                Text(model.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(model.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                        .clipShape(RoundedRectangle(cornerRadius: 2))

                    Text(model.provider)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: 0x707579))
                        .lineLimit(1)
                }
            }
        }
        .frame(width: 140)
        .padding(12)
        .background(Color(hex: 0x1C1C1E))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        Color.black
        AIModelCard(model: AIModel(
            id: "gpt-5",
            name: "GPT-5",
            provider: "OpenAI",
            iconName: "icon_openai",
            isNew: true
        ))
    }
}
