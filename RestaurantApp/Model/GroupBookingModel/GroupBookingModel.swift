//
//  GroupBookingModel.swift
//  RestaurantApp
//
//  Created by MAC on 16/05/2024.
//

import SwiftUI

struct GroupBookingModel: Codable {
    let id: String
    let userId: String
    let tableId: String
    let date: String
    let time: String
    let numberOfPeople: Int
    let setMenu: String
    let specialArrangement: String?
}
