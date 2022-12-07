//
//  LogIn.swift
//  EngS
//
//  Created by vi nam on 06/12/2022.
//

import SwiftUI
import RealmSwift
struct EmailLoginView: View {
    
    enum Field: Hashable {
        case username
        case password
    }
    
    @Binding var username: String?

    @State private var email = ""
    @State private var password = ""
    @State private var newUser = false
    @State private var errorMessage = ""
    @State private var inProgress = false
    
    @FocusState private var focussedField: Field?
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Spacer()
                TextField("email address", text: $email)
                    .focused($focussedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit { focussedField = .password }
                SecureField("password", text: $password)
                    .focused($focussedField, equals: .password)
                    .onSubmit(userAction)
                    .submitLabel(.go)
                Button(action: { newUser.toggle() }) {
                    HStack {
                        Image(systemName: newUser ? "checkmark.square" : "square")
                        Text("Register new user")
                        Spacer()
                    }
                }
                Button(action: userAction) {
                    Text(newUser ? "Register new user" : "Log in")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(email == "" || password == "")
                Spacer()
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            if inProgress {
                ProgressView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focussedField = .username
            }
        }
        .padding()
    }
    
    func userAction() {
        errorMessage = ""
        inProgress = true
        Task {
            do {
                if newUser {
                    try await realmApp.emailPasswordAuth.registerUser(email: email, password: password)
                }
                let _ = try await realmApp.login(credentials: .emailPassword(email: email, password: password))
                username = email
                inProgress = false
            } catch {
                errorMessage = error.localizedDescription
                inProgress = false
            }
        }
    }
}
struct LogoutButton: View {
    @Binding var username: String?
    
    @State private var isConfirming = false
    
    var body: some View {
        Button("Logout") { isConfirming = true }
        .confirmationDialog("Are you that you want to logout",
                            isPresented: $isConfirming) {
            Button("Confirm Logout", role: .destructive) { logout() }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private func logout() {
        Task {
            do {
                try await realmApp.currentUser?.logOut()
                username = nil
            } catch {
                print("Failed to logout: \(error.localizedDescription)")
            }
        }
    }
}
//struct LoginView: View {
//    @Binding var username: String?
//
//        var body: some View {
//            ProgressView()
//                .task {
//                    await login()
//                }
//        }
//
//        private func login() async {
//            do {
//                let user = try await realmApp.login(credentials: .anonymous)
//                username = user.id
//            } catch {
//                print("Failed to login: \(error.localizedDescription)")
//            }
//        }
//}
/// Represents the login screen. We will have a button to log in anonymously.
struct LoginView: View {
    // Hold an error if one occurs so we can display it.
    @State var error: Error?
    
    // Keep track of whether login is in progress.
    @State var isLoggingIn = false

    var body: some View {
        VStack {
            if isLoggingIn {
                ProgressView()
            }
            if let error = error {
                Text("Error: \(error.localizedDescription)")
            }
            Button("Log in anonymously") {
                // Button pressed, so log in
                isLoggingIn = true
                Task {
                    do {
                        let user = try await realmApp.login(credentials: .anonymous)
                        // Other views are observing the app and will detect
                        // that the currentUser has changed. Nothing more to do here.
                        print("Logged in as user with id: \(user.id)")
                    } catch {
                        print("Failed to log in: \(error.localizedDescription)")
                        // Set error to observed property so it can be displayed
                        self.error = error
                        return
                    }
                }
            }.disabled(isLoggingIn)
        }
    }
}
struct ErrorView: View {
    var error: Error
        
    var body: some View {
        VStack {
            Text("Error opening the realm: \(error.localizedDescription)")
        }
    }
}
//struct LogIn_Previews: PreviewProvider {
//    static var previews: some View {
//        LogIn()
//    }
//}
