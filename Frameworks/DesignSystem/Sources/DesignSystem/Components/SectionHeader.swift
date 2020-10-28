import SwiftUI

public struct SectionHeader<Detail> {
    let title: String
    let detail: Detail
}

extension SectionHeader: View where Detail : View {

    public init(title: String, @ViewBuilder detail: () -> Detail) {
        self.title = title
        self.detail = detail()
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(.system(.title2, design: .rounded))
                .bold()
                .foregroundColor(Color(.label))
                .listRowInsets(.none)
            Spacer()
            detail
                .font(.system(.title3, design: .rounded))
        }
        .textCase(.none)
        .listRowInsets(EdgeInsets())
    }
}

extension SectionHeader where Detail == EmptyView {
    public init(title: String) {
        self.title = title
        self.detail = EmptyView()
    }
}

extension SectionHeader where Detail == AnyView {
    public init(title: String, buttonTitle: String, action: @escaping () -> Void) {
        self.title = title
        self.detail = Button(action: action, label: {
            Text(buttonTitle)
                .font(.system(.footnote, design: .rounded))
        })
        .accentColor(.accentColor)
        .foregroundColor(.accentColor)
        .eraseToAnyView()
    }

    public init(title: String, buttonImage: Image, action: @escaping () -> Void) {
        self.title = title
        self.detail = Button(action: action, label: {
            buttonImage
        })
        .accentColor(.accentColor)
        .foregroundColor(.accentColor)
        .eraseToAnyView()
    }
}

public struct EditableSectionHeader<LeadingDetail, Detail> {
    let leadingDetail: LeadingDetail
    let title: Binding<String>
    let placeholder: String
    let disabled: Bool
    let detail: Detail
}


extension EditableSectionHeader: View where LeadingDetail : View, Detail : View {

    public init(
        title: Binding<String>,
        placeholder: String,
        disabled: Bool = false,
        @ViewBuilder leadingDetail: () -> LeadingDetail,
        @ViewBuilder detail: () -> Detail
    ) {
        self.title = title
        self.placeholder = placeholder
        self.disabled = disabled
        self.leadingDetail = leadingDetail()
        self.detail = detail()
    }

    public var body: some View {
        HStack {
            leadingDetail
            TextField(placeholder, text: title)
                .font(Font.system(.title2, design: .rounded).bold())
                .foregroundColor(Color(.label))
                .disabled(disabled)
            Spacer()
            detail
                .font(.system(.title3, design: .rounded))
        }
        .textCase(.none)
        .listRowInsets(EdgeInsets())
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SectionHeader(title: "Title")
                .padding()
                .previewDisplayName("Default preview")
            SectionHeader(title: "Title")
                .padding()
                .previewDisplayName("Default dark preview")
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)

            SectionHeader(title: "Title", buttonTitle: "See more") {}
                .padding()
                .previewDisplayName("Default detail button text preview")
            SectionHeader(title: "Title", buttonTitle: "See more") {}
                .padding()
                .previewDisplayName("Default detail button text dark preview")
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)

            SectionHeader(title: "Title", buttonImage: Image(systemName: "plus.circle.fill")) {}
                .padding()
                .previewDisplayName("Default detail button image preview")
            SectionHeader(title: "Title", buttonImage: Image(systemName: "plus.circle.fill")) {}
                .padding()
                .previewDisplayName("Default detail button image dark preview")
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
