import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

// 1. 위젯 타임라인 프로바이더
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), tasks: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), tasks: [])
        completion(entry)
    }

    // 메인 스레드에서 안전하게 공유 데이터베이스에 접근
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task { @MainActor in
            let contextDB = SharedDatabase.shared.container.mainContext
            
            // 완료되지 않은 할 일만 최신순으로 가져오기
            let descriptor = FetchDescriptor<TodoTask>(
                predicate: #Predicate { !$0.isCompleted },
                sortBy: [SortDescriptor(\.createdAt, order: .forward)]
            )
            
            let tasks = (try? contextDB.fetch(descriptor)) ?? []
            
            let entry = SimpleEntry(date: Date(), tasks: tasks)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

// 2. 위젯 데이터 엔트리
struct SimpleEntry: TimelineEntry {
    let date: Date
    let tasks: [TodoTask]
}

// 3. 위젯 뷰 (iOS 26 Liquid Glass & 좌측 정렬 적용)
struct PonWidgetEntryView : View {
    var entry: Provider.Entry
    
    // 시스템의 컬러 스킴(라이트/다크)을 감지
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ポン！")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 12) {
                if entry.tasks.isEmpty {
                    Text("残りのタスクはありません🎉")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                } else {
                    ForEach(entry.tasks.prefix(3)) { task in
                        HStack(spacing: 12) {
                            Button(intent: ToggleTaskIntent(taskID: task.id.uuidString)) {
                                Image(systemName: "circle")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.plain)
                            
                            Text(task.title)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                .lineLimit(1)
                        }
                    }
                }
            }
            Spacer(minLength: 0)
        }
        // ⭐️ 누락되었던 정렬 코드 추가: 전체 요소를 왼쪽 상단으로 고정
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(for: .widget) {
            Rectangle().fill(.ultraThinMaterial)
        }
    }
}
// 4. 위젯 메인
@main
struct PonWidget: Widget {
    let kind: String = "PonWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PonWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ポン！ ウィジェット")
        .description("今日のタスクをホーム画面で素早く確認できます。")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
