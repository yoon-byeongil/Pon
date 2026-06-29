import SwiftUI


struct ContentView: View {
    
    @AppStorage("themeColor") var themeColor: String = "blue"
    
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
        .tint(stringToColor(themeColor))
    }
}

#Preview {
    ContentView()
}
