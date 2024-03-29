import Foundation
import Combine
import Entities
import os.log

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let repo = Logger(subsystem: subsystem, category: "MainRepository")
}

public class Repository: ObservableObject {

    let syncEngine: SyncEngine
    let remoteRepo: RemoteRepository
    let logger: Logger = .repo

    @Published var localRepo: LocalRepository
    @Published public var syncStatus: SyncStatus = .idle
    public var lastUpdated: Date? { syncEngine.lastUpdated }

    private let syncSubject = PassthroughSubject<(), Never>()

    internal var cancellables: Set<AnyCancellable> = .init()
    public var isPlaceholder: Bool { localRepo.library.isPlaceholder }

    public init(
        localRepo: LocalRepository = AppLocalRepository(),
        remoteRepo: RemoteRepository = AppRemoteRepository()
    ) {
        self.localRepo = localRepo
        self.remoteRepo = remoteRepo
        self.syncEngine = .init(localRepo: _localRepo, remoteRepo: remoteRepo)
    }

    public func setUp() {
        syncEngine.$status
            .receive(on: DispatchQueue.main)
            .assign(to: &$syncStatus)

        syncSubject
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.syncEngine.sync()
            }
            .store(in: &cancellables)

        syncEngine.start()
    }

    public func forceSync() {
        sync(forced: true)
    }

    public func sync(forced: Bool = false) {
        if forced {
            syncEngine.sync(forced: true)
            return
        }
        syncSubject.send(())
    }

}
