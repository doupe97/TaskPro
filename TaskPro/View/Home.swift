//
//  Home.swift
//  TaskPro
//
//  Created by Nico Müller on 04.06.23.
//

import SwiftUI

struct Home: View {
    
    @Environment(\.self) private var env
    @State private var filterDate: Date = .init()
    @State private var showPendingTasks: Bool = true
    @State private var showCompletedTasks: Bool = true
    
    var body: some View {
        List {
            DatePicker(
                selection: $filterDate,
                displayedComponents: [.date]) { }
                .labelsHidden()
                .datePickerStyle(.graphical)
            
            CustomFilteringDataView(filterDate: $filterDate) { pendingTasks, completedTasks in
                DisclosureGroup(isExpanded: $showPendingTasks) {
                    if pendingTasks.isEmpty {
                        Text("Keine Aufgaben vorhanden...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(pendingTasks) {
                            TaskRow(task: $0, isPending: true)
                        }
                    }
                } label: {
                    Text("Offene Aufgaben \(pendingTasks.isEmpty ? "" : "(\(pendingTasks.count))")")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                DisclosureGroup(isExpanded: $showCompletedTasks) {
                    if completedTasks.isEmpty {
                        Text("Keine Aufgaben vorhanden...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(completedTasks) {
                            TaskRow(task: $0, isPending: false)
                        }
                    }
                } label: {
                    Text("Abgeschlossene Aufgaben \(completedTasks.isEmpty ? "" : "(\(completedTasks.count))")")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    do {
                        let task = Task(context: env.managedObjectContext)
                        task.id = .init()
                        task.date = filterDate
                        task.title = ""
                        task.isCompleted = false
                        
                        try env.managedObjectContext.save()
                        showPendingTasks = true
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        
                        Text("Neue Aufgabe")
                    }
                    .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
