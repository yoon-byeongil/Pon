import SwiftUI

struct ContentView: View {
    @State var viewModel: TodoViewModel
    @State private var newTaskTitle: String = ""
    
    // 1. 오늘의 날짜와 요일을 일본어 형식으로 반환 (예: 6月11日(木))
    var todayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月d日(E)"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        NavigationStack {
            // 2. 화려한 그라데이션 제거, 차분한 시스템 배경 적용
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
                .overlay {
                    List {
                        ForEach(viewModel.tasks) { task in
                            HStack {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.title2)
                                    .foregroundColor(task.isCompleted ? .gray : .primary)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            viewModel.toggleTask(task: task)
                                        }
                                    }
                                
                                Text(task.title)
                                    .font(.body)
                                    .strikethrough(task.isCompleted, color: .gray)
                                    .foregroundColor(task.isCompleted ? .gray : .primary)
                            }
                            .padding(.vertical, 8)
                            .listRowBackground(Color.clear)
                            .background(.ultraThinMaterial) // 심플한 투명 재질
                            .cornerRadius(10)
                            .listRowSeparator(.hidden)
                        }
                        .onDelete { indexSet in
                            withAnimation {
                                for index in indexSet {
                                    viewModel.deleteTask(task: viewModel.tasks[index])
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    
                    // 3. 할 일 추가 영역을 화면 하단으로 이동 및 글래스 독(Dock) 처리
                    .safeAreaInset(edge: .bottom) {
                        HStack {
                            TextField("新しいタスクを入力", text: $newTaskTitle)
                                .padding(12)
                                .background(Color(UIColor.systemBackground).opacity(0.6))
                                .cornerRadius(10)
                            
                            Button(action: {
                                guard !newTaskTitle.isEmpty else { return }
                                withAnimation(.spring) {
                                    viewModel.addTask(title: newTaskTitle)
                                    newTaskTitle = ""
                                }
                            }) {
                                Image(systemName: "arrow.up.circle.fill") // 깔끔한 화살표 아이콘으로 변경
                                    .font(.system(size: 32))
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding()
                        .background(.regularMaterial) // 밑바탕이 은은하게 비치는 글래스 효과
                    }
                }
                .navigationTitle(todayString)
        }
    }
}
