//
//  ReservationView.swift
//  RestaurantApp
//
//  Created by MAC on 15/05/2024.
//

import SwiftUI
import FirebaseAuth

struct ReservationView: View {
    @State var selectedDate = Date()
    @State var selectedTime = Date()
    @State var numberOfPeople: Int = 1
    @State var specialRequests = ""
    @State var selectedTable = "Smoking Area"
    @ObservedObject private var viewModel = ReservationViewModel()
    var table = ["Smoking Area", "Quiet Corner", "VIP", "Window View", "Near Kitchen"]
    @State var showTimeAlert = false
    @State var showNumberAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Reservation")
                .font(.largeTitle)
                .padding()

            DatePicker("Select Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)

            DatePicker(selection: $selectedTime, displayedComponents: .hourAndMinute) {
                Text("Select Time")
            }

            TextField("Number of People", value: $numberOfPeople, formatter: NumberFormatter())
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.6))
                }



        Picker("selectTable", selection: $selectedTable) {
            ForEach(table, id: \.self) { table in
                Text(table)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .tint(Color.black)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.6))
        }

//            Picker("Select Table", selection: $selectedTable) {
//                Text("Window Views")
//                Text("Quite Corner")
//                Text("Near the Kitchen")
//                    .padding()
//            }
//            .tint(Color.black)
//            .padding(.horizontal)
//            .padding(.vertical, 10)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .overlay {
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.gray.opacity(0.6))
//            }

            TextField("Special Request", text: $specialRequests)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.6))
                }

            Button {
                if checkTimeValidity() && checkNumberOfPeople() {
                    saveReservation()
                }
            } label: {
                Text("Book Now")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $viewModel.success) {
                Alert(title: Text("Success"), message: Text("reservation confirmed"))
            }
            .alert(isPresented: $showTimeAlert) {
                Alert(title: Text("Error"), message: Text("Please select a future time between 10am and 11pm"))
            }
            .alert(isPresented: $showNumberAlert) {
                            Alert(title: Text("Error"), message: Text("Number of people must be greater than 0"), dismissButton: .default(Text("OK")))
                        }

            Spacer()
        }
        .padding()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func checkTimeValidity() -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: selectedTime)
        guard let hour = components.hour else { return false }

        if hour < 10 || hour > 23 { // Outside 10am to 11pm range
            showTimeAlert = true
            return false
        }

        let dateParts = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeParts = calendar.dateComponents([.hour, .minute], from: selectedTime)
        var bookingParts = DateComponents()
        bookingParts.year = dateParts.year
        bookingParts.month = dateParts.month
        bookingParts.day = dateParts.day
        bookingParts.hour = timeParts.hour
        bookingParts.minute = timeParts.minute

        if let bookingDate = calendar.date(from: bookingParts), bookingDate < Date() {
            showTimeAlert = true
            return false
        }

        showTimeAlert = false
        return true
    }

    private func checkNumberOfPeople() -> Bool {
        if numberOfPeople <= 0 {
            showNumberAlert = true
            return false
        } else {
            showNumberAlert = false
            return true
        }
    }

    private func saveReservation() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let reservation = ReservationModel(
            id: UUID().uuidString,
            userId: userId,
            tableId: selectedTable,
            date: formattedDate(selectedDate),
            time: formattedTime(selectedTime),
            numberOfPeople: numberOfPeople,
            specialRequests: specialRequests
        )
        print("data", reservation)

        viewModel.saveData(reservationData: reservation) { result in
            switch result {
            case .success():
                print("Reservation saved successfully")
            case .failure(let error):
                print("Error saving reservation: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ReservationView()
}
