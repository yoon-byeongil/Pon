import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) var context
    @Query(sort: \Todo.createAt, order: .reverse, animation: .default) var todos: [Todo]
    
    @State var todotext: String = ""
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack {
                if !todos.isEmpty {
                    List() {
                        ForEach(todos) { todo in
                            HStack {
                                Button(action: {
                                    withAnimation(.default) {
                                        todo.isCompleted.toggle()
                                    }
                                }) {
                                    if todo.isCompleted {
                                        Image(systemName: "checkmark.circle.fill")
                                    } else {
                                        Image(systemName: "circle")
                                    }
                                }
                                Text(todo.title)
                                    .strikethrough(todo.isCompleted)
                                    .foregroundStyle(todo.isCompleted ? .gray : .primary)
                            }
                        }
                        .onDelete(perform: deleteList)
                    }
                    .listRowSpacing(10)
                    .scrollDismissesKeyboard(.immediately)
                } else {
                    ContentUnavailableView(
                        "やることを追加しましょう",
                        systemImage: "list.bullet.badge.ellipsis"
                    )
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
    
    func deleteList(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let item = todos[index]
                context.delete(item)
            }
        }
    }
    
    func addList() {
        if !todotext.isEmpty {
            let newTodo = Todo(title: todotext, isCompleted: false)
            context.insert(newTodo)
            todotext = ""
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Todo.self, inMemory: true)
}
