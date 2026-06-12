import AppIntents
import SwiftData
import SwiftUI

struct ToggleTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "タスクの完了状態を切り替え"
    static var description = IntentDescription("ウィジェットからタスクを完了・未完了にします。")
    
    // 어떤 할 일을 클릭했는지 알아야 하므로 Task의 ID를 파라미터로 받습니다.
    @Parameter(title: "Task ID")
    var taskID: String
    
    // 이 인텐트가 생성될 때 필요한 초기화 함수
    init() {}
    
    init(taskID: String) {
        self.taskID = taskID
    }
    
    // 버튼을 눌렀을 때 백그라운드에서 실행되는 실제 로직
    @MainActor
    func perform() async throws -> some IntentResult {
        guard let id = UUID(uuidString: taskID) else { return .result() }
        
        // 1. 공유 데이터베이스 컨텍스트 가져오기
        let context = SharedDatabase.shared.container.mainContext
        
        // 2. 전달받은 ID와 일치하는 할 일 찾기
        let descriptor = FetchDescriptor<TodoTask>(predicate: #Predicate { $0.id == id })
        
        if let tasks = try? context.fetch(descriptor), let task = tasks.first {
            // 3. 완료 상태 토글 (반전)
            task.isCompleted.toggle()
            
            // 4. 변경 사항을 데이터베이스에 저장
            try? context.save()
        }
        
        return .result()
    }
}
