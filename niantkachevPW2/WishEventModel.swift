//
//  WishEventModel.swift
//  niantkachevPW2
//
//  Created by Николай Ткачев on 25/11/2025.
//

import Foundation

struct WishEventModel: Codable {
    let id: String
    let title: String
    let description: String
    let startDate: Date
    let endDate: Date
    let wishTitle: String?
    
    init(id: String = UUID().uuidString, title: String, description: String, startDate: Date, endDate: Date, wishTitle: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.wishTitle = wishTitle
    }
    
    var startDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: startDate)
    }
    
    var endDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: endDate)
    }
}

