import AppIntents
import SwiftData
import WidgetKit

// 1. 단축어 앱에서 실행할 할 일 추가 액션 정의
struct AddTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "タスクを追加"
    static var description = IntentDescription("ポン！に新しいタスクを追加します。")

    // 단축어 실행 시 유저에게 입력받을 파라미터
    @Parameter(title: "タスク名")
    var title: String

    init() {}

    init(title: String) {
        self.title = title
    }

    // 단축어 앱이나 Siri를 통해 실행될 때 동작하는 로직
    @MainActor
    func perform() async throws -> some IntentResult {
        guard !title.isEmpty else { return .result() }

        // 공유 데이터베이스에 접근하여 할 일 추가
        let context = SharedDatabase.shared.container.mainContext
        let newTask = TodoTask(title: title)
        context.insert(newTask)

        // 저장 및 위젯 동기화
        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()

        return .result()
    }
}

struct PonShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddTaskIntent(),
            phrases: [
                "\(.applicationName)でタスクを追加",
                "\(.applicationName)にタスクを追加"
            ],
            shortTitle: "タスクを追加",
            systemImageName: "plus.circle"
        )
    }
}
