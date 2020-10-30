import SwiftUI
import Combine
import DesignSystem

struct AlertFeedback {}
struct NonIntrusiveFeedback: Identifiable {

    enum Style {
        case info
        case warning
        case error
        case success
    }

    let id: UUID = .init()
    let time: TimeInterval = 3
    let message: String
    let style: Style
}

final class VisualFeedbackState: ObservableObject {

    var cancellables: Set<AnyCancellable> = .init()

    @Published fileprivate var nonIntrusiveFeedback: [NonIntrusiveFeedback] = []
    private var timers: [Timer] = []

    init() {}

    func notify(_ feedback: NonIntrusiveFeedback) {
        nonIntrusiveFeedback.append(feedback)
        Timer.scheduledTimer(withTimeInterval: feedback.time, repeats: false) { [weak self] _ in
            self?.nonIntrusiveFeedback.removeAll(where: { $0.id == feedback.id })
        }
    }

}

struct FeedbackView<V: View>: View {
    @StateObject var state: VisualFeedbackState = .init()

    var view: V

    var body: some View {
        ZStack {
            view
                .zIndex(1)
            VStack {
                Spacer()
                ForEach(state.nonIntrusiveFeedback) { feedback in
                    NonIntrusiveFeedbackView(feedback: feedback)
                        .cornerRadius(4)
                        .padding(.horizontal)
                        .padding(.top)
                        .transition(
                            .slide
                        )
                        .animation(.easeInOut(duration: 0.4))
                }
            }.zIndex(9)
        }
        .environmentObject(state)
    }
}

struct NonIntrusiveFeedbackView: View {
    let feedback: NonIntrusiveFeedback

    var body: some View {
        Text(feedback.message)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .foregroundColor(textColor)
    }

    var baseColor: Color {
        switch feedback.style {
        case .info: return .systemBlue
        case .warning: return .systemYellow
        case .error: return .systemRed
        case .success: return .systemGreen
        }
    }

    var backgroundColor: Color {
        baseColor
    }
    var textColor: Color {
        baseColor.darker(by: 0.5)
    }
}

extension View {
    func receiveVisualFeedback() -> some View {
        FeedbackView(view: self)
    }
}
