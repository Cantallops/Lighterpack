import SwiftUI

public extension View {
    @inlinable func removeListRowInsets() -> some View {
        self
            .listRowInsets(.init())
    }
}
