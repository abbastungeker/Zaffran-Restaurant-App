//
//  RestaurantAppApp.swift
//  RestaurantApp
//
//  Created by MAC on 13/05/2024.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct RestaurantAppApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
        let viewModel = AuthenticationViewModel()
      NavigationStack {
        ContentView()
              .environmentObject(viewModel)
      }
    }
  }
}
