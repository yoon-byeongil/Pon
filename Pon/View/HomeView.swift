import SwiftUI
import SwiftData
import WidgetKit
import ActivityKit

struct TodoRow: View {
    let todo: Todo
    let onToggle: () -> Void
        
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
            }
            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .gray : .primary)
        }
    }
}

struct HomeView: View {
    
    @Environment(\.modelContext) var context
    @Query(sort: \Todo.createAt, order: .reverse, animation: .default) var todos: [Todo]
    
    @State var todotext: String = ""
    
    var today = Date()
    
    private var japaneseDateString: String {
        let locale = Locale(identifier: "ja_JP")
        return today.formatted(
            .dateTime
            .month(.wide)
            .day(.defaultDigits)
            .weekday(.short)
            .locale(locale)
        )
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack {
                    Text(japaneseDateString)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    Spacer()
                }
                
                if !todos.isEmpty {
                    List {
                        Section("To do") {
                            ForEach(todos.filter { !$0.isCompleted }) { todo in
                                TodoRow(todo: todo) {
                                    withAnimation(.default) { todo.isCompleted.toggle() }
                                    try? context.save()
                                    WidgetCenter.shared.reloadAllTimelines()
                                    updateLiveActivity()
                                }
                            }
                            .onDelete(perform: deleteIncompleteTodo(at:))
                        }
                        
                        if !todos.filter( { $0.isCompleted }).isEmpty {
                            Section("完了") {
                                ForEach(todos.filter( { $0.isCompleted })) { todo in
                                    TodoRow(todo: todo) {
                                        withAnimation(.default) { todo.isCompleted.toggle() }
                                        try? context.save()
                                        WidgetCenter.shared.reloadAllTimelines()
                                        updateLiveActivity()
                                    }
                                }
                                .onDelete(perform: deleteCompletedTodo(at:))
                            }
                        }
                    }
                    .listRowSpacing(10)
                    .scrollDismissesKeyboard(.immediately)
                } else {
                    ContentUnavailableView {
                        Label {
                            Text("空いています")
                                .foregroundStyle(.primary)
                        } icon: {
                            Image(systemName: "checkmark.circle.badge.questionmark")
                            .foregroundStyle(.tint)
                        }
                    } description: {
                        Text("タスクを追加しましょう")
                    }
                }
                    
                HStack {
                    TextField ("タスクを追加する", text: $todotext)
                        .padding(.horizontal)
                        .onSubmit {
                            addList()
                        }
                        .submitLabel(.send)
                    
                    Button(action: {
                        addList()
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                    }
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(28)
                .shadow(radius: 3)
                .padding(.horizontal)
                .padding(.bottom)
            } // Vstack
        } // ZStack
        .onAppear {
            startLiveActivity()
        }
    } // body
    
    
    func deleteIncompleteTodo(at offsets: IndexSet) {
        let incompleteTodo = todos.filter( { !$0.isCompleted })
        withAnimation {
            for index in offsets {
                let item = incompleteTodo[index]
                context.delete(item)
            }
        }
        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
        updateLiveActivity()
    }
    
    func deleteCompletedTodo(at offsets: IndexSet) {
        let completedTodo = todos.filter({ $0.isCompleted })
        withAnimation {
            for index in offsets {
                let item = completedTodo[index]
                context.delete(item)
            }
        }
        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
        updateLiveActivity()
    }
    
    func addList() {
        if !todotext.isEmpty {
            let newTodo = Todo(title: todotext, isCompleted: false)
            context.insert(newTodo)
            todotext = ""
            try? context.save()
            WidgetCenter.shared.reloadAllTimelines()
            updateLiveActivity()
        }
    }
    
    func startLiveActivity() {
        if !Activity<PonActivityAttributes>.activities.isEmpty {
            return
        }
        
        let incompleteTodos = todos.filter { !$0.isCompleted }.prefix(3)

        let initialState = PonActivityAttributes.ContentState(
            todoTitles: incompleteTodos.map { $0.title },
            todoIDs: incompleteTodos.map { $0.id.uuidString },
            totalCount: todos.filter { !$0.isCompleted }.count
        )
        
        let attributes = PonActivityAttributes()
        
        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil)
            )
        } catch {
            print(error)
        }
    }
    
    func updateLiveActivity() {
        let incompleteTodos = todos.filter { !$0.isCompleted }.prefix(3)
        let newState = PonActivityAttributes.ContentState(
            todoTitles: incompleteTodos.map { $0.title },
            todoIDs: incompleteTodos.map { $0.id.uuidString },
            totalCount: todos.filter { !$0.isCompleted }.count
        )
        
        Task {
            for activity in Activity<PonActivityAttributes>.activities {
                await activity.update(.init(state: newState, staleDate: nil))
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Todo.self, inMemory: true)
}
