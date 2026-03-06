import SwiftUI
import RswiftResources

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
                        title: R.string.onboarding.feature_text(),
                        description: R.string.onboarding.feature_desc()
                    )
                    FeatureCard(
                        imageName: "icon_onbording_2_2",
                        title: R.string.onboarding.feature_code(),
                        description: R.string.onboarding.feature_desc()
                    )
                }
                HStack(spacing: 4) {
                    FeatureCard(
                        imageName: "icon_onbording_2_3",
                        title: R.string.onboarding.feature_image(),
                        description: R.string.onboarding.feature_desc()
                    )
                    FeatureCard(
                        imageName: "icon_onbording_2_4",
                        title: R.string.onboarding.feature_file(),
                        description: R.string.onboarding.feature_desc()
                    )
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 20)
        }
        .compatGlassEffect(
            .regular,
            tint: .black,
            interactive: true,
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
            
            Text(R.string.onboarding.title2())
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.white)

            HStack(spacing: 8) {
                CapsuleButton(title: R.string.onboarding.capsule_text())
                CapsuleButton(title: R.string.onboarding.capsule_code())
                CapsuleButton(title: R.string.onboarding.capsule_images())
                CapsuleButton(title: R.string.onboarding.capsule_files())
            }

            Text(R.string.onboarding.subtitle2())
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
    OnboardingSecondView(onContinue: {})
}
