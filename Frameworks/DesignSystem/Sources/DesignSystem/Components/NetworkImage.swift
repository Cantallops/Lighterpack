import SwiftUI
import Combine
import os.log

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let imageLoader = Logger(subsystem: subsystem, category: "ImageLoader")
}

class ImageLoader: ObservableObject {
    private let logger: Logger = .imageLoader

    enum Status {
        case downloading
        case downloaded(UIImage)
        case error(Error?)
    }

    @Published var status: Status = .downloading

    private var cancellables: Set<AnyCancellable> = .init()

    func load(url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .mapError { [weak self] error -> Error in
                self?.logger.error("❌ Load image \(url)")
                return error
            }
            .map { [weak self] result in
                guard let image = UIImage(data: result.data) else {
                    self?.logger.error("❌ Load image \(url)")
                    return Status.error(nil)
                }
                self?.logger.info("✅ Load image \(url)")
                return Status.downloaded(image)
            }
            .replaceError(with: Status.error(nil))
            .receive(on: DispatchQueue.main)
            .assign(to: \.status, on: self)
            .store(in: &cancellables)
    }
}

public struct NetworkImage<Placeholder: View>: View {
    @StateObject private var loader = ImageLoader()
    private let placeholder: Placeholder
    private let url: URL

    public init(url: URL, placeholder: Placeholder) {
        self.placeholder = placeholder
        self.url = url
    }

    public var body: some View {
        image
            .onFirstAppear {
                loader.load(url: url)
            }
    }

    private var image: some View {
        Group {
            switch loader.status {
            case .downloaded(let image):
                Image(uiImage: image)
                    .resizable()
            case .error:
                ZStack {
                    placeholder
                    Image(systemName: "xmark.octagon.fill")
                        .renderingMode(.original)
                }
            case .downloading:
                ZStack {
                    placeholder
                    ProgressView()
                }
            }
        }
    }
}

public extension NetworkImage where Placeholder == AnyView {
    init(url: URL) {
        self.placeholder = Rectangle().foregroundColor(.secondarySystemFill).eraseToAnyView()
        self.url = url
    }
}
