//
//  AuthenticationViewModel.swift
//  RestaurantApp
//
//  Created by MAC on 15/05/2024.
//

import SwiftUI
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    let auth = Auth.auth()
    @Published var signedIn = false
    @Published var signup = false
    @Published var showError = false
    @Published var errorMessage = ""

    var isSignedIn: Bool {
        return auth.currentUser != nil
    }

    func SignIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
                return
            }

            guard result != nil else {
                return
            }

            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }

    func SignUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] (result, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
                return
            }

            guard result != nil else {
                return
            }

            // Firebase signs the user in after the account is created.
            DispatchQueue.main.async {
                self?.signedIn = true
                self?.signup = true
            }
        }
    }

    func SignOut() {
        do {
            try auth.signOut()
            signedIn = false
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
