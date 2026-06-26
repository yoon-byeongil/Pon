import SwiftData
import AppIntents
import WidgetKit


struct AddTodoIntent: AppIntent {
    static var title: LocalizedStringResource = "Ponにタスクを追加"
    
    @Parameter(title: "タスク")
    var tasktitle: String
    
    func perform() async throws -> some IntentResult {
        let url = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.com.yoon.Pon")!
            .appendingPathComponent("Pon.sqlite")
        let container = try ModelContainer(
            for: Todo.self,
            configurations: ModelConfiguration(url: url)
        )
        let modelContext = ModelContext(container)
        
        if !tasktitle.isEmpty {
            let newTodo = Todo(title: tasktitle, isCompleted: false)
            modelContext.insert(newTodo)
            try? modelContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        return .result()
    }
}

struct PonShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddTodoIntent(),
            phrases: [
                "\(.applicationName)にタスクを追加"
            ],
            shortTitle: "タスクを追加",
            systemImageName: "plus.circle"
        )
    }
}
