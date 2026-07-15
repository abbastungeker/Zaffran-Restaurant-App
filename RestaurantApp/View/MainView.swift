//
//  MainView.swift
//  RestaurantApp
//
//  Created by MAC on 15/05/2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ReservationView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Reservation")
                }
            
            GroupBookingView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Group Booking")
                }
            
            EventBookingView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Event Booking")
                }
            
            MyBookings()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("My Bookings")
                }
        }
    }
}

#Preview {
    MainView()
}
