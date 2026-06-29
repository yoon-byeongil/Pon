import SwiftUI
import SwiftData
import WidgetKit

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
            .day(.twoDigits)
            .weekday(.short)
            .locale(locale)
        )
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack {
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
                    TextField ("Todoを追加する", text: $todotext)
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
                .cornerRadius(52)
                .shadow(radius: 4)
                .padding(.horizontal)
                .padding(.bottom)
            } // Vstack
        } // ZStack
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
    }
    
    func addList() {
        if !todotext.isEmpty {
            let newTodo = Todo(title: todotext, isCompleted: false)
            context.insert(newTodo)
            todotext = ""
            try? context.save()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Todo.self, inMemory: true)
}
