import SwiftUI

struct ChatHistory: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
}

struct ChatHistoryCard: View {
    let history: ChatHistory

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(history.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)

            Text(history.subtitle)
                .font(.system(size: 13))
                .foregroundColor(Color(hex: 0x707579))
                .lineLimit(1)
        }
        .frame(width: 160, alignment: .leading)
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
        ChatHistoryCard(history: ChatHistory(
            id: "1",
            title: "Chat N1",
            subtitle: "See you recent convercation"
        ))
    }
}
