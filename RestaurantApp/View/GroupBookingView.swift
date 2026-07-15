//
//  GroupBookingView.swift
//  RestaurantApp
//
//  Created by MAC on 15/05/2024.
//

import SwiftUI
import Firebase

struct GroupBookingView: View {
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var numberOfPeople = 1
    @State private var setMenu = "Arabic Food"
    @State private var specialArrangements = ""
    @State private var showTimeAlert = false
    @StateObject var viewModel = GroupBookingViewModel()
    var menu = ["Arabic Food", "Chinese Food", "Indian Food", "Italian Food", "Thai Food"]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Group Booking")
                .font(.largeTitle)
                .padding()

            DatePicker("Select Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                .padding()

            DatePicker(selection: $selectedTime, displayedComponents: .hourAndMinute) {
                Text("Select Time")
            }

            Stepper(value: $numberOfPeople, in: 1...100) {
                Text("Number of People: \(numberOfPeople)")
            }
            .padding()

            Picker("selectTable", selection: $setMenu) {
                ForEach(menu, id: \.self) { table in
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

            TextField("Special Arrangements", text: $specialArrangements)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.6))
                }

            Button(action: {
                if checkBookingTime() {
                    saveGroupBooking()
                }
            }) {
                Text("Book Group")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $viewModel.success) {
                Alert(title: Text("Success"), message: Text("booking confirmed"))
            }
            .alert(isPresented: $showTimeAlert) {
                Alert(title: Text("Error"), message: Text("Please select a future booking time"))
            }

            Spacer()
        }
        .padding()
    }

    private func checkBookingTime() -> Bool {
        let calendar = Calendar.current
        let dateParts = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeParts = calendar.dateComponents([.hour, .minute], from: selectedTime)

        var bookingParts = DateComponents()
        bookingParts.year = dateParts.year
        bookingParts.month = dateParts.month
        bookingParts.day = dateParts.day
        bookingParts.hour = timeParts.hour
        bookingParts.minute = timeParts.minute

        guard let bookingDate = calendar.date(from: bookingParts), bookingDate >= Date() else {
            showTimeAlert = true
            return false
        }

        showTimeAlert = false
        return true
    }

    private func saveGroupBooking() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short

        let booking = GroupBookingModel(
            id: UUID().uuidString,
            userId: userId,
            tableId: "Group Table",
            date: dateFormatter.string(from: selectedDate),
            time: timeFormatter.string(from: selectedTime),
            numberOfPeople: numberOfPeople,
            setMenu: setMenu,
            specialArrangement: specialArrangements
        )
        print("Booking Data", booking)

        viewModel.saveData(groupBookingData: booking) { result in
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
    GroupBookingView()
}
