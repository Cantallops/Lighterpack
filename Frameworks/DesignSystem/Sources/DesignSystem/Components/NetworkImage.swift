import SwiftUI
import Combine
import os.log

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let imageLoader = Logger(subsystem: subsystem, category: "ImageLoader")
}

public struct NetworkImage<Placeholder: View>: View {
    private let placeholder: Placeholder
    private let url: URL

    public init(url: URL, placeholder: Placeholder) {
        self.placeholder = placeholder
        self.url = url
    }

    public var body: some View {
        AsyncImage(url: url) { image in
            image.resizable()
        } placeholder: {
            placeholder
        }
    }
}

public extension NetworkImage where Placeholder == AnyView {
    init(url: URL) {
        self.placeholder = Rectangle().foregroundColor(.secondarySystemFill).eraseToAnyView()
        self.url = url
    }
}
