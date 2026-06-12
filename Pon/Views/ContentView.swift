import SwiftUI
import SwiftData

struct ContentView: View {
    @State var viewModel: TodoViewModel
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("themeColorHex") private var themeColorHex: String = "#007AFF"
    
    init(viewModel: TodoViewModel) {
        self._viewModel = State(initialValue: viewModel)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            // ⭐️ 뷰모델만 넘겨줌 (tasks는 TodoListView가 직접 감시함)
            TodoListView(viewModel: viewModel, themeColor: Color(hex: themeColorHex))
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
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .accentColor(Color(hex: themeColorHex))
        // 수동으로 fetchTasks를 부르던 .onChange(of: scenePhase) 부분은 완전히 삭제!
    }
}

struct TodoListView: View {
    @State var viewModel: TodoViewModel
    @State private var newTaskTitle: String = ""
    let themeColor: Color
    
    // ⭐️ 핵심: @Query를 써서 공유 DB의 변경사항을 뷰가 실시간으로 자동 감시함
    @Query(sort: \TodoTask.createdAt, order: .forward) var tasks: [TodoTask]
    
    var todayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月d日(E)"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        NavigationStack {
            List {
                // ⭐️ 뷰모델의 tasks가 아니라 @Query로 불러온 tasks를 사용함
                ForEach(tasks) { task in
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title2)
                            .foregroundColor(task.isCompleted ? themeColor : .primary)
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
                            viewModel.deleteTask(task: tasks[index])
                        }
                    }
                }
            }
            .navigationTitle(todayString)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        TextField("新しいタスクを入力", text: $newTaskTitle)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(Color(UIColor.secondarySystemFill))
                            .clipShape(Capsule())
                        
                        Button(action: {
                            guard !newTaskTitle.isEmpty else { return }
                            withAnimation(.spring) {
                                viewModel.addTask(title: newTaskTitle)
                                newTaskTitle = ""
                            }
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(newTaskTitle.isEmpty ? .gray : themeColor)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(UIColor.systemBackground))
                }
            }
        }
    }
}
