import Foundation

final class EmailAuthService: AuthServiceProtocol {
    
    // MARK: - Singleton
    
    static let shared = EmailAuthService()
    
    private init() {}

    func signIn() async throws -> AuthResult {
        // This method requires email and password
        // Use signIn(email:password:) instead
        throw AuthError.failed("Use signIn(email:password:) for email authentication")
    }
    
    func signOut() async throws {
        // TODO: Implement real sign-out (clear tokens, session, etc.)
        try await Task.sleep(nanoseconds: 500_000_000)
    }
    
    func signIn(email: String, password: String) async throws -> AuthResult {
        guard !email.isEmpty else {
            throw AuthError.failed("Email is required")
        }
        
        guard !password.isEmpty else {
            throw AuthError.failed("Password is required")
        }
        
        guard isValidEmail(email) else {
            throw AuthError.failed("Invalid email format")
        }
        
        // TODO: Implement real email authentication
        // Example with Firebase:
        //
        // let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        // let user = authResult.user
        //
        // return AuthResult(
        //     userId: user.uid,
        //     email: user.email,
        //     displayName: user.displayName,
        //     provider: .email
        // )
        
        // Placeholder: Simulate network delay and return mock result
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        return AuthResult(
            userId: UUID().uuidString,
            email: email,
            displayName: nil,
            provider: .email
        )
    }
    
    func signUp(email: String, password: String, displayName: String? = nil) async throws -> AuthResult {
        // Validate input
        guard !email.isEmpty else {
            throw AuthError.failed("Email is required")
        }
        
        guard !password.isEmpty else {
            throw AuthError.failed("Password is required")
        }
        
        guard isValidEmail(email) else {
            throw AuthError.failed("Invalid email format")
        }
        
        guard password.count >= 6 else {
            throw AuthError.failed("Password must be at least 6 characters")
        }
        
        // TODO: Implement real email registration
        // Example with Firebase:
        //
        // let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        // let user = authResult.user
        //
        // if let displayName = displayName {
        //     let changeRequest = user.createProfileChangeRequest()
        //     changeRequest.displayName = displayName
        //     try await changeRequest.commitChanges()
        // }
        //
        // return AuthResult(
        //     userId: user.uid,
        //     email: user.email,
        //     displayName: displayName,
        //     provider: .email
        // )
        
        // Placeholder: Simulate network delay and return mock result
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        return AuthResult(
            userId: UUID().uuidString,
            email: email,
            displayName: displayName,
            provider: .email
        )
    }

    func resetPassword(email: String) async throws {
        guard !email.isEmpty else {
            throw AuthError.failed("Email is required")
        }
        
        guard isValidEmail(email) else {
            throw AuthError.failed("Invalid email format")
        }
        
        // TODO: Implement real password reset
        // Example with Firebase:
        // try await Auth.auth().sendPasswordReset(withEmail: email)
        
        // Placeholder: Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
    }
}

private extension EmailAuthService {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
}
