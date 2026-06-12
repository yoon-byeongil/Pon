import Foundation
import SwiftData

// 앱과 위젯이 공통으로 사용할 데이터베이스 환경 설정
@MainActor
class SharedDatabase {
    static let shared = SharedDatabase()
    
    let container: ModelContainer
    
    private init() {
        // App Group 식별자 (아까 Xcode에서 입력한 것과 정확히 일치해야 합니다)
        let groupID = "group.com.yoon.Pon" // ⚠️ 본인이 설정한 이름으로 반드시 수정하세요!
        
        // 공유 폴더 경로 지정
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)!
            .appendingPathComponent("PonTodo.sqlite")
        
        let config = ModelConfiguration(url: url)
        
        do {
            container = try ModelContainer(for: TodoTask.self, configurations: config)
        } catch {
            fatalError("공유 데이터베이스를 생성할 수 없습니다: \(error.localizedDescription)")
        }
    }
}
