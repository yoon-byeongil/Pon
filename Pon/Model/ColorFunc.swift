//
//  ColorFunc.swift
//  Pon
//
//  Created by 윤병일 on 2026/06/29.
//

import SwiftUI

func colorToString(_ color: Color) -> String {
    switch color {
    case .red: return "red"
    case .orange: return "orange"
    case .yellow: return "yellow"
    case .green: return "green"
    case .mint: return "mint"
    case .teal: return "teal"
    case .blue: return "blue"
    case .indigo: return "indigo"
    case .purple: return "purple"
    case .pink: return "pink"
    case .brown: return "brown"
    case .gray: return "gray"
    default: return "blue"
    }
}

func stringToColor(_ name: String) -> Color {
    switch name {
    case "red": return .red
    case "orange": return .orange
    case "yellow": return .yellow
    case "green": return .green
    case "mint": return .mint
    case "teal": return .teal
    case "blue": return .blue
    case "indigo": return .indigo
    case "purple": return .purple
    case "pink": return .pink
    case "brown": return .brown
    case "gray": return .gray
    default: return .blue
    }
}
