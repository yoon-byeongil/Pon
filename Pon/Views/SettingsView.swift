import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("themeColorHex") private var themeColorHex: String = "#007AFF"
    
    // 테마 컬러 배열
    let themeColors: [(name: String, hex: String)] = [
        ("ブルー", "#007AFF"),
        ("レッド", "#FF3B30"),
        ("オレンジ", "#FF9500"),
        ("グリーン", "#34C759"),
        ("ミント", "#00C7BE"),
        ("パープル", "#AF52DE"),
        ("ピンク", "#FF2D55")
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("外観設定")) {
                    Toggle("ダークモード", isOn: $isDarkMode)
                    
                    // 직관적인 컬러 팔레트 UI
                    VStack(alignment: .leading, spacing: 12) {
                        Text("テーマカラー")
                            .foregroundColor(.primary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(themeColors, id: \.hex) { color in
                                    let isSelected = themeColorHex == color.hex
                                    let circleColor = Color(hex: color.hex)
                                    
                                    Circle()
                                        .fill(circleColor)
                                        .frame(width: 30, height: 30)
                                        // 선택되었을 때만 겉에 링을 그려주는 효과
                                        .padding(4)
                                        .background(
                                            Circle()
                                                .stroke(isSelected ? circleColor : Color.clear, lineWidth: 2)
                                        )
                                        .onTapGesture {
                                            // 터치 시 부드러운 전환 효과와 함께 색상 변경
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                themeColorHex = color.hex
                                            }
                                        }
                                }
                            }
                            // 스크롤 뷰가 폼(Form) 안에서 짤리지 않도록 패딩 추가
                            .padding(.vertical, 8)
                            .padding(.horizontal, 4)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
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
}

// HEX -> Color 변환 확장 (기존과 동일)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
