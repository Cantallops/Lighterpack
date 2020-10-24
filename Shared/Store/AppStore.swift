import Foundation
import Combine

final class AppStore: ObservableObject {

    let lighterPackAccess: LighterPackAccess
    let sessionStore: SessionStore
    let libraryStore: LibraryStore
    let settingsStore: SettingsStore

    private var fetcher: AnyCancellable?
    private var cancellables: [AnyCancellable] = []

    init(
        lighterPackAccess: LighterPackAccess = .init(),
        userDefaults: UserDefaults = .standard
    ) {
        let sessionStore = SessionStore(networkAccess: lighterPackAccess, userDefaults: userDefaults)
        self.lighterPackAccess = lighterPackAccess
        self.sessionStore = sessionStore
        self.libraryStore = .init()
        self.settingsStore = .init(userDefaults: userDefaults)

        self.sessionStore.cookie.publisher
            .sink { _ in
                self.fetch()
            }.store(in: &cancellables)
    }
}


extension AppStore {

    func fetch() {
        guard sessionStore.isLoggedIn else { return }
        if let cancellable = fetcher {
            cancellable.cancel()
        }
        fetcher = lighterPackAccess.request(RetrieveInfoEndpoint())
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] result in
                do {
                    try self?.sync(result)
                } catch let error as NSError {
                    print(error)
                }
            })
    }

    private func sync(_ data: LighterPackResponse) throws {
        sessionStore.username = data.username
        sessionStore.syncToken = data.syncToken
        let library = data.library

        sessionStore.version = library.version

        settingsStore.totalUnit = library.totalUnit
        settingsStore.itemUnit = library.itemUnit
        settingsStore.defaultListId = library.defaultListId
        settingsStore.sequence = library.sequence
        settingsStore.showSidebar = library.showSidebar
        settingsStore.currencySymbol = library.currencySymbol
        settingsStore.showConsumable = library.optionalFields.consumable
        settingsStore.showWorn = library.optionalFields.worn
        settingsStore.showImages = library.optionalFields.images
        settingsStore.showListDescription = library.optionalFields.listDescription
        settingsStore.showPrice = library.optionalFields.price

        libraryStore.update(with: library)
    }
}
