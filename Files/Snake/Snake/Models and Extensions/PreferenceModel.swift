//
//  PreferenceModel.swift
//  Snake
//
//  Created by Quinten Buwalda on 8/4/22.
//

import Foundation

struct Preference: Codable {
    var theme: Theme
    var speed: Double
    
    init(theme: Theme, speed: Double) {
        self.theme = theme
        self.speed = speed
    }
}

extension Preference {

    struct Data {
        var theme: Theme = .mint
        var speed: Double = 20
    }

    var data: Data {
        Data(theme: theme, speed: speed)
    }

    mutating func update(from data: Data) {
        theme = data.theme
        speed = data.speed
    }

    init(data: Data) {
        theme = data.theme
        speed = data.speed
    }
}
//
extension Preference {
    static let sampleData: [Preference] =
    [
        Preference(theme: .indigo, speed: 20),
    ]
}
