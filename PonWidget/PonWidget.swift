import WidgetKit
import SwiftUI
import SwiftData
import AppIntents
import ActivityKit

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
            
            let descriptor = FetchDescriptor<Todo>(
                sortBy: [SortDescriptor(\Todo.createAt, order: .reverse)]
            )
            let todos = try modelContext.fetch(descriptor)
            
            let entry = SimpleEntry(date: Date(), todos: todos)
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
        } catch {
            let entry = SimpleEntry(date: Date(), todos: [])
            let timeline = Timeline(entries: [entry], policy: .never)
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
    @Environment(\.widgetFamily) var family

    var body: some View {
        let incompleteTodos = entry.todos
            .filter { !$0.isCompleted }
            .prefix(3)

        switch family {
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                ForEach(Array(incompleteTodos)) { todo in
                    HStack(spacing: 4) {
                        Image(systemName: "circle")
                        Text(todo.title)
                            .lineLimit(1)
                    }
                    .font(.caption)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        default:
            VStack(alignment: .leading) {
                ForEach(Array(incompleteTodos)) { todo in
                    HStack {
                        Button(intent: ToggleTodoIntent(todoID: todo.id.uuidString)) {
                            Image(systemName: "circle")
                                .foregroundStyle(.primary)
                        }
                        .buttonStyle(.plain)
                        Text(todo.title)
                    }
                    .padding(.vertical, 6)
                }
            } 
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
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
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryRectangular])
    }
}

struct PonLiveActivityView: View {
    let context: ActivityViewContext<PonActivityAttributes>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(zip(context.state.todoTitles, context.state.todoIDs)), id: \.1) { title, id in
                HStack {
                    Button(intent: ToggleTodoLiveActivityIntent(todoID: id)) {
                        Image(systemName: "circle")
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.plain)
                    Text(title)
                }
                .padding(.vertical, 6)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct PonLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PonActivityAttributes.self) { context in
            PonLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    PonLiveActivityView(context: context)
                }
            } compactLeading: {
                Image(systemName: "checklist")
            } compactTrailing: {
                Text("\(context.state.totalCount)")
            } minimal: {
                Image(systemName: "checklist")
            }
        }
    }
}

#Preview(as: .systemSmall) {
    PonWidget()
} timeline: {
    SimpleEntry(date: .now, todos: [])
}
