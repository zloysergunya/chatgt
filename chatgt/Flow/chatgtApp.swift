import SwiftUI
import GoogleSignIn

@main
struct chatgtApp: App {
    @Environment(\.scenePhase) private var scenePhase

    private let tokenRefreshService = TokenRefreshService.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                // App came to foreground — check if token needs refresh
                Task {
                    await tokenRefreshService.refreshIfNeeded()
                }
            }
        }
    }
}
