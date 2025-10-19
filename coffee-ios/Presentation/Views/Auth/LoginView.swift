//
//  LoginView.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    @State private var showForgotPassword = false
    
    var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty &&
        email.isValidEmail
    }
    
    var body: some View {
        ZStack {
            ColorConstants.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Town's Coffee")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(ColorConstants.textPrimary)
                        
                        Text("Welcome Back")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(ColorConstants.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Form Container
                    VStack(spacing: 20) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
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
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(ColorConstants.textPrimary)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(ColorConstants.primary)
                                    .frame(width: 24)
                                
                                SecureField("••••••••", text: $password)
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
                        
                        // Login Button
                        Button(action: {
                            handleSignIn()
                        }) {
                            if viewModel.isLoading {
                                HStack(spacing: 8) {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                    Text("Signing in...")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            } else {
                                Text("Sign In")
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
                        
                        // Forgot Password Link
                        Button(action: {
                            showForgotPassword = true
                        }) {
                            Text("Forgot Password?")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(ColorConstants.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(24)
                    .background(ColorConstants.surfaceLight)
                    .border(ColorConstants.borderLight, width: 1)
                    .cornerRadius(16)
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Sign Up Link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(ColorConstants.textSecondary)
                        Button(action: {
                            showSignUp = true
                        }) {
                            Text("Sign Up")
                                .foregroundColor(ColorConstants.primary)
                                .fontWeight(.semibold)
                        }
                    }
                    .font(.system(size: 14))
                    .padding(.bottom, 20)
                }
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView(viewModel: viewModel, showSignUp: $showSignUp)
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView(viewModel: viewModel, showForgotPassword: $showForgotPassword)
            }
        }
    }
    
    private func handleSignIn() {
        let input = SignInUseCaseInput(
            email: email.trimmingCharacters(in: .whitespaces),
            password: password
        )
        
        Task {
            await viewModel.signIn(input: input)
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModelFactory.makeAuthViewModel())
        .preferredColorScheme(.dark)
}
