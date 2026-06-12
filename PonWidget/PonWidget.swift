import WidgetKit
import SwiftUI
import SwiftData

// 1. 위젯에 데이터를 공급해주는 프로바이더
struct Provider: TimelineProvider {
    // 위젯이 처음 로딩될 때 보여줄 더미 데이터
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), tasks: [TodoTask(title: "タスクの読み込み中...")])
    }

    // 위젯 갤러리에서 미리보기로 보여줄 데이터
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), tasks: [TodoTask(title: "サンプルタスク1"), TodoTask(title: "サンプルタスク2")])
        completion(entry)
    }

    // 실제 시간에 맞춰 위젯을 업데이트하는 로직 (내일 실제 DB와 연동할 예정)
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // 임시로 보여줄 가짜 데이터
        let entries = [SimpleEntry(date: Date(), tasks: [
            TodoTask(title: "iOS 26 ウィジェット設計"),
            TodoTask(title: "SwiftData 連携")
        ])]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// 2. 위젯이 들고 있을 데이터 형식
struct SimpleEntry: TimelineEntry {
    let date: Date
    let tasks: [TodoTask]
}

// 3. 위젯의 실제 화면 (iOS 26 스타일의 극강 미니멀리즘 UI)
struct PonWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        // 첫 번째 VStack: 위젯 전체 요소의 왼쪽 정렬
        VStack(alignment: .leading, spacing: 8) {
            Text("ポン！")
                .font(.headline)
                .foregroundColor(.secondary)
            
            // 두 번째 VStack: 할 일 목록 요소들의 왼쪽 정렬
            VStack(alignment: .leading, spacing: 6) {
                ForEach(entry.tasks.prefix(3)) { task in
                    HStack {
                        Image(systemName: "circle")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(task.title)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                    }
                }
            }
            Spacer() // 목록을 위로 밀어올리고 남은 공간을 차지함
        }
        // 위젯 내용이 중앙이 아닌 왼쪽 상단부터 배치되도록 frame 설정 추가
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(Color.clear, for: .widget)
    }
}

// 4. 위젯 메인 설정
@main
struct PonWidget: Widget {
    let kind: String = "PonWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PonWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ポン！ ウィジェット")
        .description("今日のタスクをホーム画面で素早く確認できます。")
        // 가장 많이 쓰이는 작은 사각형, 중간 직사각형 위젯만 지원
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
