import SwiftUI
import SwiftData
import WidgetKit

@Observable
class TodoViewModel {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // 데이터를 가져오는 fetchTasks()는 지웠어. 이제 뷰에서 직접 할 거야.
    
    func addTask(title: String) {
        let newTask = TodoTask(title: title)
        modelContext.insert(newTask)
        save()
    }
    
    func toggleTask(task: TodoTask) {
        task.isCompleted.toggle()
        save()
    }
    
    func deleteTask(task: TodoTask) {
        modelContext.delete(task)
        save()
    }
    
    private func save() {
        try? modelContext.save()
        WidgetCenter.shared.reloadAllTimelines() // 위젯 새로고침 신호
    }
}
