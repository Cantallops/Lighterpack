import SwiftUI
import LinkPresentation

public struct LinkPreview: View {
    enum Status {
        case loading
        case loaded(LPLinkMetadata)
        case loadError(Error?)
        case invalidURL
        case noURL
    }
    @State private var status: Status = .loading
    let link: String

    public init(link: String) {
        self.link = link
    }

    public var body: some View {
        Group {
            switch status {
            case .loading:
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
            case .loaded(let metadata):
                LinkView(metadata: metadata)
            case .loadError:
                HStack {
                    Spacer()
                    Text("URL couldn't be loaded")
                        .foregroundColor(Color(.systemRed))
                        .font(.system(.footnote, design: .rounded))
                    Button("Try again") {
                        load()
                    }
                    Spacer()
                }
            case .invalidURL:
                HStack {
                    Spacer()
                    Text("Invalid url")
                        .foregroundColor(Color(.systemRed))
                        .font(.system(.footnote, design: .rounded))
                    Spacer()
                }
            case .noURL:
                Text("")
            }
        }.onFirstAppear {
            load()
        }
    }
}

private extension LinkPreview {

    func load() {
        status = .loading
        guard !link.isEmpty else {
            status = .noURL
            return
        }
        var checkedLink = link
        if !checkedLink.lowercased().hasPrefix("https://") &&
            !checkedLink.lowercased().hasPrefix("http://") {
            checkedLink = "https://\(checkedLink)"
        }

        guard let url = URL(string: checkedLink) else {
            status = .invalidURL
            return
        }

        loadMetadata(link: url)
    }

    func loadMetadata(link: URL) {
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: link) { (metadata, error) in
            if let metadata = metadata {
                status = .loaded(metadata)
            } else {
                status = .loadError(error)
            }
        }
    }
}

private struct LinkView: UIViewRepresentable {
    var metadata: LPLinkMetadata

    func makeUIView(context: Context) -> LPLinkView {
        let linkView = LPLinkView(metadata: metadata)
        return linkView
    }

    func updateUIView(_ uiView: LPLinkView, context: Context) {

    }
}
