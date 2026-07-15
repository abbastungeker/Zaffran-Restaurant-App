//
//  SignUpView.swift
//  RestaurantApp
//
//  Created by MAC on 15/05/2024.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""

    var body: some View {
        VStack(spacing: 14) {
            TextField("Email Address", text: $email)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color.white)
                .shadow(radius: 5)

            SecureField("Password", text: $password)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color.white)
                .shadow(radius: 5)

            SecureField("Confirm Password", text: $confirmPassword)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color.white)
                .shadow(radius: 5)

            Button(action: {
                let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

                guard !cleanEmail.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
                    viewModel.errorMessage = "Please complete all fields"
                    viewModel.showError = true
                    return
                }

                guard password == confirmPassword else {
                    viewModel.errorMessage = "Passwords do not match"
                    viewModel.showError = true
                    return
                }

                guard password.count >= 6 else {
                    viewModel.errorMessage = "Password must contain at least 6 characters"
                    viewModel.showError = true
                    return
                }

                viewModel.SignUp(email: cleanEmail, password: password)
            }, label: {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            .padding()
        }
        .padding()
        .navigationTitle("Create Account")
        .alert("Unable to Create Account", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthenticationViewModel())
}
