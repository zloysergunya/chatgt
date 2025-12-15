import SwiftUI

struct OnboardingThirdView: View {
    var onContinue: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("image_onboarding_background_3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                
                bottomButtons(geometry: geometry)
            }
        }
        .ignoresSafeArea()
    }
    
    func bottomButtons(geometry: GeometryProxy) -> some View {
        let centerY = geometry.size.height * 0.37
        let offset: CGFloat = 118
        
        return VStack(spacing: 16) {
            Spacer()
                .frame(height: centerY + offset + 76)
            
            Text("Top AI Models in One App")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Real-time reasoning, and live search")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Chat GT unites the world’s smartest systems")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: 0x707579))
            
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
    OnboardingThirdView(onContinue: {})
}
