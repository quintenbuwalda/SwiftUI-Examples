//
//  SnakeApp.swift
//  Snake
//
//  Created by Quinten Buwalda on 7/4/22.
//

import SwiftUI

@main
struct SnakeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(preference: .constant(Preference.sampleData[0]))
        }
    }
}
