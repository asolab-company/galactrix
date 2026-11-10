import UIKit
import WebKit

final class StartupWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    private let url: URL
    private var initialLoadFailed: (() -> Void)?
    private var timeout: DispatchWorkItem?
    private let webView: WKWebView
    private var downloads: [WKDownload: URL] = [:]
    private var completedDownloads: [URL] = []

    init(url: URL, initialLoadFailed: @escaping () -> Void) {
        self.url = url
        self.initialLoadFailed = initialLoadFailed
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences.isElementFullscreenEnabled = true
        webView = WKWebView(frame: .zero, configuration: configuration)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        traitCollection.userInterfaceIdiom == .pad ? .all : .allButUpsideDown
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.accessibilityIdentifier = "startup-webview"
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(webView)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            webView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

        let timeout = DispatchWorkItem { [weak self] in self?.failInitialLoad() }
        self.timeout = timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + 25, execute: timeout)
        webView.load(URLRequest(url: url, timeoutInterval: 25))
    }

    private func failInitialLoad() {
        guard let failure = initialLoadFailed else { return }
        initialLoadFailed = nil
        timeout?.cancel()
        timeout = nil
        webView.stopLoading()
        failure()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        finishInitialLoad()
    }

    private func finishInitialLoad() {
        initialLoadFailed = nil
        timeout?.cancel()
        timeout = nil
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if (error as? URLError)?.code != .cancelled { failInitialLoad() }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if (error as? URLError)?.code != .cancelled { failInitialLoad() }
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        if initialLoadFailed != nil { failInitialLoad() } else { webView.reload() }
    }

    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let target = action.request.url else {
            decisionHandler(.cancel)
            return
        }
        let isWebURL = PinGameLinks.isWebURL(target)
        if action.shouldPerformDownload && (isWebURL || target.scheme == "blob" || target.scheme == "data") {
            decisionHandler(.download)
            return
        }
        guard action.targetFrame?.isMainFrame != false else {
            decisionHandler(.allow)
            return
        }

        decisionHandler(isWebURL ? .allow : .cancel)
    }

    func webView(_ webView: WKWebView, decidePolicyFor response: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if response.isForMainFrame, let http = response.response as? HTTPURLResponse, http.statusCode >= 400 {
            decisionHandler(.cancel)
            failInitialLoad()
        } else if !response.canShowMIMEType {
            if response.isForMainFrame { finishInitialLoad() }
            decisionHandler(.download)
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if action.targetFrame == nil, let url = action.request.url, PinGameLinks.isWebURL(url) {
            webView.load(action.request)
        }
        return nil
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        guard let dialog = makeDialog(message: message, frame: frame) else {
            completionHandler()
            return
        }
        dialog.addAction(UIAlertAction(title: "OK", style: .default) { _ in completionHandler() })
        present(dialog, animated: true)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        guard let dialog = makeDialog(message: message, frame: frame) else {
            completionHandler(false)
            return
        }
        dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completionHandler(false) })
        dialog.addAction(UIAlertAction(title: "OK", style: .default) { _ in completionHandler(true) })
        present(dialog, animated: true)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        guard let dialog = makeDialog(message: prompt, frame: frame) else {
            completionHandler(nil)
            return
        }
        dialog.addTextField { $0.text = defaultText }
        dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completionHandler(nil) })
        dialog.addAction(UIAlertAction(title: "OK", style: .default) { [weak dialog] _ in
            completionHandler(dialog?.textFields?.first?.text)
        })
        present(dialog, animated: true)
    }

    private func makeDialog(message: String, frame: WKFrameInfo) -> UIAlertController? {
        guard viewIfLoaded?.window != nil, presentedViewController == nil else { return nil }
        finishInitialLoad()
        return UIAlertController(title: frame.securityOrigin.host, message: message, preferredStyle: .alert)
    }
}

extension StartupWebViewController: WKDownloadDelegate {
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        download.delegate = self
    }

    func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        download.delegate = self
    }

    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse,
                  suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        let folder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            let name = (suggestedFilename as NSString).lastPathComponent
            let destination = folder.appendingPathComponent(["", ".", ".."].contains(name) ? "Download" : name)
            downloads[download] = destination
            completionHandler(destination)
        } catch {
            completionHandler(nil)
        }
    }

    func downloadDidFinish(_ download: WKDownload) {
        guard let file = downloads.removeValue(forKey: download) else { return }
        completedDownloads.append(file)
        offerCompletedDownloads()
    }

    func download(_ download: WKDownload, didFailWithError error: Error, resumeData: Data?) {
        if let file = downloads.removeValue(forKey: download) {
            try? FileManager.default.removeItem(at: file.deletingLastPathComponent())
        }
        guard viewIfLoaded?.window != nil, presentedViewController == nil else { return }
        let dialog = UIAlertController(title: "Download failed", message: error.localizedDescription, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default))
        present(dialog, animated: true)
    }

    private func offerCompletedDownloads() {
        guard !completedDownloads.isEmpty, viewIfLoaded?.window != nil, presentedViewController == nil else { return }
        let files = completedDownloads
        completedDownloads.removeAll()
        let sheet = UIActivityViewController(activityItems: files, applicationActivities: nil)
        sheet.popoverPresentationController?.sourceView = view
        sheet.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 1, height: 1)
        sheet.completionWithItemsHandler = { [weak self] _, _, _, _ in
            for file in files { try? FileManager.default.removeItem(at: file.deletingLastPathComponent()) }
            self?.offerCompletedDownloads()
        }
        present(sheet, animated: true)
    }
}
