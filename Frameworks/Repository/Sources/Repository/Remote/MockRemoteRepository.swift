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
        sequence: 600,
        showSidebar: true,
        currencySymbol: "$",
        items: (0...200).map {
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
        categories: (0...20).map { id in
            Entities.Category(
                id: id,
                name: "Category \(id)",
                categoryItems: (0...8).map {
                    CategoryItem(
                        qty: $0%2 == 0 ? 1 : 2,
                        worn: $0%3 == 1,
                        consumable: $0%3 != 1,
                        star: .none,
                        itemId: $0+(9*id),
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
                color: CategoryColor(r: id*50%255, g: id*10%255, b: id*5%255)
            )
        },
        lists: (0...4).map { id in
            return List(
                id: id,
                name: "List \(id)",
                categoryIds: (0...4).map { $0 + (4 * id) },
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

    public func getInfo(cookie: String) -> AnyPublisher<LighterPackResponse, Error> {
        Future { promise in
            promise(.success(LighterPackResponse(username: "Mock", library: self.library, syncToken: 3)))
        }
            .subscribe(on: DispatchQueue.global(qos: .background))
            //.delay(for: 5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    public func update(username: String, library: Library, syncToken: Int, cookie: String) -> AnyPublisher<Int, Error> {
            Future { promise in
                self.library = library
                promise(.success(3))
            }
                .subscribe(on: DispatchQueue.global(qos: .background))
                .eraseToAnyPublisher()
    }


    public func login(username: String, password: String) -> AnyPublisher<String, Error> {
        Future { promise in promise(.success("cookie"))}
            .subscribe(on: DispatchQueue.global(qos: .background))
            .delay(for: 5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    public func logout(username: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }
    public func register(email: String, username: String, password: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }
    public func changeEmail(with email: String, ofUsername username: String, password: String, cookie: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }
    public func forgotPassword(ofUsername username: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }
    public func changePassword(ofUsername username: String, password: String, newPassword: String, cookie: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }
    public func deleteAccount(username: String, password: String, cookie: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }
}
