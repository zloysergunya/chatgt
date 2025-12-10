import SwiftUI

enum OnboardingStep {
    case splash
    case first
    case second
}

struct SplashOnboardingView: View {
    @State private var currentStep: OnboardingStep = .splash
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            switch currentStep {
            case .splash:
                SplashView(animation: animation)
                    .transition(.opacity)
            case .first:
                OnboardingFirstView(animation: animation, onContinue: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentStep = .second
                    }
                })
                .transition(.opacity)
            case .second:
                OnboardingSecondView(onContinue: {
                    // Handle final continue action
                })
                .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    currentStep = .first
                }
            }
        }
    }
}

#Preview {
    SplashOnboardingView()
}

