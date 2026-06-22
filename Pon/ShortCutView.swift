import SwiftUI

struct ShortCutView: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack {
                Text("上のボタンをタップすると、ショートカットアプリに「ポンに追加」ショートカットが作成されます。実行すると、アプリを開かずに 入力画面から直接タスクを追加できます。")
                    .padding()
                
                List {
                    Section(header: Text("活用方法")) {
                        HStack(alignment: .top) {
                            Image(systemName: "button.programmable")
                                .font(.system(size: 24))
                                .frame(width: 36)
                            VStack(alignment: .leading) {
                                Text("アクションボタンに割り当てる")
                                    .font(.title3)
                                Text("設定 > アクションボタンで 「ショートカット」 を選び、「ポン」 ショートカットを選択すると、 アクションボタンを1回押すだけでタスクを追加できます。")
                                    .font(.subheadline)
                            }
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "widget.small")
                                .font(.system(size: 24))
                                .frame(width: 36)
                            VStack(alignment: .leading) {
                                Text("ウィジェットから実行")
                                    .font(.title3)
                                Text("ホーム画面やロック画面にショートカットウィジェットを追加し、 「ポン」 ショートカットを指定すると、 1タップで簡単にタスクを追加できます。")
                                    .font(.subheadline)
                            }
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 24))
                                .frame(width: 36)
                            VStack(alignment: .leading) {
                                Text("背面タップで実行")
                                    .font(.title3)
                                Text("設定 > アクセシビリティ > タッチ > 背面タップ に 「ポン」 ショートカットを指定すると、 デバイスの背面をタップするだけでタスクを追加できます。")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    ShortCutView()
}
