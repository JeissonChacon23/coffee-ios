//
//  StubViews.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import SwiftUI
import Combine

/*
 // MARK: - Vistas Temporales (Las reemplazaremos próximamente)

 struct LoginView: View {
     var body: some View {
         ZStack {
             ColorConstants.backgroundGradient
                 .ignoresSafeArea()
             
             VStack {
                 Text("Próximamente: Login")
                     .foregroundColor(ColorConstants.textPrimary)
             }
         }
     }
 }

 struct SignUpView: View {
     @Binding var showSignUp: Bool
     var authCompleted: (() -> Void)?
     
     var body: some View {
         ZStack {
             ColorConstants.backgroundGradient
                 .ignoresSafeArea()
             
             VStack {
                 Text("Próximamente: SignUp")
                     .foregroundColor(ColorConstants.textPrimary)
             }
         }
     }
 }

 struct ForgotPasswordView: View {
     @Binding var showForgotPassword: Bool
     
     var body: some View {
         ZStack {
             ColorConstants.backgroundGradient
                 .ignoresSafeArea()
             
             VStack {
                 Text("Próximamente: ForgotPassword")
                     .foregroundColor(ColorConstants.textPrimary)
             }
         }
     }
 }
 */

struct MuniciposListView: View {
    var body: some View {
        ZStack {
            ColorConstants.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                Text("Próximamente: Municipios")
                    .foregroundColor(ColorConstants.textPrimary)
            }
        }
    }
}

struct SearchView: View {
    var body: some View {
        ZStack {
            ColorConstants.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                Text("Próximamente: Búsqueda")
                    .foregroundColor(ColorConstants.textPrimary)
            }
        }
    }
}

struct FavoritesView: View {
    var body: some View {
        ZStack {
            ColorConstants.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                Text("Próximamente: Favoritos")
                    .foregroundColor(ColorConstants.textPrimary)
            }
        }
    }
}

struct ProfileView: View {
    var coordinator: AppCoordinator?
    
    var body: some View {
        ZStack {
            ColorConstants.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                Text("Próximamente: Perfil")
                    .foregroundColor(ColorConstants.textPrimary)
            }
        }
    }
}

// MARK: - Modelos Temporales
struct UserModel: Codable {
    let uid: String
    let correo: String
}

struct MunicipioModel: Identifiable, Codable {
    let id: String
    let nombre: String
}

// MARK: - AuthManager Temporal
@MainActor
class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: UserModel?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
    }
}

// MARK: - AppCoordinator Temporal
@MainActor
class AppCoordinator: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: UserModel?
    
    func logout() {
        isAuthenticated = false
        currentUser = nil
    }
}
