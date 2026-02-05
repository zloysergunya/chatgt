import SwiftUI

enum OnboardingStep {
    case splash
    case first
    case second
    case third
    case paywall
    case signIn
}

struct SplashOnboardingView: View {
    @State private var currentStep: OnboardingStep = .splash
    @Namespace private var animation

    private let onboardingDataStore = OnboardingDataStore()

    var onFlowCompleted: (() -> Void)?

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
                .transition(.asymmetric(
                    insertion: .opacity,
                    removal: .move(edge: .leading)
                ))
            case .second:
                OnboardingSecondView(onContinue: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentStep = .third
                    }
                })
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))

            case .third:
                OnboardingThirdView(onContinue: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentStep = .signIn
                    }
                })
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))

            case .paywall:
                PaywallView(
                    onDismiss: {
                        onboardingDataStore.hasCompletedOnboarding = true
                        onFlowCompleted?()
                    },
                    onPurchaseSuccess: {
                        onboardingDataStore.hasCompletedOnboarding = true
                        onFlowCompleted?()
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .opacity
                ))

            case .signIn:
                SignInView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentStep = .paywall
                    }
                } onSignInSuccess: { _ in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentStep = .paywall
                    }
                } onSignUpTapped: {
                    // Handle sign up
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .opacity
                ))
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
