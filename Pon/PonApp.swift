import SwiftUI
import SwiftData

@main
struct PonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: TodoViewModel(modelContext: SharedDatabase.shared.container.mainContext))
                // ⭐️ 핵심: 화면(View)의 @Query가 데이터를 읽을 수 있도록 공유 DB 환경을 주입
                .modelContext(SharedDatabase.shared.container.mainContext)
        }
    }
}
