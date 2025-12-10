import SwiftUI

struct OnboardingSecondView: View {
    var onContinue: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("image_onboarding_background_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                
                toolsView
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height * 0.37
                    )
                
                bottomButtons(geometry: geometry)
            }
        }
        .ignoresSafeArea()
    }
    
    var toolsView: some View {
        HStack {
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    FeatureCard(
                        imageName: "icon_onbording_2_1",
                        title: "Text generation",
                        description: "Description of this tool\nShort and clear"
                    )
                    FeatureCard(
                        imageName: "icon_onbording_2_2",
                        title: "Coding Assistant",
                        description: "Description of this tool\nShort and clear"
                    )
                }
                HStack(spacing: 4) {
                    FeatureCard(
                        imageName: "icon_onbording_2_3",
                        title: "Image Generation",
                        description: "Description of this tool\nShort and clear"
                    )
                    FeatureCard(
                        imageName: "icon_onbording_2_4",
                        title: "Work with File",
                        description: "Description of this tool\nShort and clear"
                    )
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 20)
        }
        .glassEffect(
            .regular.interactive().tint(.black),
            in: .rect(cornerRadius: 16)
        )
        .padding(.horizontal, 18)
    }
    
    func bottomButtons(geometry: GeometryProxy) -> some View {
        let centerY = geometry.size.height * 0.37
        let offset: CGFloat = 118
        
        return VStack(spacing: 16) {
            Spacer()
                .frame(height: centerY + offset + 76)
            
            Text("One AI For All Tasks")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 8) {
                CapsuleButton(title: "Text")
                CapsuleButton(title: "Code")
                CapsuleButton(title: "Images")
                CapsuleButton(title: "Files")
            }
            
            Text("Seamlessly switch between AI modes and styles")
                .font(.system(size: 15))
                .foregroundColor(.gray)
            
            Button(action: {
                onContinue()
            }) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .padding(.bottom, geometry.safeAreaInsets.bottom + 84)
    }
}

#Preview {
    OnboardingSecondView(onContinue: {})
}
