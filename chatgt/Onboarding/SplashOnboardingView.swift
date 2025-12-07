import SwiftUI

struct SplashOnboardingView: View {
    @State private var showOnboarding = false
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            if showOnboarding {
                OnboardingFirstView(animation: animation)
                    .transition(.opacity)
            } else {
                SplashView(animation: animation)
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    showOnboarding = true
                }
            }
        }
    }
}

#Preview {
    SplashOnboardingView()
}

