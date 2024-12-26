//
//  User.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/11/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var userName: String
    var phoneNumber: String
    var email: String
    var password: String
    var createdAt: Date
    var updatedAt: Date
}
