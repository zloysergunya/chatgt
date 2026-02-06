import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var showSignIn: Bool = false
    @State private var showPaywall: Bool = false

    private let tokenStorage = TokenStorage.shared
    private let profileDataStore = ProfileDataStore()
    private let onboardingDataStore = OnboardingDataStore()

    private let privacyPolicyURL = "https://example.com/privacy"
    private let termsOfUseURL = "https://example.com/terms"
    private let supportEmail = "support@chatgt.ai"
    private let appStoreURL = "https://apps.apple.com/app/idXXXXXXXXXX"
    private let shareText = "Check out Chat GT - AI Assistant"

    var onLogout: (() -> Void)?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 6) {
                        if !tokenStorage.isAuthenticated {
                            SettingsRow(icon: "person.circle", title: "Log In") {
                                handleLogIn()
                            }
                        }
                        
                        SettingsRow(icon: "clock.arrow.circlepath", title: "History") {
                            handleHistory()
                        }

                        SettingsRow(icon: "globe", title: "Change Language") {
                            handleChangeLanguage()
                        }

                        SettingsRow(icon: "square.and.arrow.up", title: "Share Chat GT") {
                            handleShare()
                        }

                        SettingsRow(icon: "star", title: "Rate Us") {
                            handleRateUs()
                        }

                        SettingsRow(icon: "info.circle", title: "Ask support") {
                            handleAskSupport()
                        }

                        SettingsRow(icon: "checkmark.shield", title: "Private Policy") {
                            handlePrivacyPolicy()
                        }

                        SettingsRow(icon: "doc.text", title: "Term of Use") {
                            handleTermsOfUse()
                        }
                        
                        if tokenStorage.isAuthenticated {
                            SettingsRow(icon: "rectangle.portrait.and.arrow.right", title: "Log Out") {
                                handleLogout()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                }
            }
        }
        .sheet(isPresented: $showSignIn) {
            SignInView(
                onDismiss: { showSignIn = false },
                onSignInSuccess: { _ in showSignIn = false },
                onSignUpTapped: {}
            )
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView(
                onDismiss: { showPaywall = false },
                onPurchaseSuccess: { showPaywall = false }
            )
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .glassEffect(
                        .clear.interactive().tint(.white.opacity(0.2)),
                        in: .circle
                    )
            }

            Spacer()

            Text("Settings")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            ProButton {
                showPaywall = true
            }
        }
    }

    // MARK: - Actions

    private func handleLogIn() {
        showSignIn = true
    }

    private func handleLogout() {
        try? tokenStorage.clearAll()
        profileDataStore.profile = nil
        onboardingDataStore.hasCompletedOnboarding = false
        dismiss()
        onLogout?()
    }

    private func handleHistory() {
        // TODO: Navigate to history screen
    }

    private func handleChangeLanguage() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    private func handleShare() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else { return }

        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )

        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = rootViewController.view
            popover.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        rootViewController.present(activityVC, animated: true)
    }

    private func handleRateUs() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    private func handleAskSupport() {
        if let url = URL(string: "mailto:\(supportEmail)") {
            UIApplication.shared.open(url)
        }
    }

    private func handlePrivacyPolicy() {
        if let url = URL(string: privacyPolicyURL) {
            UIApplication.shared.open(url)
        }
    }

    private func handleTermsOfUse() {
        if let url = URL(string: termsOfUseURL) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    SettingsView()
}
