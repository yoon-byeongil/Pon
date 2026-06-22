import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 150, height: 150)
                    .padding()
                Text("ポン")
                    .font(.largeTitle)
                Text("Ver : 1.0")
                    .font(.title3)
                    .padding(.bottom)
                Text("世界一素早いタスク管理。")
                    .font(.headline)
                    .foregroundStyle(.gray)
                Text("一瞬での追加とチェック。")
                    .font(.headline)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    AboutView()
}
