import SwiftUI

public struct AuthView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authManager = AuthManager.shared

    @State private var isRegistering: Bool = false
    @State private var email: String = "alex.mercer@novatelecom.io"
    @State private var password: String = "Password123!"
    @State private var fullName: String = "Alex Mercer"
    @State private var phoneNumber: String = "+1 (555) 392-8821"
    @State private var isPasswordVisible: Bool = false

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Logo / Header
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(TelecomColors.heroGradient)
                                    .frame(width: 72, height: 72)
                                Image(systemName: "antenna.radiowaves.left.and.right")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            Text("NOVA TELECOM")
                                .font(TelecomTypography.titleLarge)
                                .foregroundColor(.white)

                            Text(isRegistering ? "Create your unified telecom account" : "Sign in to manage fiber, mobile & DTH")
                                .font(TelecomTypography.bodyMedium)
                                .foregroundColor(TelecomColors.neutralMuted)
                        }
                        .padding(.top, 20)

                        // Error Banner
                        if let err = authManager.errorMessage {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(TelecomColors.dangerRed)
                                Text(err)
                                    .font(TelecomTypography.captionMedium)
                                    .foregroundColor(.white)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(TelecomColors.dangerRed.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        // Form Fields Card
                        GlassCard(cornerRadius: 22, padding: 18) {
                            VStack(spacing: 14) {
                                if isRegistering {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("FULL NAME")
                                            .font(TelecomTypography.badge)
                                            .foregroundColor(TelecomColors.neutralMuted)
                                        TextField("Full Name", text: $fullName)
                                            .padding(12)
                                            .background(Color.white.opacity(0.08))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .foregroundColor(.white)
                                    }

                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("PHONE NUMBER")
                                            .font(TelecomTypography.badge)
                                            .foregroundColor(TelecomColors.neutralMuted)
                                        TextField("Phone Number", text: $phoneNumber)
                                            .keyboardType(.phonePad)
                                            .padding(12)
                                            .background(Color.white.opacity(0.08))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .foregroundColor(.white)
                                    }
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("EMAIL ADDRESS")
                                        .font(TelecomTypography.badge)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                    TextField("Email Address", text: $email)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .padding(12)
                                        .background(Color.white.opacity(0.08))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .foregroundColor(.white)
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("PASSWORD")
                                        .font(TelecomTypography.badge)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                    HStack {
                                        if isPasswordVisible {
                                            TextField("Password", text: $password)
                                        } else {
                                            SecureField("Password", text: $password)
                                        }
                                        Button(action: { isPasswordVisible.toggle() }) {
                                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                                .foregroundColor(TelecomColors.neutralMuted)
                                        }
                                    }
                                    .padding(12)
                                    .background(Color.white.opacity(0.08))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .foregroundColor(.white)
                                }

                                TelecomButton(
                                    title: isRegistering ? "Create Account" : "Sign In",
                                    icon: "arrow.right",
                                    style: .primary,
                                    isLoading: authManager.isLoading,
                                    action: handleAuth
                                )
                            }
                        }

                        // Toggle Register / Sign In
                        Button(action: {
                            HapticFeedback.light()
                            withAnimation { isRegistering.toggle() }
                        }) {
                            Text(isRegistering ? "Already have an account? Sign In" : "New to Nova? Create an account")
                                .font(TelecomTypography.bodyMedium)
                                .foregroundColor(TelecomColors.neonCyan)
                        }
                    }
                    .padding(16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }
        }
    }

    private func handleAuth() {
        Task {
            let success: Bool
            if isRegistering {
                success = await authManager.register(fullName: fullName, email: email, phone: phoneNumber, password: password)
            } else {
                success = await authManager.signIn(email: email, password: password)
            }
            if success {
                HapticFeedback.success()
                dismiss()
            }
        }
    }
}
