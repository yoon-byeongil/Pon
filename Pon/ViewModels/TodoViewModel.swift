import Foundation
import SwiftData
import Observation

@Observable
final class TodoViewModel {
    // 뷰에서 보여줄 정렬된 할 일 목록
    var tasks: [TodoTask] = []
    
    // SwiftData의 데이터베이스 조작을 위한 컨텍스트 저장소
    private var modelContext: ModelContext
    
    // 생성자를 통해 외부(App 구조체)에서 modelContext를 주입받음
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchTasks() // 뷰모델이 생성될 때 기존 저장된 데이터를 불러옴
    }
    
    // 1. 데이터 불러오기 (Read)
    func fetchTasks() {
        do {
            // 생성일자(createdAt) 기준 오름차순 정렬하여 가져오기
            let descriptor = FetchDescriptor<TodoTask>(sortBy: [SortDescriptor(\.createdAt, order: .forward)])
            tasks = try modelContext.fetch(descriptor)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    // 2. 새로운 할 일 추가 (Create)
    func addTask(title: String) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newTask = TodoTask(title: title)
        modelContext.insert(newTask) // SwiftData 컨텍스트에 삽입
        fetchTasks() // 목록 갱신
    }
    
    // 3. 할 일 완료 상태 토글 (Update)
    func toggleTask(task: TodoTask) {
        task.isCompleted.toggle()
        // SwiftData는 @Model 객체의 프로퍼티가 변경되면 자동으로 저장소에 반영합니다.
        fetchTasks() // 목록 갱신
    }
    
    // 4. 할 일 삭제 (Delete)
    func deleteTask(task: TodoTask) {
        modelContext.delete(task) // SwiftData 컨텍스트에서 삭제
        fetchTasks() // 목록 갱신
    }
}
