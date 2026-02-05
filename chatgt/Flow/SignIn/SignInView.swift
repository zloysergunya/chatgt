import SwiftUI

struct SignInView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SignInViewModel()
    
    var onDismiss: (() -> Void)?
    var onSignInSuccess: ((AuthResult) -> Void)?
    var onSignUpTapped: (() -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("image_paywall_background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with close button and PRO badge
                    headerSection
                        .padding(.top, 54)
                    
                    Spacer()
                    
                    // Logo
                    IconCard(
                        imageName: "image.launch.logo",
                        size: CGSize(width: 130, height: 130),
                        insets: EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
                    )
                    
                    Spacer()
                    
                    // Title and subtitle
                    titleSection
                        .padding(.bottom, 32)
                    
                    // Sign in buttons
                    signInButtonsSection
                        .padding(.horizontal, 24)
                    
                    // Sign up link
                    signUpSection
                        .padding(.top, 24)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 40)
                }
            }
        }
        .ignoresSafeArea()
        .onChange(of: viewModel.authSuccess) { _, success in
            if success, let result = viewModel.currentAuthResult {
                onSignInSuccess?(result)
                dismiss()
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred")
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack {
            // Close button
            Button {
                onDismiss?()
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            // PRO badge
            Text("PRO")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(6)
                .background(Color(hex: 0x24BF80))
                .cornerRadius(8)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Title Section
    
    private var titleSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Text("Sign In to")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Chat GT")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(hex: 0x10B981))
            }
            
            Text("Connect once. Chat anywhere, with any model")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: 0x9CA3AF))
        }
        .multilineTextAlignment(.center)
    }
    
    // MARK: - Sign In Buttons Section
    
    private var signInButtonsSection: some View {
        VStack(spacing: 12) {
            // Google Sign In
            SignInButton(
                title: "Sign in with Google",
                icon: { GoogleIcon() },
                style: .google,
                isLoading: viewModel.isLoading
            ) {
                Task {
                    await viewModel.signInWithGoogle()
                }
            }
            
            // Apple Sign In
            SignInButton(
                title: "Sign in with Apple",
                icon: {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                },
                style: .outlined,
                isLoading: viewModel.isLoading
            ) {
                Task {
                    await viewModel.signInWithApple()
                }
            }
            
            // Email Sign In
            SignInButton(
                title: "Sign in with Email",
                icon: {
                    Image(systemName: "envelope")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                },
                style: .outlined,
                isLoading: viewModel.isLoading
            ) {
                // Navigate to email sign in screen
                // For now, trigger with placeholder credentials
                Task {
                    await viewModel.signInWithEmail(email: "test@example.com", password: "password123")
                }
            }
        }
    }
    
    // MARK: - Sign Up Section
    
    private var signUpSection: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: 0x9CA3AF))
            
            Button {
                onSignUpTapped?()
            } label: {
                Text("Sign Up")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Sign In Button

private enum SignInButtonStyle {
    case google
    case outlined
}

private struct SignInButton<Icon: View>: View {
    let title: String
    let icon: () -> Icon
    let style: SignInButtonStyle
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                icon()
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
        }
        .disabled(isLoading)
        .opacity(isLoading ? 0.6 : 1.0)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .google:
            return .white
        case .outlined:
            return Color.white.opacity(0.08)
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .google:
            return Color(hex: 0x1F2937)
        case .outlined:
            return .white
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .google:
            return .clear
        case .outlined:
            return Color.white.opacity(0.3)
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .google:
            return 0
        case .outlined:
            return 1
        }
    }
}

// MARK: - Google Icon

private struct GoogleIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            ZStack {
                // Blue arc (top-right)
                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(Color(hex: 0x4285F4), lineWidth: size * 0.18)
                    .rotationEffect(.degrees(-45))
                
                // Green arc (bottom-right)
                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(Color(hex: 0x34A853), lineWidth: size * 0.18)
                    .rotationEffect(.degrees(45))
                
                // Yellow arc (bottom-left)
                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(Color(hex: 0xFBBC05), lineWidth: size * 0.18)
                    .rotationEffect(.degrees(135))
                
                // Red arc (top-left)
                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(Color(hex: 0xEA4335), lineWidth: size * 0.18)
                    .rotationEffect(.degrees(225))
                
                // Horizontal bar
                Rectangle()
                    .fill(Color(hex: 0x4285F4))
                    .frame(width: size * 0.45, height: size * 0.18)
                    .offset(x: size * 0.12)
            }
            .frame(width: size, height: size)
        }
    }
}

// MARK: - Preview

#Preview {
    SignInView()
}
