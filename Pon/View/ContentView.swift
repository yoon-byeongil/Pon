import SwiftUI


struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "checklist")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
