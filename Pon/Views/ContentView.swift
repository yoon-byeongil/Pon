import SwiftUI

struct ContentView: View {
    @State var viewModel: TodoViewModel
    
    // 설정에서 저장한 값 불러오기
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
        // 사용자의 설정에 따라 다크모드 강제 지정
        .preferredColorScheme(isDarkMode ? .dark : .light)
        // 탭바 아이콘 색상을 테마 컬러로 변경
        .accentColor(Color(hex: themeColorHex))
    }
}

struct TodoListView: View {
    @State var viewModel: TodoViewModel
    @State private var newTaskTitle: String = ""
    let themeColor: Color // 상위에서 전달받은 테마 컬러
    
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
                            // 완료 여부에 따라 테마 컬러 적용
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
                            viewModel.deleteTask(task: viewModel.tasks[index])
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
                                // 업로드 버튼에도 테마 컬러 적용
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
