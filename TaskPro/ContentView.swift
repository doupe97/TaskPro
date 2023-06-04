//
//  ContentView.swift
//  TaskPro
//
//  Created by Nico Müller on 04.06.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Meine Aufgaben")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
