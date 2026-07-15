//
//  EventBookingViewModel.swift
//  RestaurantApp
//
//  Created by MAC on 17/05/2024.
//

import Foundation
import Firebase

class EventBookingViewModel: ObservableObject {
    @Published var eventBooing: [EventBookingModel] = []
    @Published var errorMessage: String? = nil
    @Published var success = false
    let db = Firestore.firestore()

    func saveData(eventData: EventBookingModel, completion: @escaping (Result<Void, Error>) -> Void) {

        let eventDict: [String: Any] = [
            "id": eventData.id ,
            "userId": eventData.userId,
            "eventName": eventData.eventName,
            "numberOfTickets": eventData.numberOfTickets,
            "specialRequest": eventData.specialRequest
        ]

        db.collection("eventBooking").document(eventData.id).setData(eventDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                DispatchQueue.main.async {
                    self.success = true
                }
                completion(.success(()))
            }
        }
    }

    func fetchEvents(for userId: String) {
            db.collection("eventBooking").whereField("userId", isEqualTo: userId)
                .addSnapshotListener { (querySnapshot, error) in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }

                    guard let documents = querySnapshot?.documents else {
                        return
                    }

                    self.eventBooing = documents.map({ queryDocumentSnapshot -> EventBookingModel in
                        let data = queryDocumentSnapshot.data()

                        let id = data["id"] as? String ?? queryDocumentSnapshot.documentID
                        let bookingUserId = data["userId"] as? String ?? userId
                        let eventName = data["eventName"] as? String ?? ""
                        let numberOfTickets = data["numberOfTickets"] as? Int ?? 0
                        let specialRequest = data["specialRequest"] as? String ?? ""

                        return EventBookingModel(id: id, userId: bookingUserId, eventName: eventName, numberOfTickets: numberOfTickets, specialRequest: specialRequest)
                    })
                }
        }

    func deleteReservation(reservationId: String, completion: @escaping (Result<Void, Error>) -> Void) {
            db.collection("eventBooking").document(reservationId).delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
}
