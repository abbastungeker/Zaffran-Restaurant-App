//
//  GroupBookingViewModel.swift
//  RestaurantApp
//
//  Created by MAC on 17/05/2024.
//

import Foundation
import Firebase

class GroupBookingViewModel: ObservableObject {
    @Published var groupBooking: [GroupBookingModel] = []
    @Published var errorMessage: String? = nil
    @Published var success = false
    let db = Firestore.firestore()

    func saveData(groupBookingData: GroupBookingModel, completion: @escaping (Result<Void, Error>) -> Void) {

        let groupBookingDict: [String: Any] = [
            "id": groupBookingData.id ,
            "userId": groupBookingData.userId,
            "tableId": groupBookingData.tableId,
            "date": groupBookingData.date,
            "time": groupBookingData.time,
            "numberOfPeople": groupBookingData.numberOfPeople,
            "setMenu": groupBookingData.setMenu,
            "specialArrangement": groupBookingData.specialArrangement ?? ""
        ]

        db.collection("groupBookings").document(groupBookingData.id).setData(groupBookingDict) { error in
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

    func fetchGroupBookings(for userId: String) {
            db.collection("groupBookings").whereField("userId", isEqualTo: userId)
                .addSnapshotListener { (querySnapshot, error) in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }

                    guard let documents = querySnapshot?.documents else {
                        return
                    }

                    self.groupBooking = documents.map({ queryDocumentSnapshot -> GroupBookingModel in
                        let data = queryDocumentSnapshot.data()

                        let id = data["id"] as? String ?? queryDocumentSnapshot.documentID
                        let bookingUserId = data["userId"] as? String ?? userId
                        let tableId = data["tableId"] as? String ?? ""
                        let date = data["date"] as? String ?? ""
                        let time = data["time"] as? String ?? ""
                        let numberOfPeople = data["numberOfPeople"] as? Int ?? 0
                        let setMenu = data["setMenu"] as? String ?? ""
                        let specialArrangements = data["specialArrangement"] as? String ?? ""

                        return GroupBookingModel(id: id, userId: bookingUserId, tableId: tableId, date: date, time: time, numberOfPeople: numberOfPeople, setMenu: setMenu, specialArrangement: specialArrangements)
                    })
                }
        }

    func deleteReservation(reservationId: String, completion: @escaping (Result<Void, Error>) -> Void) {
            db.collection("groupBookings").document(reservationId).delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
}
