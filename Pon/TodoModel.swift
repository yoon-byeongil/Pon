//
//  TodoModel.swift
//  Pon
//
//  Created by 윤병일 on 2026/06/16.
//

import Foundation
import SwiftData

@Model
class Todo: Identifiable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}
