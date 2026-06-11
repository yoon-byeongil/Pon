import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("アプリ情報")) {
                HStack {
                    Text("バージョン")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("ショートカット・ウィジェット")) {
                Text("iOSのショートカットアプリやロック画面ウィジェットから、素早くタスクを追加・確認できます。")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("設定")
        .navigationBarTitleDisplayMode(.inline)
    }
}
