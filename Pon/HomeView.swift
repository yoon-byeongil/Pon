import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) var context
    @Query var todos: [Todo]
    
    @State var todotext: String = ""
    
    var body: some View {
        VStack {
            List() {
                ForEach(todos) { todo in
                    HStack {
                        Button(action: {
                            todo.isCompleted.toggle()
                        }) {
                            if todo.isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                        Text(todo.title)
                    }
                }
                .onDelete(perform: deleteList)
            }
            
            HStack {
                TextField (
                    "Todoを追加する",
                    text: $todotext
                )
                .padding()
                
                Button(action: {
                    addList()
                }) {
                    Image(systemName: "arrow.up")
                }
                .padding()
            }
        }
    }
    
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
