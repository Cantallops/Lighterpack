import Foundation
import Entities
import Combine

public class MockLighterPackRemoteRepository: RemoteRepository {

    enum MockError: Error {
        case mock
    }
    var library: Library = .init(
        version: "Mocked",
        totalUnit: .kg,
        itemUnit: .g,
        defaultListId: 0,
        sequence: 0,
        showSidebar: true,
        currencySymbol: "$",
        items: (0...32).map {
            Item(
                id: $0,
                name: "Item's name \($0)",
                description: "Item's description",
                weight: 10000,
                authorUnit: .kg,
                price: 10,
                image: "",
                imageUrl: "",
                url: ""
            )
        },
        categories: (0...4).map { id in
            Entities.Category(
                id: id,
                name: "Category \(id)",
                categoryItems: (0...8).map {
                    CategoryItem(
                        qty: 1,
                        worn: false,
                        consumable: false,
                        star: .none,
                        itemId: $0+4+id,
                        price: 0,
                        weight: 0
                    )
                },
                subtotalWeight: 0,
                subtotalWornWeight: 0,
                subtotalConsumableWeight: 0,
                subtotalPrice: 0,
                subtotalWornPrice: 0,
                subtotalConsumablePrice: 0,
                subtotalQty: 0,
                subtotalWornQty: 0,
                subtotalConsumableQty: 0,
                activeHover: false,
                displayColor: nil,
                color: nil
            )
        },
        lists: (0...3).map {
            return List(
                id: $0,
                name: "List \($0)",
                categoryIds: [0, 1, 2, 3],
                description: "Description",
                externalId: "",
                totalWeight: 10,
                totalWornWeight: 0,
                totalConsumableWeight: 0,
                totalBaseWeight: 10,
                totalPackWeight: 10,
                totalPrice: 10,
                totalConsumablePrice: 0,
                totalWornPrice: 0,
                totalQty: 0
            )
        },
        optionalFields: .init()
    )

    public init() {}

    public func getInfo() -> AnyPublisher<LighterPackResponse, Error> {
        Future { promise in
            promise(.success(LighterPackResponse(username: "Mock", library: self.library, syncToken: 3)))
        }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .delay(for: 5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    public func update(library: Library) -> AnyPublisher<LighterPackResponse, Error> {

            Future { promise in
                self.library = library
                promise(.success(LighterPackResponse(username: "Mock", library: self.library, syncToken: 3)))
            }
                .subscribe(on: DispatchQueue.global(qos: .background))
                .eraseToAnyPublisher()
    }


    public func login(username: String, password: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }
    public func logout(username: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }
    public func register(email: String, username: String, password: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }
    public func changeEmail(with email: String, ofUsername usernam: String, password: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }
    public func forgotPassword(ofUsername username: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }
    public func changePassword(ofUsername username: String, password: String, newPassword: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }
    public func deleteAccount(username: String, password: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }
}
