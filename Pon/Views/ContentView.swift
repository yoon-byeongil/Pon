import SwiftUI

struct ContentView: View {
    @State var viewModel: TodoViewModel
    @State private var newTaskTitle: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // 1. 할 일 입력창 (일본어 적용)
                HStack {
                    TextField("新しいタスクを入力", text: $newTaskTitle)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("追加") {
                        viewModel.addTask(title: newTaskTitle)
                        newTaskTitle = ""
                    }
                }
                .padding()
                
                // 2. 할 일 목록
                List {
                    ForEach(viewModel.tasks) { task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    viewModel.toggleTask(task: task)
                                }
                            
                            Text(task.title)
                                .strikethrough(task.isCompleted, color: .gray)
                                .foregroundColor(task.isCompleted ? .gray : .primary)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.deleteTask(task: viewModel.tasks[index])
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("ポン！")
        }
    }
}
