import SwiftUI

// 1. 메인 화면 (탭바 및 전체 배경 설정)
struct ContentView: View {
    @State var viewModel: TodoViewModel
    
    init(viewModel: TodoViewModel) {
        self._viewModel = State(initialValue: viewModel)
        
        // 탭바의 배경색을 시스템 기본 배경색으로 강제 통일하여 일체감을 줌
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            TodoListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "checklist")
                    Text("タスク")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("設定")
                }
        }
    }
}

// 2. 할 일 목록 뷰
struct TodoListView: View {
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
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        // 캡슐 모양이 적용된 입력 필드
                        TextField("新しいタスクを入力", text: $newTaskTitle)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(Color(UIColor.secondarySystemFill)) // 약간 어두운 내부 배경
                            .clipShape(Capsule()) // 완벽한 캡슐 형태로 자르기
                        
                        Button(action: {
                            guard !newTaskTitle.isEmpty else { return }
                            withAnimation(.spring) {
                                viewModel.addTask(title: newTaskTitle)
                                newTaskTitle = ""
                            }
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(newTaskTitle.isEmpty ? .gray : .blue)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    // 탭바와 동일한 시스템 배경색을 칠해서 하나로 이어지게 만듦
                    .background(Color(UIColor.systemBackground))
                }
            }
        }
    }
}
