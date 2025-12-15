import SwiftUI

struct IconCard: View {
    let imageName: String
    var size: CGSize = CGSize(width: 82, height: 82)
    var insets: EdgeInsets = EdgeInsets(top: 18, leading: 18, bottom: 18, trailing: 18)
    
    private var imageWidth: CGFloat {
        size.width - insets.leading - insets.trailing
    }
    
    private var imageHeight: CGFloat {
        size.height - insets.top - insets.bottom
    }
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: imageWidth, height: imageHeight)
            .frame(width: size.width, height: size.height)
            .glassEffect(
                .regular.interactive().tint(.black),
                in: .rect(cornerRadius: 8.0)
            )
    }
}

#Preview {
    IconCard(imageName: "icon_onbording_3")
}
