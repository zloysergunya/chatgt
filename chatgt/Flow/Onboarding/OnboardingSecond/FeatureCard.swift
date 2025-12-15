import SwiftUI

struct FeatureCard: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: 0x707579))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .glassEffect(
            .regular.interactive().tint(.black),
            in: .rect(cornerRadius: 12)
        )
    }
}

#Preview {
    ZStack {
        Color.black
        FeatureCard(
            imageName: "icon_onbording_2_1",
            title: "Text generation",
            description: "Description of this tool\nShort and clear"
        )
        .padding()
    }
}



