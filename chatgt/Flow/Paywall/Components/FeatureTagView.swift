import SwiftUI

struct FeatureTagView: View {
    let icon: String
    let iconColor: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(iconColor)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: 0x00152C))
        )
    }
}

#Preview {
    ZStack {
        Color.black
        VStack(spacing: 12) {
            FeatureTagView(
                icon: "circle.grid.2x2.fill",
                iconColor: .green,
                title: "All-in-One AI"
            )
            FeatureTagView(
                icon: "paperplane.fill",
                iconColor: .blue,
                title: "Thinking & Search"
            )
            FeatureTagView(
                icon: "mic.fill",
                iconColor: .red,
                title: "Latest AI Models"
            )
        }
    }
}
