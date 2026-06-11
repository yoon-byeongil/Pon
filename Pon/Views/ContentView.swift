import SwiftUI

struct ContentView: View {
    @State var viewModel: TodoViewModel
    @State private var newTaskTitle: String = ""
    
    var todayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月d日(E)"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.tasks) { task in
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title2)
                            .foregroundColor(task.isCompleted ? .secondary : .primary)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    viewModel.toggleTask(task: task)
                                }
                            }
                        
                        Text(task.title)
                            .font(.body)
                            .strikethrough(task.isCompleted, color: .secondary)
                            .foregroundColor(task.isCompleted ? .secondary : .primary)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { indexSet in
                    withAnimation {
                        for index in indexSet {
                            viewModel.deleteTask(task: viewModel.tasks[index])
                        }
                    }
                }
            }
            .navigationTitle(todayString)
            // 핵심: 커스텀 하단 뷰를 제거하고 시스템 툴바(bottomBar) 사용
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        TextField("新しいタスクを入力", text: $newTaskTitle)
                            .textFieldStyle(.roundedBorder)
                        
                        Button(action: {
                            guard !newTaskTitle.isEmpty else { return }
                            withAnimation(.spring) {
                                viewModel.addTask(title: newTaskTitle)
                                newTaskTitle = ""
                            }
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                        }
                    }
                }
            }
        }
    }
}
