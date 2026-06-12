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

// 3. 위젯 뷰 (iOS 26 심플 디자인 및 좌측 정렬)
struct PonWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ポン！")
                .font(.headline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 6) {
                if entry.tasks.isEmpty {
                    Text("残りのタスクはありません🎉")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    // 공간 제약상 최대 4개까지만 표시
                    ForEach(entry.tasks.prefix(4)) { task in
                        HStack {
                            // 메인 앱 실행 없이 위젯에서 바로 체크(완료)하는 버튼
                            Button(intent: ToggleTaskIntent(taskID: task.id.uuidString)) {
                                Image(systemName: "circle")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .buttonStyle(.plain)
                            
                            Text(task.title)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                        }
                    }
                }
            }
            Spacer()
        }
        // 위젯 내부 요소를 전체적으로 왼쪽 상단에 밀착
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        // 위젯 배경을 투명하게 만들어 홈 화면 배경에 동화시킴
        .containerBackground(Color.clear, for: .widget)
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
