import Foundation

extension Notification.Name {
    /// Posted when the refresh token is invalid and the user must re-authenticate.
    /// Listen for this in the root view to redirect to the login screen.
    static let sessionExpired = Notification.Name("com.chatgt.sessionExpired")
}
