//
//  ReservationViewModel.swift
//  RestaurantApp
//
//  Created by MAC on 16/05/2024.
//

import Foundation
import Firebase

class ReservationViewModel: ObservableObject {
    @Published var reservations: [ReservationModel] = []
    @Published var errorMessage: String? = nil
    @Published var success = false
    let db = Firestore.firestore()

    func saveData(reservationData: ReservationModel, completion: @escaping (Result<Void, Error>) -> Void) {

        let reservationDict: [String: Any] = [
            "id": reservationData.id ?? "",
            "userId": reservationData.userId,
            "tableId": reservationData.tableId,
            "date": reservationData.date,
            "time": reservationData.time,
            "numberOfPeople": reservationData.numberOfPeople,
            "specialRequests": reservationData.specialRequests ?? ""
        ]

        db.collection("reservations").document(reservationData.id ?? "").setData(reservationDict) { error in
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

    func fetchReservations(for userId: String) {
        db.collection("reservations").whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    return
                }

                self.reservations = documents.map({ queryDocumentSnapshot -> ReservationModel in
                    let data = queryDocumentSnapshot.data()

                    let id = data["id"] as? String ?? queryDocumentSnapshot.documentID
                    let reservationUserId = data["userId"] as? String ?? userId
                    let date = data["date"] as? String ?? ""
                    let time = data["time"] as? String ?? ""
                    let tableId = data["tableId"] as? String ?? ""
                    let numberOfPeople = data["numberOfPeople"] as? Int ?? 0
                    let specialRequests = data["specialRequests"] as? String ?? ""

                    return ReservationModel(id: id, userId: reservationUserId, tableId: tableId, date: date, time: time, numberOfPeople: numberOfPeople, specialRequests: specialRequests)
                })
            }
    }

    func deleteReservation(reservationId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("reservations").document(reservationId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
