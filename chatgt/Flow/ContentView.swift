import SwiftUI

enum AppFlow {
    case onboarding
    case main
}

struct ContentView: View {
    @State private var currentFlow: AppFlow = .onboarding

    private let tokenStorage = TokenStorage.shared
    private let onboardingDataStore = OnboardingDataStore()

    var body: some View {
        ZStack {
            switch currentFlow {
            case .onboarding:
                SplashOnboardingView(onFlowCompleted: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentFlow = .main
                    }
                })
                .transition(.opacity)

            case .main:
                ChatView(onLogout: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentFlow = .onboarding
                    }
                })
                .transition(.opacity)
            }
        }
        .onAppear {
            if tokenStorage.isAuthenticated || onboardingDataStore.hasCompletedOnboarding {
                currentFlow = .main
            }
        }
    }
}

#Preview {
    ContentView()
}
