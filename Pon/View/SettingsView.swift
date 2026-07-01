import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            NavigationStack {
                List {
                    Section {
                        NavigationLink(destination: DesignView()) {
                            HStack {
                                Image(systemName: "paintpalette")
                                    .foregroundStyle(.tint)
                                Text("デザイン")
                            }
                        }
                    }
                    Section("ヘルプ") {
                        NavigationLink(destination: ShortCutView()) {
                            HStack {
                                Image(systemName: "wand.and.sparkles")
                                    .foregroundStyle(.tint)
                                Text("ショートカット設定")
                            }
                        }
                        NavigationLink(destination: AboutView()) {
                            HStack {
                                Image(systemName: "questionmark.circle")
                                    .foregroundStyle(.tint)
                                Text("バージョン")
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
