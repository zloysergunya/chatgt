import SwiftUI

struct SettingsRow: View {
    let icon: String
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .compatGlassEffect(
                        .clear,
                        tint: .white.opacity(0.2),
                        in: .rect(cornerRadius: 16)
                    )

                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(hex: 0x0D1526).opacity(0.2))
            .compatGlassEffect(
                .clear,
                tint: Color(hex: 0x0D1526).opacity(0.2),
                interactive: true,
                in: .rect(cornerRadius: 16)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.black
        VStack(spacing: 12) {
            SettingsRow(icon: "person.circle", title: "Log In", action: {})
            SettingsRow(icon: "clock.arrow.circlepath", title: "History", action: {})
        }
        .padding()
    }
}
