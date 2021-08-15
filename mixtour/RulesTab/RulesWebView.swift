import SwiftUI

struct RulesWebView: View {
    @StateObject var model = WebViewModel()

    var body: some View {
        WebView(webView: model.webView)
    }
}
