//
//  ForgotPasswordView.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var showForgotPassword: Bool
    @State private var email = ""
    @State private var showSuccessAlert = false
    
    var isValidEmail: Bool {
        let regex = AppConstants.Validation.emailRegex
        return email.range(of: regex, options: .regularExpression) != nil
    }
    
    var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && isValidEmail
    }
    
    var body: some View {
        ZStack {
            ColorConstants.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Button(action: { showForgotPassword = false }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(ColorConstants.textPrimary)
                        }
                        Spacer()
                    }
                    
                    Text("Reset Password")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(ColorConstants.textPrimary)
                    
                    Text("Enter your email to receive a recovery link")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(ColorConstants.textSecondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                // Form Container
                VStack(spacing: 20) {
                    // Email Icon
                    Image(systemName: "envelope.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(ColorConstants.primary)
                    
                    // Description
                    Text("We'll send a password recovery link to your registered email address. Check your inbox and spam folder.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(ColorConstants.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                    
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email Address")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(ColorConstants.textPrimary)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "envelope")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(ColorConstants.primary)
                                .frame(width: 24)
                            
                            TextField("your@email.com", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .foregroundColor(ColorConstants.textPrimary)
                                .tint(ColorConstants.primary)
                        }
                        .padding(12)
                        .background(ColorConstants.surfaceLight)
                        .border(ColorConstants.borderLight, width: 1)
                        .cornerRadius(8)
                    }
                    
                    // Error Message
                    if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.system(size: 14))
                            Text(errorMessage)
                                .font(.system(size: 12, weight: .regular))
                            Spacer()
                        }
                        .foregroundColor(ColorConstants.error)
                        .padding(12)
                        .background(ColorConstants.error.opacity(0.1))
                        .border(ColorConstants.error.opacity(0.3), width: 1)
                        .cornerRadius(8)
                    }
                    
                    // Success Message
                    if let successMessage = viewModel.successMessage, !successMessage.isEmpty {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                            Text(successMessage)
                                .font(.system(size: 12, weight: .regular))
                            Spacer()
                        }
                        .foregroundColor(ColorConstants.success)
                        .padding(12)
                        .background(ColorConstants.success.opacity(0.1))
                        .border(ColorConstants.success.opacity(0.3), width: 1)
                        .cornerRadius(8)
                    }
                    
                    // Send Button
                    Button(action: {
                        handleResetPassword()
                    }) {
                        if viewModel.isLoading {
                            HStack(spacing: 8) {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                                Text("Sending...")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        } else {
                            Text("Send Recovery Link")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(
                        isFormValid && !viewModel.isLoading ?
                        ColorConstants.primary :
                        Color.gray.opacity(0.5)
                    )
                    .cornerRadius(12)
                    .disabled(!isFormValid || viewModel.isLoading)
                }
                .padding(24)
                .background(ColorConstants.surfaceLight)
                .border(ColorConstants.borderLight, width: 1)
                .cornerRadius(16)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Back to Login Link
                HStack(spacing: 4) {
                    Text("Remember your password?")
                        .foregroundColor(ColorConstants.textSecondary)
                    Button(action: { showForgotPassword = false }) {
                        Text("Back to Sign In")
                            .foregroundColor(ColorConstants.primary)
                            .fontWeight(.semibold)
                    }
                }
                .font(.system(size: 14))
                .padding(.bottom, 20)
            }
        }
        .onChange(of: viewModel.successMessage) { oldValue, newValue in
            if newValue != nil && !newValue!.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showForgotPassword = false
                    viewModel.clearMessages()
                }
            }
        }
    }
    
    private func handleResetPassword() {
        let input = ResetPasswordUseCaseInput(
            email: email.trimmingCharacters(in: .whitespaces)
        )
        
        Task {
            await viewModel.resetPassword(input: input)
        }
    }
}

#Preview {
    @State var showForgotPassword = true
    return ForgotPasswordView(
        viewModel: AuthViewModelFactory.makeAuthViewModel(),
        showForgotPassword: $showForgotPassword
    )
    .preferredColorScheme(.dark)
}
