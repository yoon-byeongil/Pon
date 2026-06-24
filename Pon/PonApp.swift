import SwiftUI
import SwiftData

@main
struct PonApp: App {
    
    let container: ModelContainer = {
        do {
            let url = FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: "group.com.yoon.Pon")!
                .appendingPathComponent("Pon.sqlite")
            return try ModelContainer(
                for: Todo.self,
                configurations: ModelConfiguration(url: url)
            )
        } catch {
            fatalError()
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
