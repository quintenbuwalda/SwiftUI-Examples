//
//  EditView.swift
//  Snake
//
//  Created by Quinten Buwalda on 8/4/22.
//

import SwiftUI

struct EditView: View {
    @Binding var data: Preference.Data
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("Speed")) {
        //                TextField("Title", text: $data.title)
                        HStack {
                            Image(systemName: "minus")
                            Slider(value: $data.speed, in: 0...40, step: 1)
                                    .accentColor(Color.blue)
                                Image(systemName: "plus")
                            }.foregroundColor(Color.blue)
                    }
                    Section(header: Text("Theme Settings")) {
                        ThemePicker(selection: $data.theme)
                    }
                    Section(header: Text("Danger!").foregroundColor(Color.red).bold()) {
//                        Toggle(isOn: $data.reScore) {
//                            Text("Reset High Score")
//                        }
                        Button(action: {
                            UserDefaults.standard.set(0, forKey: "highScore")
                            print($data.theme)
                        }) {
                            Text("Reset High Score")
                        }
                    }
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(data: .constant(Preference.sampleData[0].data))
    }
}

