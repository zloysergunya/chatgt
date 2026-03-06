import SwiftUI
import RswiftResources

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
            
            Text(R.string.onboarding.title1())
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.white)

            Text(R.string.onboarding.title3())
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)

            Text(R.string.onboarding.subtitle1())
                .font(.system(size: 13))
                .foregroundColor(Color(hex: 0x707579))

            Button(action: {
                onContinue()
            }) {
                Text(R.string.common.continue_button())
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
