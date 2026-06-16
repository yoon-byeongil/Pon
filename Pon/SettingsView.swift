import SwiftUI

struct SettingsView: View {
    var body: some View {
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

struct ShortCutView: View {
    var body: some View {
        Text("ショートカット設定")
            .font(.title)
    }
}

struct AboutView: View {
    var body: some View {
        Text("プログラマー")
            .font(.title)
    }
}

#Preview {
    SettingsView()
}
