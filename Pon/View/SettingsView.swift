import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            NavigationStack {
                List {
                    NavigationLink(destination: ShortCutView()) {
                        HStack {
                            Image(systemName: "wand.and.sparkles")
                            Text("ショートカット設定")
                        }
                    }
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                            Text("プログラマー")
                        }
                    }
                }
                .navigationTitle("ヘルプ")
            }
        }
    }
}

#Preview {
    SettingsView()
}
