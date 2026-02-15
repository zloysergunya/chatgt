import SwiftUI

enum AppFlow {
    case onboarding
    case main
}

struct ContentView: View {
    @State private var currentFlow: AppFlow = .onboarding

    private let tokenStorage = TokenStorage.shared
    private let onboardingDataStore = OnboardingDataStore()
    private let tokenRefreshService = TokenRefreshService.shared

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

                // Schedule proactive token refresh on launch
                if tokenStorage.isAuthenticated {
                    Task {
                        await tokenRefreshService.scheduleProactiveRefresh()
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .sessionExpired)) { _ in
            // Session expired — redirect to login
            withAnimation(.easeInOut(duration: 0.5)) {
                currentFlow = .onboarding
            }
        }
    }
}

#Preview {
    ContentView()
}
