//
//  LoginVIew.swift
//  RestaurantApp
//
//  Created by MAC on 15/05/2024.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var email = ""
    @State var password = ""

    var body: some View {
        VStack {
            TextField("Email Address", text: $email)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color.white)
                .shadow(radius: 5)
                .padding(.bottom)

            SecureField("Password", text: $password)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color.white)
                .shadow(radius: 5)

            Button(action: {
                let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

                guard !cleanEmail.isEmpty, !password.isEmpty else {
                    viewModel.errorMessage = "Please enter an email address and password"
                    viewModel.showError = true
                    return
                }

                viewModel.SignIn(email: cleanEmail, password: password)
            }, label: {
                Text("Sign In")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            .padding()

            NavigationLink("Create Account", destination: SignUpView())
                .padding()
        }
        .padding()
        .navigationTitle("Sign In")
        .alert("Unable to Sign In", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthenticationViewModel())
}
