//
//  EventBookingView.swift
//  RestaurantApp
//
//  Created by MAC on 15/05/2024.
//

import SwiftUI
import Firebase

struct EventBookingView: View {
    @State private var selectedEvent = "Tasting Menu Night"
    @State private var numberOfTickets = 1
    @State private var specialRequests = ""
    @ObservedObject var eventBookingVM = EventBookingViewModel()

    var events = ["Tasting Menu Night", "Cultural Celebration", "Wine Pairing Dinner"]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Event Booking")
                .font(.largeTitle)
                .padding()

            TextField("Event Name", text: $selectedEvent)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Stepper(value: $numberOfTickets, in: 1...50) {
                Text("Number of Tickets: \(numberOfTickets)")
            }
            .padding()

            TextField("Special Requests", text: $specialRequests)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                saveEventBooking()
            }) {
                Text("Book Event")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $eventBookingVM.success) {
                Alert(title: Text("Success"), message: Text("booking confirmed"))
            }

            Spacer()
        }
        .padding()
    }

    private func saveEventBooking() {
        let cleanEventName = selectedEvent.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanEventName.isEmpty, let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let booking = EventBookingModel(id: UUID().uuidString, userId: userId, eventName: cleanEventName, numberOfTickets: numberOfTickets, specialRequest: specialRequests)
        print("Booking Data", booking)

        eventBookingVM.saveData(eventData: booking) { result in
            switch result {
            case .success():
                print("booking saved successfully")
            case .failure(let error):
                print("Error saving bookings: \(error.localizedDescription)")
            }
        }
    }
}


#Preview {
    EventBookingView()
}
