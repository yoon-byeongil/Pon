import SwiftUI

struct Todo: Identifiable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
}

struct ContentView: View {
    
    var todos: [Todo] = [
        Todo(title: "운동하기", isCompleted: false),
        Todo(title: "장보기", isCompleted: true),
        Todo(title: "책 읽기", isCompleted: true)
    ]
    
    
    var body: some View {
        List(todos) { todo in
            HStack {
                if todo.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                } else {
                    Image(systemName: "circle")
                }
                Text(todo.title)
            }
        }
    }
}

#Preview {
    ContentView()
}
