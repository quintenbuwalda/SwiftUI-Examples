//
//  Themes.swift
//  Snake
//
//  Created by Quinten Buwalda on 8/4/22.
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable, Codable {
    case mint
    case indigo
    case green
    case pink
    case yellow
    
    var accentColor: Color {
        return .black
    }
    
    var mainColor: Color {
        switch self {
        case .mint: return .mint
        case .indigo: return .indigo
        case .green: return .green
        case .pink: return .pink
        case .yellow: return .yellow
        }
//        Color(rawValue)
//        Color(.orange)
    }
    var name: String {
        rawValue.capitalized
    }
    var colorArray: [Color] {
        switch self {
        case .mint: return [.blue, .mint]
        case .indigo: return [.cyan, .indigo]
        case .green: return [.brown, .green]
        case .pink: return [.pink, .pink]
        case .yellow: return [.orange, .yellow]
        }
    }
    
    var id: String {
        name
    }
}
