//
//  ContentView.swift
//  RestaurantApp
//
//  Created by MAC on 13/05/2024.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                VStack {
                    MainView()
                    
                    Button(action: {
                        viewModel.SignOut()
                    }, label: {
                        Text("Sign Out")
                            .foregroundColor(.blue)
                    })
                }
                
            } else {
                SignInView()
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}

#Preview {
    ContentView()
}
