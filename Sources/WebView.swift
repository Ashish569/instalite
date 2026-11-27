import SwiftUI
import WebKit

struct SocialWebView: UIViewRepresentable {

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = .all

        let script = WKUserScript(
            source: injectionScript,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: false
        )
        config.userContentController.addUserScript(script)

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard webView.url == nil else { return }
        webView.load(URLRequest(url: URL(string: "https://www.instagram.com")!))
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {

        // Re-run injection after every page navigation (IG is a SPA)
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript(injectionScript)
        }

        // Grant camera/mic permission when Instagram stories requests it
        @available(iOS 15.0, *)
        func webView(
            _ webView: WKWebView,
            requestMediaCapturePermissionFor origin: WKSecurityOrigin,
            initiatedByFrame frame: WKFrameInfo,
            type: WKMediaCaptureType,
            decisionHandler: @escaping (WKPermissionDecision) -> Void
        ) {
            decisionHandler(.grant)
        }

    }
}

private let injectionScript = """
(function() {
    function clean() {
        // Hide only the Reels nav item
        document.querySelectorAll('a[href="/reels/"]').forEach(el => {
            let item = el.parentElement;
            if (item) item.style.display = 'none';
        });
        // Fallback: aria-label based nav (some IG versions)
        document.querySelectorAll('[aria-label="Reels"]').forEach(el => {
            if (el.closest('nav, [role="navigation"]')) {
                el.style.display = 'none';
            }
        });
        // Redirect if user somehow lands on /reels/
        if (window.location.pathname.startsWith('/reels')) {
            window.location.replace('https://www.instagram.com/');
        }
    }
    clean();
    new MutationObserver(clean).observe(document.body, { childList: true, subtree: true });
})();
"""
