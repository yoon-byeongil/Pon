//
//  PonApp.swift
//  Pon
//
//  Created by 윤병일 on 2026/06/15.
//

import SwiftUI
import SwiftData

@main
struct PonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Todo.self)
    }
}
