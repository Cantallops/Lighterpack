import SwiftUI
import Combine
import DesignSystem

class ImageLoader: ObservableObject {

    enum Status {
        case downloading
        case downloaded(UIImage)
        case error(Error?)
    }

    @Published var status: Status = .downloading

    private var cancellables: Set<AnyCancellable> = .init()

    func load(url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map {
                guard let image = UIImage(data: $0.data) else {
                    return Status.error(nil)
                }
                return Status.downloaded(image)
            }
            .replaceError(with: Status.error(nil))
            .receive(on: DispatchQueue.main)
            .assign(to: \.status, on: self)
            .store(in: &cancellables)
    }
}

struct NetworkImage<Placeholder: View>: View {
    @StateObject private var loader = ImageLoader()
    private let placeholder: Placeholder
    private let url: URL

    init(url: URL, placeholder: Placeholder) {
        self.placeholder = placeholder
        self.url = url
    }
    var body: some View {
        image
            .onAppear{
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

extension NetworkImage where Placeholder == AnyView {
    init(url: URL) {
        self.placeholder = Rectangle().foregroundColor(Color(.secondarySystemFill)).eraseToAnyView()
        self.url = url
    }
}
