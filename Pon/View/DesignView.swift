import SwiftUI

struct DesignView: View {
    
    @AppStorage("themeColor") var themeColor: String = "blue"
    
    let firstRowColors: [Color] = [.red, .orange, .yellow, .green, .mint, .teal]
    let secondRowColors: [Color] = [.blue, .indigo, .purple, .pink, .brown, .gray]
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            List {
                Section("テーマカラー") {
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            ForEach(firstRowColors, id: \.self) { color in
                                Button {
                                    themeColor = colorToString(color)
                                } label: {
                                    Image(systemName: themeColor == colorToString(color) ? "checkmark.circle.fill" : "circle.fill")
                                        .resizable()
                                        .foregroundStyle(color)
                                        .frame(width: 36, height: 36)
                                }
                                .buttonStyle(.plain)
                                Spacer()
                            }
                        }
                        
                        
                        HStack {
                            Spacer()
                            ForEach(secondRowColors, id: \.self) { color in
                                Button {
                                    themeColor = colorToString(color)
                                } label: {
                                    Image(systemName: themeColor == colorToString(color) ? "checkmark.circle.fill" : "circle.fill")
                                        .resizable()
                                        .foregroundStyle(color)
                                        .frame(width: 36, height: 36)
                                }
                                .buttonStyle(.plain)
                                Spacer()
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        } // ZStack
    } // body
}

#Preview {
    DesignView()
}
