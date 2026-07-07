import ActivityKit


struct PonActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var todoTitles: [String]
        var todoIDs: [String]
        var totalCount: Int
    }
}
