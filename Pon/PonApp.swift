import SwiftUI
import SwiftData

@main
struct PonApp: App {
    // 1. SwiftData 데이터베이스 컨테이너 준비
    let container: ModelContainer
    
    init() {
        do {
            // TodoTask 모델을 저장할 데이터베이스 생성
            container = try ModelContainer(for: TodoTask.self)
        } catch {
            fatalError("데이터베이스를 생성할 수 없습니다: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            // 2. ContentView에 ViewModel을 생성해서 쥐어주기
            ContentView(viewModel: TodoViewModel(modelContext: container.mainContext))
        }
    }
}
