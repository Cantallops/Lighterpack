import Foundation
import Combine
import Entities
import os.log

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let sync = Logger(subsystem: subsystem, category: "SyncEngine")
}

public enum SyncStatus {
    case idle
    case updating
    case updated(Date)
    case error(Error, Date)
}

class SyncEngine: ObservableObject {
    @Published var localRepo: LocalRepository
    let remoteRepo: RemoteRepository

    private var timer = Timer.publish(every: 60*5, on: .current, in: .common)
    private var started = false

    @Published private(set) var status: SyncStatus = .idle {
        didSet {
            switch status {
            case .idle, .updating: break
            case .error, .updated: resetTimer()
            }
        }
    }
    private var isLoading: Bool {
        if case .updating = status { return true }
        return false
    }

    private var timerCancellable: AnyCancellable?
    private var syncCancellables: Set<AnyCancellable> = .init()

    public init(
        localRepo: Published<LocalRepository>,
        remoteRepo: RemoteRepository
    ) {
        self._localRepo = localRepo
        self.remoteRepo = remoteRepo
    }

    func start() {
        guard !started else { return }
        started = true
        sync()
    }

    func resetTimer() {
        Logger.sync.info("Timer started!")
        timerCancellable = timer
            .autoconnect()
            .sink { [weak self] _ in
                self?.sync()
            }
    }

    func stopTimer() {
        Logger.sync.info("Timer stoped!")
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    func sync(forced: Bool = false) {
        Logger.sync.info("\(forced ? "Forced start" : "Start")")
        stopTimer()
        if case .updating = status { return }
        status = .updating
        remoteRepo
            .getInfo()
            .receive(on: DispatchQueue.global(qos: .utility))
            .sink { [weak self] result in
                switch result {
                case .finished: break
                case .failure(let error):
                    Logger.sync.error("Fail on fetching from repo \(error.localizedDescription)")
                    self?.status = .error(error, .init())
                }
            } receiveValue: { [weak self] response in
                self?.syncLocal(response)
            }.store(in: &syncCancellables)
    }
}

extension SyncEngine {
    func syncLocal(_ response: LighterPackResponse) {
        let localSyncToken = localRepo.syncToken
        let remoteSyncToken = response.syncToken
        if remoteSyncToken > localSyncToken {
            updateLocal(response)
        } else if localRepo.hasChanges {
            updateRemote(library: localRepo.library)
        } else {
            Logger.sync.info("No updates")
            status = .updated(.init())
        }
    }

    func updateLocal(_ response: LighterPackResponse) {
        Logger.sync.info("Updating local")
        localRepo.originalLibrary = response.library
        localRepo.username = response.username
        localRepo.syncToken = response.syncToken
        localRepo.library = response.library
        localRepo.recompute()
        status = .updated(.init())
        Logger.sync.info("Updated!")
    }

    func updateRemote(library: Library) {
        Logger.sync.info("Updating remote")
        remoteRepo.update(library: library)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    Logger.sync.info("Remote updated!")
                case .failure(let error):
                    Logger.sync.error("Fail on updating repo \(error.localizedDescription)")
                    self?.status = .error(error, .init())
                }
            }, receiveValue: { [weak self] response in
                self?.updateLocal(response)
            })
            .store(in: &syncCancellables)
    }
}
