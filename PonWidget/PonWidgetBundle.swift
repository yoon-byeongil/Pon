import WidgetKit
import SwiftUI

@main
struct PonWidgetBundle: WidgetBundle {
    var body: some Widget {
        PonWidget()
        PonLiveActivity()
    }
}
