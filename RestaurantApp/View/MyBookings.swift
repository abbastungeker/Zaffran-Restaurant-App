//
//  MyBookings.swift
//  RestaurantApp
//
//  Created by MAC on 17/05/2024.
//

import SwiftUI
import FirebaseAuth

struct MyBookings: View {
    @ObservedObject private var viewModel = ReservationViewModel()
    @ObservedObject private var groupBookingVM = GroupBookingViewModel()
    @ObservedObject private var eventBookingVM = EventBookingViewModel()

    var body: some View {
        VStack(alignment: .leading) {
                List {

                    Text("My Reservations")
                        .font(.title2)
                    ForEach(viewModel.reservations, id: \.id) { reservation in
                        VStack(alignment: .leading) {
                            Text("Date: \(reservation.date)")
                            Text("Time: \(reservation.time)")
                            Text("People: \(reservation.numberOfPeople)")
                            Text("Table: \(reservation.tableId)")
                            if let specialRequests = reservation.specialRequests, !specialRequests.isEmpty {
                                Text("Requests: \(specialRequests)")
                            }
                        }
                        .padding()
                    }

                    Text("Group Bookings")
                        .font(.title2)
                    ForEach(groupBookingVM.groupBooking, id: \.id) { data in
                        VStack(alignment: .leading) {
                            Text("Date: \(data.date)")
                            Text("Time: \(data.time)")
                            Text("number of people: \(data.numberOfPeople)")
                            Text("menu: \(data.setMenu)")
                            Text("special arrangments: \(data.specialArrangement ?? "")")
                        }
                    }

                    Text("Event Bookings")
                        .font(.title2)
                    ForEach(eventBookingVM.eventBooing, id: \.id) { event in
                        VStack(alignment: .leading) {
                            Text("event name: \(event.eventName)")
                            Text("number of people: \(event.numberOfTickets)")
                            Text("special arrangements: \(event.specialRequest)")
                        }
                        .foregroundStyle(.black)
                    }
                }
        }
        .onAppear {
            if let userId = Auth.auth().currentUser?.uid {
                viewModel.fetchReservations(for: userId)
                groupBookingVM.fetchGroupBookings(for: userId)
                eventBookingVM.fetchEvents(for: userId)
            }
        }
    }
}

#Preview {
    MyBookings()
}
