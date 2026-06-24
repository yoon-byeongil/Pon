import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), todos: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), todos: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        do {
            let url = FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: "group.com.yoon.Pon")!
                .appendingPathComponent("Pon.sqlite")
            let container = try ModelContainer(
                for: Todo.self,
                configurations: ModelConfiguration(url: url)
            )
            let modelContext = ModelContext(container)
            let todos = try modelContext.fetch(FetchDescriptor<Todo>())
            let entry = SimpleEntry(date: Date(), todos: todos)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        } catch {
            let entry = SimpleEntry(date: Date(), todos: [])
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let todos: [Todo]
}

struct PonWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let incompleteTodos = entry.todos
            .filter { !$0.isCompleted }
            .prefix(3)
        
        VStack(alignment: .leading) {
            ForEach(Array(incompleteTodos)) { todo in
                HStack {
                    Image(systemName: "circle")
                    Text(todo.title)
                }
            }
        }
    }
}

struct PonWidget: Widget {
    let kind: String = "PonWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PonWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PonWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    PonWidget()
} timeline: {
    SimpleEntry(date: .now, todos: [])
}
