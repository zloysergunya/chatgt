import SwiftUI

struct ProButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("PRO")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(6)
                .background(Color(hex: 0x24BF80))
                .cornerRadius(8)
        }
    }
}

#Preview {
    ZStack {
        Color.black
        ProButton(action: {})
    }
}
