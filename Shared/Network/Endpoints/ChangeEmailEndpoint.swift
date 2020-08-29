 import Foundation

 public struct ChangeEmailEndpoint: Endpoint {
     public typealias Response = ChangeEmailResponse
     public var httpMethod: HttpMethod { .POST }
     public var path: String { "account/" }
     public var params: [String : Any]? {
         [
             "username": username,
             "newEmail": email,
             "currentPassword": currentPassword
         ]
     }

     public var authenticated: Bool { true }

     let username: String
     let currentPassword: String
     let email: String

     public init(
        username: String,
        currentPassword: String,
        email: String
     ) {
         self.username = username
         self.currentPassword = currentPassword
         self.email = email
     }
 }

 public struct ChangeEmailResponse: Codable {
     let message: String
 }
