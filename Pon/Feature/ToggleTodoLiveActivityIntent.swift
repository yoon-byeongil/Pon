import SwiftData
import AppIntents
import WidgetKit
import ActivityKit

struct ToggleTodoLiveActivityIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "タスクを完了"
    
    @Parameter(title: "タスクID")
    var todoID: String
    
    init() {}
    
    init(todoID: String) {
        self.todoID = todoID
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let url = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.com.yoon.Pon")!
            .appendingPathComponent("Pon.sqlite")
        let container = try ModelContainer(
            for: Todo.self,
            configurations: ModelConfiguration(url: url)
        )
        let modelContext = ModelContext(container)
        
        let descriptor = FetchDescriptor<Todo>(
            sortBy: [SortDescriptor(\Todo.createAt, order: .reverse)]
        )
        let todos = try modelContext.fetch(descriptor)
        
        if let todo = todos.first(where: { $0.id.uuidString == todoID }) {
            todo.isCompleted.toggle()
            try? modelContext.save()
            WidgetCenter.shared.reloadAllTimelines()
            
            // 다시 fetch하지 않고 기존 todos에서 계산
            // (todo가 class라 toggle 결과가 이미 todos 배열에도 반영됨)
            let incompleteTodos = todos.filter { !$0.isCompleted }.prefix(3)
            
            let newState = PonActivityAttributes.ContentState(
                todoTitles: incompleteTodos.map { $0.title },
                todoIDs: incompleteTodos.map { $0.id.uuidString },
                totalCount: todos.filter { !$0.isCompleted }.count
            )
            for activity in Activity<PonActivityAttributes>.activities {
                await activity.update(.init(state: newState, staleDate: nil))
            }
        }
        
        return .result()
    }
}
