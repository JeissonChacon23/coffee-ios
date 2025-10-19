//
//  SignUpView.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var showSignUp: Bool
    @State private var name = ""
    @State private var lastName = ""
    @State private var idCard = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var state = ""
    @State private var city = ""
    @State private var zipCode = ""
    @State private var address = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var bornDate = Date()
    @State private var showSuccessAlert = false
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.isValidEmail &&
        !password.isEmpty &&
        password.count >= AppConstants.Validation.minPasswordLength &&
        password == confirmPassword &&
        !phone.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        ZStack {
            ColorConstants.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Button(action: { showSignUp = false }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                                .foregroundColor(ColorConstants.textPrimary)
                            }
                            Spacer()
                        }
                        
                        Text("Create Account")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(ColorConstants.textPrimary)
                        
                        Text("Join Town's Coffee community")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(ColorConstants.textSecondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Form Container
                    VStack(spacing: 16) {
                        // Section: Account Information
                        FormSectionHeader(title: "Account Information")
                        
                        FormTextField(
                            icon: "envelope",
                            placeholder: "your@email.com",
                            text: $email,
                            keyboardType: .emailAddress
                        )
                        
                        FormTextField(
                            icon: "lock",
                            placeholder: "Password",
                            text: $password,
                            isSecure: true
                        )
                        
                        FormTextField(
                            icon: "lock.fill",
                            placeholder: "Confirm Password",
                            text: $confirmPassword,
                            isSecure: true
                        )
                        
                        // Section: Personal Information
                        FormSectionHeader(title: "Personal Information")
                        
                        FormTextField(
                            icon: "person",
                            placeholder: "First Name",
                            text: $name
                        )
                        
                        FormTextField(
                            icon: "person",
                            placeholder: "Last Name",
                            text: $lastName
                        )
                        
                        FormTextField(
                            icon: "id.card",
                            placeholder: "ID Card",
                            text: $idCard,
                            keyboardType: .numberPad
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Birth Date")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(ColorConstants.textPrimary)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(ColorConstants.primary)
                                    .frame(width: 24)
                                
                                DatePicker(
                                    "",
                                    selection: $bornDate,
                                    displayedComponents: .date
                                )
                                .foregroundColor(ColorConstants.textPrimary)
                                .tint(ColorConstants.primary)
                            }
                            .padding(12)
                            .background(ColorConstants.surfaceLight)
                            .border(ColorConstants.borderLight, width: 1)
                            .cornerRadius(8)
                        }
                        
                        // Section: Contact
                        FormSectionHeader(title: "Contact")
                        
                        FormTextField(
                            icon: "phone",
                            placeholder: "Phone",
                            text: $phone,
                            keyboardType: .phonePad
                        )
                        
                        // Section: Location
                        FormSectionHeader(title: "Location")
                        
                        FormTextField(
                            icon: "map",
                            placeholder: "State",
                            text: $state
                        )
                        
                        FormTextField(
                            icon: "building.2",
                            placeholder: "City",
                            text: $city
                        )
                        
                        FormTextField(
                            icon: "mappin",
                            placeholder: "Zip Code",
                            text: $zipCode,
                            keyboardType: .numberPad
                        )
                        
                        FormTextField(
                            icon: "house",
                            placeholder: "Address",
                            text: $address
                        )
                        
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
                        
                        // Sign Up Button
                        Button(action: {
                            handleSignUp()
                        }) {
                            if viewModel.isLoading {
                                HStack(spacing: 8) {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                    Text("Creating Account...")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            } else {
                                Text("Create Account")
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
                        .padding(.top, 8)
                        
                        // Sign In Link
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .foregroundColor(ColorConstants.textSecondary)
                            Button(action: { showSignUp = false }) {
                                Text("Sign In")
                                    .foregroundColor(ColorConstants.primary)
                                    .fontWeight(.semibold)
                            }
                        }
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 12)
                    }
                    .padding(24)
                    .background(ColorConstants.surfaceLight)
                    .border(ColorConstants.borderLight, width: 1)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .onChange(of: viewModel.isAuthenticated) { oldValue, newValue in
            if newValue {
                showSignUp = false
            }
        }
    }
    
    private func handleSignUp() {
        let input = SignUpUseCaseInput(
            email: email.trimmingCharacters(in: .whitespaces),
            password: password,
            name: name.trimmingCharacters(in: .whitespaces),
            lastName: lastName.trimmingCharacters(in: .whitespaces),
            idCard: idCard.trimmingCharacters(in: .whitespaces),
            phone: phone.trimmingCharacters(in: .whitespaces),
            state: state.trimmingCharacters(in: .whitespaces),
            city: city.trimmingCharacters(in: .whitespaces),
            zipCode: zipCode.trimmingCharacters(in: .whitespaces),
            address: address.trimmingCharacters(in: .whitespaces),
            bornDate: bornDate
        )
        
        Task {
            await viewModel.signUp(input: input)
        }
    }
}

// MARK: - Custom Components
struct FormTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(ColorConstants.primary)
                .frame(width: 24)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .foregroundColor(ColorConstants.textPrimary)
            } else {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .keyboardType(keyboardType)
                    .foregroundColor(ColorConstants.textPrimary)
            }
        }
        .padding(12)
        .background(ColorConstants.surfaceLight)
        .border(ColorConstants.borderLight, width: 1)
        .cornerRadius(8)
        .tint(ColorConstants.primary)
    }
}

struct FormSectionHeader: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(ColorConstants.primary)
            
            Divider()
                .background(ColorConstants.borderLight)
        }
        .padding(.top, 8)
    }
}

#Preview {
    @State var showSignUp = true
    return SignUpView(
        viewModel: AuthViewModelFactory.makeAuthViewModel(),
        showSignUp: $showSignUp
    )
    .preferredColorScheme(.dark)
}
