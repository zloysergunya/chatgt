import SwiftUI

struct CapsuleButton: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4.5)
            .glassEffect(
                .regular.interactive().tint(.black.opacity(0.2)),
                in: .rect(cornerRadius: 8.0)
            )
    }
}

#Preview {
    CapsuleButton(title: "Chat GPT")
}
