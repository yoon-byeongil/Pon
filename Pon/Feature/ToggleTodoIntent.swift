import SwiftData
import AppIntents
import WidgetKit


struct ToggleTodoIntent: AppIntent {
    static var title: LocalizedStringResource = "タスクを完了"
    
    @Parameter(title: "タスクID")
    var todoID: String
    
    init() {}
        
    init(todoID: String) {
        self.todoID = todoID
    }
    
    func perform() async throws -> some IntentResult {
        let url = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.com.yoon.Pon")!
            .appendingPathComponent("Pon.sqlite")
        let container = try ModelContainer(
            for: Todo.self,
            configurations: ModelConfiguration(url: url)
        )
        let modelContext = ModelContext(container)
        
        
        // todoID로 해당 Todo 찾아서 isCompleted 토글
        // FetchDescriptor로 전체 todos 가져오고
        let todos = try modelContext.fetch(FetchDescriptor<Todo>())

        // filter로 todoID랑 일치하는 것 찾고
        if let todo = todos.first(where: { $0.id.uuidString == todoID }) {
            // 토글
            todo.isCompleted.toggle()
            try? modelContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        return .result()
    }
}
