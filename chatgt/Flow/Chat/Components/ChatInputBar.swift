import SwiftUI

struct ChatInputBar: View {
    @Binding var text: String
    var onAttachTapped: () -> Void
    var onSendTapped: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onAttachTapped) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color(hex: 0x2C2C2E))
                    .clipShape(Circle())
            }

            TextField("Ask anything", text: $text)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(hex: 0x1C1C1E))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )

            Button(action: onSendTapped) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color(hex: 0x2F68FF))
                    .clipShape(Circle())
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    ZStack {
        Color.black
        VStack {
            Spacer()
            ChatInputBar(
                text: .constant(""),
                onAttachTapped: {},
                onSendTapped: {}
            )
        }
    }
}
