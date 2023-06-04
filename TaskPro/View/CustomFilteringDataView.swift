//
//  CustomFilteringDataView.swift
//  TaskPro
//
//  Created by Nico Müller on 04.06.23.
//

import SwiftUI

struct CustomFilteringDataView<Content: View>: View {
    
    var content: ([Task], [Task]) -> Content
    @FetchRequest private var results: FetchedResults<Task>
    @Binding private var filterDate: Date
    
    init(filterDate: Binding<Date>, @ViewBuilder content: @escaping ([Task], [Task]) -> Content) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: filterDate.wrappedValue)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
        
        let predicate = NSPredicate(
            format: "date >= %@ AND date <= %@", argumentArray: [startOfDay, endOfDay])
        
        _results = FetchRequest(
            entity: Task.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)],
            predicate: predicate,
            animation: .easeInOut(duration: 0.25))
        
        self.content = content
        self._filterDate = filterDate
    }
    
    var body: some View {
        content(separateTasks().0, separateTasks().1)
            .onChange(of: filterDate) { newValue in
                results.nsPredicate = nil
                
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: newValue)
                let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
                let predicate = NSPredicate(
                    format: "date >= %@ AND date <= %@", argumentArray: [startOfDay, endOfDay])
                
                results.nsPredicate = predicate
            }
    }
    
    func separateTasks() -> ([Task], [Task]) {
        let pendingTasks = results.filter { !$0.isCompleted }
        let completedTasks = results.filter { $0.isCompleted }
        return (pendingTasks, completedTasks)
    }
}

struct CustomFilteringDataView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
