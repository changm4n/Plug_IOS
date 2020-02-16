//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct UserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(role: Role, userId: String, name: String, password: String, profileImageUrl: Swift.Optional<String?> = nil, phoneNumber: Swift.Optional<String?> = nil) {
    graphQLMap = ["role": role, "userId": userId, "name": name, "password": password, "profileImageUrl": profileImageUrl, "phoneNumber": phoneNumber]
  }

  public var role: Role {
    get {
      return graphQLMap["role"] as! Role
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "role")
    }
  }

  public var userId: String {
    get {
      return graphQLMap["userId"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userId")
    }
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var password: String {
    get {
      return graphQLMap["password"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
    }
  }

  public var profileImageUrl: Swift.Optional<String?> {
    get {
      return graphQLMap["profileImageUrl"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "profileImageUrl")
    }
  }

  public var phoneNumber: Swift.Optional<String?> {
    get {
      return graphQLMap["phoneNumber"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }
}

public enum Role: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case teacher
  case parent
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "TEACHER": self = .teacher
      case "PARENT": self = .parent
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .teacher: return "TEACHER"
      case .parent: return "PARENT"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Role, rhs: Role) -> Bool {
    switch (lhs, rhs) {
      case (.teacher, .teacher): return true
      case (.parent, .parent): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [Role] {
    return [
      .teacher,
      .parent,
    ]
  }
}

public struct UserUpdateInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(role: Role, name: String, profileImageUrl: Swift.Optional<String?> = nil, phoneNumber: Swift.Optional<String?> = nil) {
    graphQLMap = ["role": role, "name": name, "profileImageUrl": profileImageUrl, "phoneNumber": phoneNumber]
  }

  public var role: Role {
    get {
      return graphQLMap["role"] as! Role
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "role")
    }
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var profileImageUrl: Swift.Optional<String?> {
    get {
      return graphQLMap["profileImageUrl"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "profileImageUrl")
    }
  }

  public var phoneNumber: Swift.Optional<String?> {
    get {
      return graphQLMap["phoneNumber"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }
}

public struct UserWhereUniqueInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: Swift.Optional<GraphQLID?> = nil, userId: Swift.Optional<String?> = nil) {
    graphQLMap = ["id": id, "userId": userId]
  }

  public var id: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["id"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var userId: Swift.Optional<String?> {
    get {
      return graphQLMap["userId"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userId")
    }
  }
}

public enum Platform: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case ios
  case android
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "IOS": self = .ios
      case "ANDROID": self = .android
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .ios: return "IOS"
      case .android: return "ANDROID"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Platform, rhs: Platform) -> Bool {
    switch (lhs, rhs) {
      case (.ios, .ios): return true
      case (.android, .android): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [Platform] {
    return [
      .ios,
      .android,
    ]
  }
}

public enum UserType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case kakao
  case email
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "KAKAO": self = .kakao
      case "EMAIL": self = .email
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .kakao: return "KAKAO"
      case .email: return "EMAIL"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: UserType, rhs: UserType) -> Bool {
    switch (lhs, rhs) {
      case (.kakao, .kakao): return true
      case (.email, .email): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [UserType] {
    return [
      .kakao,
      .email,
    ]
  }
}

public enum MutationType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case created
  case updated
  case deleted
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CREATED": self = .created
      case "UPDATED": self = .updated
      case "DELETED": self = .deleted
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .created: return "CREATED"
      case .updated: return "UPDATED"
      case .deleted: return "DELETED"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: MutationType, rhs: MutationType) -> Bool {
    switch (lhs, rhs) {
      case (.created, .created): return true
      case (.updated, .updated): return true
      case (.deleted, .deleted): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [MutationType] {
    return [
      .created,
      .updated,
      .deleted,
    ]
  }
}

public final class SignInMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation SignIn($userId: String!, $password: String!) {
      signin(userId: $userId, password: $password) {
        __typename
        token
      }
    }
    """

  public let operationName = "SignIn"

  public var userId: String
  public var password: String

  public init(userId: String, password: String) {
    self.userId = userId
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["userId": userId, "password": password]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("signin", arguments: ["userId": GraphQLVariable("userId"), "password": GraphQLVariable("password")], type: .nonNull(.object(Signin.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(signin: Signin) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "signin": signin.resultMap])
    }

    public var signin: Signin {
      get {
        return Signin(unsafeResultMap: resultMap["signin"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "signin")
      }
    }

    public struct Signin: GraphQLSelectionSet {
      public static let possibleTypes = ["TokenPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("token", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String) {
        self.init(unsafeResultMap: ["__typename": "TokenPayload", "token": token])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }
    }
  }
}

public final class SignUpMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation SignUp($data: UserInput!) {
      signup(data: $data) {
        __typename
        name
      }
    }
    """

  public let operationName = "SignUp"

  public var data: UserInput

  public init(data: UserInput) {
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("signup", arguments: ["data": GraphQLVariable("data")], type: .nonNull(.object(Signup.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(signup: Signup) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "signup": signup.resultMap])
    }

    public var signup: Signup {
      get {
        return Signup(unsafeResultMap: resultMap["signup"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "signup")
      }
    }

    public struct Signup: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String) {
        self.init(unsafeResultMap: ["__typename": "User", "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}

public final class IsMemeberQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query isMemeber($userId: String!) {
      users(where: {userId: $userId}) {
        __typename
        userId
      }
    }
    """

  public let operationName = "isMemeber"

  public var userId: String

  public init(userId: String) {
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("users", arguments: ["where": ["userId": GraphQLVariable("userId")]], type: .nonNull(.list(.nonNull(.object(User.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(users: [User]) {
      self.init(unsafeResultMap: ["__typename": "Query", "users": users.map { (value: User) -> ResultMap in value.resultMap }])
    }

    public var users: [User] {
      get {
        return (resultMap["users"] as! [ResultMap]).map { (value: ResultMap) -> User in User(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: User) -> ResultMap in value.resultMap }, forKey: "users")
      }
    }

    public struct User: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("userId", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(userId: String) {
        self.init(unsafeResultMap: ["__typename": "User", "userId": userId])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var userId: String {
        get {
          return resultMap["userId"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "userId")
        }
      }
    }
  }
}

public final class ChangePwMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation changePW($userId: String!, $old: String!, $new: String!) {
      updateNewPassword(email: $userId, newPassword: $new, oldPassword: $old) {
        __typename
        name
      }
    }
    """

  public let operationName = "changePW"

  public var userId: String
  public var old: String
  public var new: String

  public init(userId: String, old: String, new: String) {
    self.userId = userId
    self.old = old
    self.new = new
  }

  public var variables: GraphQLMap? {
    return ["userId": userId, "old": old, "new": new]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateNewPassword", arguments: ["email": GraphQLVariable("userId"), "newPassword": GraphQLVariable("new"), "oldPassword": GraphQLVariable("old")], type: .object(UpdateNewPassword.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateNewPassword: UpdateNewPassword? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateNewPassword": updateNewPassword.flatMap { (value: UpdateNewPassword) -> ResultMap in value.resultMap }])
    }

    public var updateNewPassword: UpdateNewPassword? {
      get {
        return (resultMap["updateNewPassword"] as? ResultMap).flatMap { UpdateNewPassword(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "updateNewPassword")
      }
    }

    public struct UpdateNewPassword: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String) {
        self.init(unsafeResultMap: ["__typename": "User", "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}

public final class UpdateUserMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation updateUser($data: UserUpdateInput!, $where: UserWhereUniqueInput!) {
      updateUser(where: $where, data: $data) {
        __typename
        name
      }
    }
    """

  public let operationName = "updateUser"

  public var data: UserUpdateInput
  public var `where`: UserWhereUniqueInput

  public init(data: UserUpdateInput, `where`: UserWhereUniqueInput) {
    self.data = data
    self.`where` = `where`
  }

  public var variables: GraphQLMap? {
    return ["data": data, "where": `where`]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateUser", arguments: ["where": GraphQLVariable("where"), "data": GraphQLVariable("data")], type: .object(UpdateUser.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateUser: UpdateUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateUser": updateUser.flatMap { (value: UpdateUser) -> ResultMap in value.resultMap }])
    }

    public var updateUser: UpdateUser? {
      get {
        return (resultMap["updateUser"] as? ResultMap).flatMap { UpdateUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "updateUser")
      }
    }

    public struct UpdateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String) {
        self.init(unsafeResultMap: ["__typename": "User", "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}

public final class CreateRoomMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation createRoom($roomName: String!, $userId: ID!, $year: DateTime!) {
      createChatRoom(data: {name: $roomName, userIds: [$userId], chatRoomAt: $year}) {
        __typename
        inviteCode
      }
    }
    """

  public let operationName = "createRoom"

  public var roomName: String
  public var userId: GraphQLID
  public var year: String

  public init(roomName: String, userId: GraphQLID, year: String) {
    self.roomName = roomName
    self.userId = userId
    self.year = year
  }

  public var variables: GraphQLMap? {
    return ["roomName": roomName, "userId": userId, "year": year]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createChatRoom", arguments: ["data": ["name": GraphQLVariable("roomName"), "userIds": [GraphQLVariable("userId")], "chatRoomAt": GraphQLVariable("year")]], type: .nonNull(.object(CreateChatRoom.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createChatRoom: CreateChatRoom) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createChatRoom": createChatRoom.resultMap])
    }

    public var createChatRoom: CreateChatRoom {
      get {
        return CreateChatRoom(unsafeResultMap: resultMap["createChatRoom"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "createChatRoom")
      }
    }

    public struct CreateChatRoom: GraphQLSelectionSet {
      public static let possibleTypes = ["ChatRoom"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("inviteCode", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(inviteCode: String) {
        self.init(unsafeResultMap: ["__typename": "ChatRoom", "inviteCode": inviteCode])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var inviteCode: String {
        get {
          return resultMap["inviteCode"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "inviteCode")
        }
      }
    }
  }
}

public final class UpdateChatRoomMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation updateChatRoom($id: ID!, $newName: String!, $newYear: DateTime!) {
      updateChatRoom(id: $id, data: {name: $newName, chatRoomAt: $newYear}) {
        __typename
        id
      }
    }
    """

  public let operationName = "updateChatRoom"

  public var id: GraphQLID
  public var newName: String
  public var newYear: String

  public init(id: GraphQLID, newName: String, newYear: String) {
    self.id = id
    self.newName = newName
    self.newYear = newYear
  }

  public var variables: GraphQLMap? {
    return ["id": id, "newName": newName, "newYear": newYear]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateChatRoom", arguments: ["id": GraphQLVariable("id"), "data": ["name": GraphQLVariable("newName"), "chatRoomAt": GraphQLVariable("newYear")]], type: .nonNull(.object(UpdateChatRoom.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateChatRoom: UpdateChatRoom) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateChatRoom": updateChatRoom.resultMap])
    }

    public var updateChatRoom: UpdateChatRoom {
      get {
        return UpdateChatRoom(unsafeResultMap: resultMap["updateChatRoom"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "updateChatRoom")
      }
    }

    public struct UpdateChatRoom: GraphQLSelectionSet {
      public static let possibleTypes = ["ChatRoom"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "ChatRoom", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class WithdrawKidMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation withdrawKid($chatroomID: ID!, $userID: ID!, $kidName: String!) {
      withdrawChatRoomUser(id: $chatroomID, data: {userId: $userID, kidName: $kidName}) {
        __typename
        id
      }
    }
    """

  public let operationName = "withdrawKid"

  public var chatroomID: GraphQLID
  public var userID: GraphQLID
  public var kidName: String

  public init(chatroomID: GraphQLID, userID: GraphQLID, kidName: String) {
    self.chatroomID = chatroomID
    self.userID = userID
    self.kidName = kidName
  }

  public var variables: GraphQLMap? {
    return ["chatroomID": chatroomID, "userID": userID, "kidName": kidName]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("withdrawChatRoomUser", arguments: ["id": GraphQLVariable("chatroomID"), "data": ["userId": GraphQLVariable("userID"), "kidName": GraphQLVariable("kidName")]], type: .nonNull(.object(WithdrawChatRoomUser.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(withdrawChatRoomUser: WithdrawChatRoomUser) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "withdrawChatRoomUser": withdrawChatRoomUser.resultMap])
    }

    public var withdrawChatRoomUser: WithdrawChatRoomUser {
      get {
        return WithdrawChatRoomUser(unsafeResultMap: resultMap["withdrawChatRoomUser"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "withdrawChatRoomUser")
      }
    }

    public struct WithdrawChatRoomUser: GraphQLSelectionSet {
      public static let possibleTypes = ["ChatRoom"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "ChatRoom", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class SetOfficeMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation setOffice($crontab: String!) {
      upsertOfficePeriod(data: {crontab: $crontab}) {
        __typename
        crontab
      }
    }
    """

  public let operationName = "setOffice"

  public var crontab: String

  public init(crontab: String) {
    self.crontab = crontab
  }

  public var variables: GraphQLMap? {
    return ["crontab": crontab]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("upsertOfficePeriod", arguments: ["data": ["crontab": GraphQLVariable("crontab")]], type: .nonNull(.object(UpsertOfficePeriod.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(upsertOfficePeriod: UpsertOfficePeriod) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "upsertOfficePeriod": upsertOfficePeriod.resultMap])
    }

    public var upsertOfficePeriod: UpsertOfficePeriod {
      get {
        return UpsertOfficePeriod(unsafeResultMap: resultMap["upsertOfficePeriod"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "upsertOfficePeriod")
      }
    }

    public struct UpsertOfficePeriod: GraphQLSelectionSet {
      public static let possibleTypes = ["OfficePeriod"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("crontab", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(crontab: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "OfficePeriod", "crontab": crontab])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var crontab: String? {
        get {
          return resultMap["crontab"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "crontab")
        }
      }
    }
  }
}

public final class GetUserInfoQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query getUserInfo($id: ID!) {
      officePeriods(where: {user: {id: $id}}) {
        __typename
        crontab
      }
    }
    """

  public let operationName = "getUserInfo"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("officePeriods", arguments: ["where": ["user": ["id": GraphQLVariable("id")]]], type: .nonNull(.list(.nonNull(.object(OfficePeriod.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(officePeriods: [OfficePeriod]) {
      self.init(unsafeResultMap: ["__typename": "Query", "officePeriods": officePeriods.map { (value: OfficePeriod) -> ResultMap in value.resultMap }])
    }

    public var officePeriods: [OfficePeriod] {
      get {
        return (resultMap["officePeriods"] as! [ResultMap]).map { (value: ResultMap) -> OfficePeriod in OfficePeriod(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: OfficePeriod) -> ResultMap in value.resultMap }, forKey: "officePeriods")
      }
    }

    public struct OfficePeriod: GraphQLSelectionSet {
      public static let possibleTypes = ["OfficePeriod"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("crontab", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(crontab: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "OfficePeriod", "crontab": crontab])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var crontab: String? {
        get {
          return resultMap["crontab"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "crontab")
        }
      }
    }
  }
}

public final class GetUserInfoInStartQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query getUserInfoInStart($id: ID!, $userId: String!) {
      officePeriods(where: {user: {id: $id}}) {
        __typename
        crontab
      }
      messageSummaries(where: {OR: [{sender: {userId: $userId}}, {receiver: {userId: $userId}}]}) {
        __typename
        ...MessageSummaryApolloFragment
      }
    }
    """

  public let operationName = "getUserInfoInStart"

  public var queryDocument: String { return operationDefinition.appending(MessageSummaryApolloFragment.fragmentDefinition).appending(ChatRoomSummaryApolloFragment.fragmentDefinition).appending(UserApolloFragment.fragmentDefinition).appending(MessageApolloFragment.fragmentDefinition) }

  public var id: GraphQLID
  public var userId: String

  public init(id: GraphQLID, userId: String) {
    self.id = id
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["id": id, "userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("officePeriods", arguments: ["where": ["user": ["id": GraphQLVariable("id")]]], type: .nonNull(.list(.nonNull(.object(OfficePeriod.selections))))),
      GraphQLField("messageSummaries", arguments: ["where": ["OR": [["sender": ["userId": GraphQLVariable("userId")]], ["receiver": ["userId": GraphQLVariable("userId")]]]]], type: .nonNull(.list(.object(MessageSummary.selections)))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(officePeriods: [OfficePeriod], messageSummaries: [MessageSummary?]) {
      self.init(unsafeResultMap: ["__typename": "Query", "officePeriods": officePeriods.map { (value: OfficePeriod) -> ResultMap in value.resultMap }, "messageSummaries": messageSummaries.map { (value: MessageSummary?) -> ResultMap? in value.flatMap { (value: MessageSummary) -> ResultMap in value.resultMap } }])
    }

    public var officePeriods: [OfficePeriod] {
      get {
        return (resultMap["officePeriods"] as! [ResultMap]).map { (value: ResultMap) -> OfficePeriod in OfficePeriod(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: OfficePeriod) -> ResultMap in value.resultMap }, forKey: "officePeriods")
      }
    }

    public var messageSummaries: [MessageSummary?] {
      get {
        return (resultMap["messageSummaries"] as! [ResultMap?]).map { (value: ResultMap?) -> MessageSummary? in value.flatMap { (value: ResultMap) -> MessageSummary in MessageSummary(unsafeResultMap: value) } }
      }
      set {
        resultMap.updateValue(newValue.map { (value: MessageSummary?) -> ResultMap? in value.flatMap { (value: MessageSummary) -> ResultMap in value.resultMap } }, forKey: "messageSummaries")
      }
    }

    public struct OfficePeriod: GraphQLSelectionSet {
      public static let possibleTypes = ["OfficePeriod"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("crontab", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(crontab: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "OfficePeriod", "crontab": crontab])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var crontab: String? {
        get {
          return resultMap["crontab"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "crontab")
        }
      }
    }

    public struct MessageSummary: GraphQLSelectionSet {
      public static let possibleTypes = ["MessageSummary"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MessageSummaryApolloFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var messageSummaryApolloFragment: MessageSummaryApolloFragment {
          get {
            return MessageSummaryApolloFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class UploadFileMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation uploadFile($file: Upload!) {
      multipleUpload(files: [$file])
    }
    """

  public let operationName = "uploadFile"

  public var file: String

  public init(file: String) {
    self.file = file
  }

  public var variables: GraphQLMap? {
    return ["file": file]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("multipleUpload", arguments: ["files": [GraphQLVariable("file")]], type: .nonNull(.list(.nonNull(.scalar(String.self))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(multipleUpload: [String]) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "multipleUpload": multipleUpload])
    }

    public var multipleUpload: [String] {
      get {
        return resultMap["multipleUpload"]! as! [String]
      }
      set {
        resultMap.updateValue(newValue, forKey: "multipleUpload")
      }
    }
  }
}

public final class GetCronTabQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query getCronTab($id: ID!) {
      officePeriods(where: {user: {id: $id}}) {
        __typename
        crontab
      }
    }
    """

  public let operationName = "getCronTab"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("officePeriods", arguments: ["where": ["user": ["id": GraphQLVariable("id")]]], type: .nonNull(.list(.nonNull(.object(OfficePeriod.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(officePeriods: [OfficePeriod]) {
      self.init(unsafeResultMap: ["__typename": "Query", "officePeriods": officePeriods.map { (value: OfficePeriod) -> ResultMap in value.resultMap }])
    }

    public var officePeriods: [OfficePeriod] {
      get {
        return (resultMap["officePeriods"] as! [ResultMap]).map { (value: ResultMap) -> OfficePeriod in OfficePeriod(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: OfficePeriod) -> ResultMap in value.resultMap }, forKey: "officePeriods")
      }
    }

    public struct OfficePeriod: GraphQLSelectionSet {
      public static let possibleTypes = ["OfficePeriod"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("crontab", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(crontab: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "OfficePeriod", "crontab": crontab])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var crontab: String? {
        get {
          return resultMap["crontab"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "crontab")
        }
      }
    }
  }
}

public final class MyChatroomsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query MyChatrooms($userId: String) {
      chatRooms(where: {admins_some: {userId: $userId}}) {
        __typename
        ...ChatRoomApolloFragment
      }
    }
    """

  public let operationName = "MyChatrooms"

  public var queryDocument: String { return operationDefinition.appending(ChatRoomApolloFragment.fragmentDefinition).appending(UserApolloFragment.fragmentDefinition).appending(KidApolloFragment.fragmentDefinition) }

  public var userId: String?

  public init(userId: String? = nil) {
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("chatRooms", arguments: ["where": ["admins_some": ["userId": GraphQLVariable("userId")]]], type: .nonNull(.list(.nonNull(.object(ChatRoom.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(chatRooms: [ChatRoom]) {
      self.init(unsafeResultMap: ["__typename": "Query", "chatRooms": chatRooms.map { (value: ChatRoom) -> ResultMap in value.resultMap }])
    }

    public var chatRooms: [ChatRoom] {
      get {
        return (resultMap["chatRooms"] as! [ResultMap]).map { (value: ResultMap) -> ChatRoom in ChatRoom(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: ChatRoom) -> ResultMap in value.resultMap }, forKey: "chatRooms")
      }
    }

    public struct ChatRoom: GraphQLSelectionSet {
      public static let possibleTypes = ["ChatRoom"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ChatRoomApolloFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var chatRoomApolloFragment: ChatRoomApolloFragment {
          get {
            return ChatRoomApolloFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class MessageSummariesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query MessageSummaries($userId: String!) {
      messageSummaries(where: {OR: [{sender: {userId: $userId}}, {receiver: {userId: $userId}}]}) {
        __typename
        ...MessageSummaryApolloFragment
      }
    }
    """

  public let operationName = "MessageSummaries"

  public var queryDocument: String { return operationDefinition.appending(MessageSummaryApolloFragment.fragmentDefinition).appending(ChatRoomSummaryApolloFragment.fragmentDefinition).appending(UserApolloFragment.fragmentDefinition).appending(MessageApolloFragment.fragmentDefinition) }

  public var userId: String

  public init(userId: String) {
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("messageSummaries", arguments: ["where": ["OR": [["sender": ["userId": GraphQLVariable("userId")]], ["receiver": ["userId": GraphQLVariable("userId")]]]]], type: .nonNull(.list(.object(MessageSummary.selections)))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(messageSummaries: [MessageSummary?]) {
      self.init(unsafeResultMap: ["__typename": "Query", "messageSummaries": messageSummaries.map { (value: MessageSummary?) -> ResultMap? in value.flatMap { (value: MessageSummary) -> ResultMap in value.resultMap } }])
    }

    public var messageSummaries: [MessageSummary?] {
      get {
        return (resultMap["messageSummaries"] as! [ResultMap?]).map { (value: ResultMap?) -> MessageSummary? in value.flatMap { (value: ResultMap) -> MessageSummary in MessageSummary(unsafeResultMap: value) } }
      }
      set {
        resultMap.updateValue(newValue.map { (value: MessageSummary?) -> ResultMap? in value.flatMap { (value: MessageSummary) -> ResultMap in value.resultMap } }, forKey: "messageSummaries")
      }
    }

    public struct MessageSummary: GraphQLSelectionSet {
      public static let possibleTypes = ["MessageSummary"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MessageSummaryApolloFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var messageSummaryApolloFragment: MessageSummaryApolloFragment {
          get {
            return MessageSummaryApolloFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class ReadMessageMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation ReadMessage($chatroom: ID!, $sender: ID!, $receiver: ID!) {
      readMessage(chatRoomId: $chatroom, receiverId: $receiver, senderId: $sender) {
        __typename
        lastMessage {
          __typename
          text
        }
      }
    }
    """

  public let operationName = "ReadMessage"

  public var chatroom: GraphQLID
  public var sender: GraphQLID
  public var receiver: GraphQLID

  public init(chatroom: GraphQLID, sender: GraphQLID, receiver: GraphQLID) {
    self.chatroom = chatroom
    self.sender = sender
    self.receiver = receiver
  }

  public var variables: GraphQLMap? {
    return ["chatroom": chatroom, "sender": sender, "receiver": receiver]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("readMessage", arguments: ["chatRoomId": GraphQLVariable("chatroom"), "receiverId": GraphQLVariable("receiver"), "senderId": GraphQLVariable("sender")], type: .nonNull(.object(ReadMessage.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(readMessage: ReadMessage) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "readMessage": readMessage.resultMap])
    }

    public var readMessage: ReadMessage {
      get {
        return ReadMessage(unsafeResultMap: resultMap["readMessage"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "readMessage")
      }
    }

    public struct ReadMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["MessageSummary"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("lastMessage", type: .object(LastMessage.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(lastMessage: LastMessage? = nil) {
        self.init(unsafeResultMap: ["__typename": "MessageSummary", "lastMessage": lastMessage.flatMap { (value: LastMessage) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var lastMessage: LastMessage? {
        get {
          return (resultMap["lastMessage"] as? ResultMap).flatMap { LastMessage(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "lastMessage")
        }
      }

      public struct LastMessage: GraphQLSelectionSet {
        public static let possibleTypes = ["Message"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("text", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(text: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Message", "text": text])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var text: String? {
          get {
            return resultMap["text"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "text")
          }
        }
      }
    }
  }
}

public final class KakaoSignUpMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation kakaoSignUp($role: Role!, $userId: String!) {
      kakaoSignup(data: {kakaoUserId: $userId, role: $role}) {
        __typename
        userId
        id
      }
    }
    """

  public let operationName = "kakaoSignUp"

  public var role: Role
  public var userId: String

  public init(role: Role, userId: String) {
    self.role = role
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["role": role, "userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("kakaoSignup", arguments: ["data": ["kakaoUserId": GraphQLVariable("userId"), "role": GraphQLVariable("role")]], type: .nonNull(.object(KakaoSignup.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(kakaoSignup: KakaoSignup) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "kakaoSignup": kakaoSignup.resultMap])
    }

    public var kakaoSignup: KakaoSignup {
      get {
        return KakaoSignup(unsafeResultMap: resultMap["kakaoSignup"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "kakaoSignup")
      }
    }

    public struct KakaoSignup: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("userId", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(userId: String, id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "User", "userId": userId, "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var userId: String {
        get {
          return resultMap["userId"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "userId")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class KakaoSignInMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation kakaoSignIn($userId: String!) {
      kakaoSignin(kakaoUserId: $userId) {
        __typename
        token
      }
    }
    """

  public let operationName = "kakaoSignIn"

  public var userId: String

  public init(userId: String) {
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("kakaoSignin", arguments: ["kakaoUserId": GraphQLVariable("userId")], type: .nonNull(.object(KakaoSignin.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(kakaoSignin: KakaoSignin) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "kakaoSignin": kakaoSignin.resultMap])
    }

    public var kakaoSignin: KakaoSignin {
      get {
        return KakaoSignin(unsafeResultMap: resultMap["kakaoSignin"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "kakaoSignin")
      }
    }

    public struct KakaoSignin: GraphQLSelectionSet {
      public static let possibleTypes = ["TokenPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("token", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String) {
        self.init(unsafeResultMap: ["__typename": "TokenPayload", "token": token])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }
    }
  }
}

public final class RegisterPushKeyMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation registerPushKey($pushKey: String!) {
      registerNotification(data: {pushKey: $pushKey, platform: IOS}) {
        __typename
        pushKey
      }
    }
    """

  public let operationName = "registerPushKey"

  public var pushKey: String

  public init(pushKey: String) {
    self.pushKey = pushKey
  }

  public var variables: GraphQLMap? {
    return ["pushKey": pushKey]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("registerNotification", arguments: ["data": ["pushKey": GraphQLVariable("pushKey"), "platform": "IOS"]], type: .nonNull(.object(RegisterNotification.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(registerNotification: RegisterNotification) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "registerNotification": registerNotification.resultMap])
    }

    public var registerNotification: RegisterNotification {
      get {
        return RegisterNotification(unsafeResultMap: resultMap["registerNotification"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "registerNotification")
      }
    }

    public struct RegisterNotification: GraphQLSelectionSet {
      public static let possibleTypes = ["Notification"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("pushKey", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(pushKey: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Notification", "pushKey": pushKey])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var pushKey: String? {
        get {
          return resultMap["pushKey"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "pushKey")
        }
      }
    }
  }
}

public final class RemovePushKeyMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation removePushKey {
      removeNotification {
        __typename
        pushKey
      }
    }
    """

  public let operationName = "removePushKey"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("removeNotification", type: .nonNull(.object(RemoveNotification.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(removeNotification: RemoveNotification) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "removeNotification": removeNotification.resultMap])
    }

    public var removeNotification: RemoveNotification {
      get {
        return RemoveNotification(unsafeResultMap: resultMap["removeNotification"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "removeNotification")
      }
    }

    public struct RemoveNotification: GraphQLSelectionSet {
      public static let possibleTypes = ["Notification"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("pushKey", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(pushKey: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Notification", "pushKey": pushKey])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var pushKey: String? {
        get {
          return resultMap["pushKey"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "pushKey")
        }
      }
    }
  }
}

public final class RefreshEmailMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation refreshEmail($email: String!) {
      sendNewPasswordByEmail(email: $email)
    }
    """

  public let operationName = "refreshEmail"

  public var email: String

  public init(email: String) {
    self.email = email
  }

  public var variables: GraphQLMap? {
    return ["email": email]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("sendNewPasswordByEmail", arguments: ["email": GraphQLVariable("email")], type: .nonNull(.scalar(String.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(sendNewPasswordByEmail: String) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "sendNewPasswordByEmail": sendNewPasswordByEmail])
    }

    public var sendNewPasswordByEmail: String {
      get {
        return resultMap["sendNewPasswordByEmail"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "sendNewPasswordByEmail")
      }
    }
  }
}

public final class VersionQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query version {
      appVersions(where: {platform: IOS}) {
        __typename
        platform
        version
      }
    }
    """

  public let operationName = "version"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("appVersions", arguments: ["where": ["platform": "IOS"]], type: .nonNull(.list(.object(AppVersion.selections)))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(appVersions: [AppVersion?]) {
      self.init(unsafeResultMap: ["__typename": "Query", "appVersions": appVersions.map { (value: AppVersion?) -> ResultMap? in value.flatMap { (value: AppVersion) -> ResultMap in value.resultMap } }])
    }

    public var appVersions: [AppVersion?] {
      get {
        return (resultMap["appVersions"] as! [ResultMap?]).map { (value: ResultMap?) -> AppVersion? in value.flatMap { (value: ResultMap) -> AppVersion in AppVersion(unsafeResultMap: value) } }
      }
      set {
        resultMap.updateValue(newValue.map { (value: AppVersion?) -> ResultMap? in value.flatMap { (value: AppVersion) -> ResultMap in value.resultMap } }, forKey: "appVersions")
      }
    }

    public struct AppVersion: GraphQLSelectionSet {
      public static let possibleTypes = ["AppVersion"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("platform", type: .nonNull(.scalar(Platform.self))),
        GraphQLField("version", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(platform: Platform, version: String) {
        self.init(unsafeResultMap: ["__typename": "AppVersion", "platform": platform, "version": version])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var platform: Platform {
        get {
          return resultMap["platform"]! as! Platform
        }
        set {
          resultMap.updateValue(newValue, forKey: "platform")
        }
      }

      public var version: String {
        get {
          return resultMap["version"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "version")
        }
      }
    }
  }
}

public final class MessagesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query Messages($chatRoomId: ID!, $myId: String!, $userId: String!, $pageCount: Int!, $startCursor: String) {
      messages(where: {chatRoom: {id: $chatRoomId}, receivers_some: {userId_in: [$myId, $userId]}, sender: {userId_in: [$myId, $userId]}}, last: $pageCount, before: $startCursor) {
        __typename
        ...MessageApolloFragment
      }
    }
    """

  public let operationName = "Messages"

  public var queryDocument: String { return operationDefinition.appending(MessageApolloFragment.fragmentDefinition) }

  public var chatRoomId: GraphQLID
  public var myId: String
  public var userId: String
  public var pageCount: Int
  public var startCursor: String?

  public init(chatRoomId: GraphQLID, myId: String, userId: String, pageCount: Int, startCursor: String? = nil) {
    self.chatRoomId = chatRoomId
    self.myId = myId
    self.userId = userId
    self.pageCount = pageCount
    self.startCursor = startCursor
  }

  public var variables: GraphQLMap? {
    return ["chatRoomId": chatRoomId, "myId": myId, "userId": userId, "pageCount": pageCount, "startCursor": startCursor]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("messages", arguments: ["where": ["chatRoom": ["id": GraphQLVariable("chatRoomId")], "receivers_some": ["userId_in": [GraphQLVariable("myId"), GraphQLVariable("userId")]], "sender": ["userId_in": [GraphQLVariable("myId"), GraphQLVariable("userId")]]], "last": GraphQLVariable("pageCount"), "before": GraphQLVariable("startCursor")], type: .nonNull(.list(.nonNull(.object(Message.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(messages: [Message]) {
      self.init(unsafeResultMap: ["__typename": "Query", "messages": messages.map { (value: Message) -> ResultMap in value.resultMap }])
    }

    public var messages: [Message] {
      get {
        return (resultMap["messages"] as! [ResultMap]).map { (value: ResultMap) -> Message in Message(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Message) -> ResultMap in value.resultMap }, forKey: "messages")
      }
    }

    public struct Message: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MessageApolloFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var messageApolloFragment: MessageApolloFragment {
          get {
            return MessageApolloFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class MeQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query Me {
      me {
        __typename
        ...UserApolloFragment
      }
    }
    """

  public let operationName = "Me"

  public var queryDocument: String { return operationDefinition.appending(UserApolloFragment.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("me", type: .nonNull(.object(Me.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(me: Me) {
      self.init(unsafeResultMap: ["__typename": "Query", "me": me.resultMap])
    }

    public var me: Me {
      get {
        return Me(unsafeResultMap: resultMap["me"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "me")
      }
    }

    public struct Me: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(UserApolloFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, type: UserType, role: Role, userId: String, name: String, profileImageUrl: String? = nil, phoneNumber: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "User", "id": id, "type": type, "role": role, "userId": userId, "name": name, "profileImageUrl": profileImageUrl, "phoneNumber": phoneNumber])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userApolloFragment: UserApolloFragment {
          get {
            return UserApolloFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class MemberRoomQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query memberRoom($userId: String!) {
      chatRooms(where: {users_some: {userId: $userId}, admins_none: {userId: $userId}}) {
        __typename
        ...ChatRoomApolloFragment
      }
    }
    """

  public let operationName = "memberRoom"

  public var queryDocument: String { return operationDefinition.appending(ChatRoomApolloFragment.fragmentDefinition).appending(UserApolloFragment.fragmentDefinition).appending(KidApolloFragment.fragmentDefinition) }

  public var userId: String

  public init(userId: String) {
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("chatRooms", arguments: ["where": ["users_some": ["userId": GraphQLVariable("userId")], "admins_none": ["userId": GraphQLVariable("userId")]]], type: .nonNull(.list(.nonNull(.object(ChatRoom.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(chatRooms: [ChatRoom]) {
      self.init(unsafeResultMap: ["__typename": "Query", "chatRooms": chatRooms.map { (value: ChatRoom) -> ResultMap in value.resultMap }])
    }

    public var chatRooms: [ChatRoom] {
      get {
        return (resultMap["chatRooms"] as! [ResultMap]).map { (value: ResultMap) -> ChatRoom in ChatRoom(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: ChatRoom) -> ResultMap in value.resultMap }, forKey: "chatRooms")
      }
    }

    public struct ChatRoom: GraphQLSelectionSet {
      public static let possibleTypes = ["ChatRoom"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ChatRoomApolloFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var chatRoomApolloFragment: ChatRoomApolloFragment {
          get {
            return ChatRoomApolloFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class AdminRoomQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query adminRoom($userId: String!) {
      chatRooms(where: {admins_some: {userId: $userId}}) {
        __typename
        ...ChatRoomApolloFragment
      }
    }
    """

  public let operationName = "adminRoom"

  public var queryDocument: String { return operationDefinition.appending(ChatRoomApolloFragment.fragmentDefinition).appending(UserApolloFragment.fragmentDefinition).appending(KidApolloFragment.fragmentDefinition) }

  public var userId: String

  public init(userId: String) {
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("chatRooms", arguments: ["where": ["admins_some": ["userId": GraphQLVariable("userId")]]], type: .nonNull(.list(.nonNull(.object(ChatRoom.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(chatRooms: [ChatRoom]) {
      self.init(unsafeResultMap: ["__typename": "Query", "chatRooms": chatRooms.map { (value: ChatRoom) -> ResultMap in value.resultMap }])
    }

    public var chatRooms: [ChatRoom] {
      get {
        return (resultMap["chatRooms"] as! [ResultMap]).map { (value: ResultMap) -> ChatRoom in ChatRoom(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: ChatRoom) -> ResultMap in value.resultMap }, forKey: "chatRooms")
      }
    }

    public struct ChatRoom: GraphQLSelectionSet {
      public static let possibleTypes = ["ChatRoom"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ChatRoomApolloFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var chatRoomApolloFragment: ChatRoomApolloFragment {
          get {
            return ChatRoomApolloFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class MessageSubscriptionSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    subscription MessageSubscription {
      message {
        __typename
        ...MessageSubscriptionPayloadApolloFragment
      }
    }
    """

  public let operationName = "MessageSubscription"

  public var queryDocument: String { return operationDefinition.appending(MessageSubscriptionPayloadApolloFragment.fragmentDefinition).appending(MessageApolloFragment.fragmentDefinition).appending(MessagePreviousValuesApolloFragment.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("message", type: .object(Message.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(message: Message? = nil) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "message": message.flatMap { (value: Message) -> ResultMap in value.resultMap }])
    }

    public var message: Message? {
      get {
        return (resultMap["message"] as? ResultMap).flatMap { Message(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "message")
      }
    }

    public struct Message: GraphQLSelectionSet {
      public static let possibleTypes = ["MessageSubscriptionPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MessageSubscriptionPayloadApolloFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var messageSubscriptionPayloadApolloFragment: MessageSubscriptionPayloadApolloFragment {
          get {
            return MessageSubscriptionPayloadApolloFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class SendMessageMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation SendMessage($text: String!, $chatRoomId: ID!, $receiverId: ID!, $fileIds: [ID!]!) {
      sendMessage(data: {text: $text, chatRoomId: $chatRoomId, fileIds: $fileIds, receiverIds: [$receiverId]}) {
        __typename
        ...MessageApolloFragment
      }
    }
    """

  public let operationName = "SendMessage"

  public var queryDocument: String { return operationDefinition.appending(MessageApolloFragment.fragmentDefinition) }

  public var text: String
  public var chatRoomId: GraphQLID
  public var receiverId: GraphQLID
  public var fileIds: [GraphQLID]

  public init(text: String, chatRoomId: GraphQLID, receiverId: GraphQLID, fileIds: [GraphQLID]) {
    self.text = text
    self.chatRoomId = chatRoomId
    self.receiverId = receiverId
    self.fileIds = fileIds
  }

  public var variables: GraphQLMap? {
    return ["text": text, "chatRoomId": chatRoomId, "receiverId": receiverId, "fileIds": fileIds]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("sendMessage", arguments: ["data": ["text": GraphQLVariable("text"), "chatRoomId": GraphQLVariable("chatRoomId"), "fileIds": GraphQLVariable("fileIds"), "receiverIds": [GraphQLVariable("receiverId")]]], type: .nonNull(.object(SendMessage.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(sendMessage: SendMessage) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "sendMessage": sendMessage.resultMap])
    }

    public var sendMessage: SendMessage {
      get {
        return SendMessage(unsafeResultMap: resultMap["sendMessage"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "sendMessage")
      }
    }

    public struct SendMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MessageApolloFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var messageApolloFragment: MessageApolloFragment {
          get {
            return MessageApolloFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class VerifyEmailResponseMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation VerifyEmailResponse($email: String!) {
      verifyEmail(email: $email) {
        __typename
        verifyCode
      }
    }
    """

  public let operationName = "VerifyEmailResponse"

  public var email: String

  public init(email: String) {
    self.email = email
  }

  public var variables: GraphQLMap? {
    return ["email": email]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("verifyEmail", arguments: ["email": GraphQLVariable("email")], type: .nonNull(.object(VerifyEmail.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(verifyEmail: VerifyEmail) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "verifyEmail": verifyEmail.resultMap])
    }

    public var verifyEmail: VerifyEmail {
      get {
        return VerifyEmail(unsafeResultMap: resultMap["verifyEmail"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "verifyEmail")
      }
    }

    public struct VerifyEmail: GraphQLSelectionSet {
      public static let possibleTypes = ["VerifyEmailResponse"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("verifyCode", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(verifyCode: String) {
        self.init(unsafeResultMap: ["__typename": "VerifyEmailResponse", "verifyCode": verifyCode])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var verifyCode: String {
        get {
          return resultMap["verifyCode"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "verifyCode")
        }
      }
    }
  }
}

public final class GetChatroomQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query GetChatroom($code: String!) {
      chatRooms(where: {inviteCode: $code}) {
        __typename
        ...ChatRoomApolloFragment
      }
    }
    """

  public let operationName = "GetChatroom"

  public var queryDocument: String { return operationDefinition.appending(ChatRoomApolloFragment.fragmentDefinition).appending(UserApolloFragment.fragmentDefinition).appending(KidApolloFragment.fragmentDefinition) }

  public var code: String

  public init(code: String) {
    self.code = code
  }

  public var variables: GraphQLMap? {
    return ["code": code]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("chatRooms", arguments: ["where": ["inviteCode": GraphQLVariable("code")]], type: .nonNull(.list(.nonNull(.object(ChatRoom.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(chatRooms: [ChatRoom]) {
      self.init(unsafeResultMap: ["__typename": "Query", "chatRooms": chatRooms.map { (value: ChatRoom) -> ResultMap in value.resultMap }])
    }

    public var chatRooms: [ChatRoom] {
      get {
        return (resultMap["chatRooms"] as! [ResultMap]).map { (value: ResultMap) -> ChatRoom in ChatRoom(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: ChatRoom) -> ResultMap in value.resultMap }, forKey: "chatRooms")
      }
    }

    public struct ChatRoom: GraphQLSelectionSet {
      public static let possibleTypes = ["ChatRoom"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ChatRoomApolloFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var chatRoomApolloFragment: ChatRoomApolloFragment {
          get {
            return ChatRoomApolloFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class ApplyChatRoomMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation ApplyChatRoom($id: ID!, $userId: ID!, $kidName: String!) {
      applyChatRoom(id: $id, data: {userId: $userId, kidName: $kidName}) {
        __typename
        id
      }
    }
    """

  public let operationName = "ApplyChatRoom"

  public var id: GraphQLID
  public var userId: GraphQLID
  public var kidName: String

  public init(id: GraphQLID, userId: GraphQLID, kidName: String) {
    self.id = id
    self.userId = userId
    self.kidName = kidName
  }

  public var variables: GraphQLMap? {
    return ["id": id, "userId": userId, "kidName": kidName]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("applyChatRoom", arguments: ["id": GraphQLVariable("id"), "data": ["userId": GraphQLVariable("userId"), "kidName": GraphQLVariable("kidName")]], type: .nonNull(.object(ApplyChatRoom.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(applyChatRoom: ApplyChatRoom) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "applyChatRoom": applyChatRoom.resultMap])
    }

    public var applyChatRoom: ApplyChatRoom {
      get {
        return ApplyChatRoom(unsafeResultMap: resultMap["applyChatRoom"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "applyChatRoom")
      }
    }

    public struct ApplyChatRoom: GraphQLSelectionSet {
      public static let possibleTypes = ["ChatRoom"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "ChatRoom", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class GetOfficeTimeQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query getOfficeTime($userId: String!) {
      officePeriods(where: {user: {userId: $userId}}) {
        __typename
        crontab
      }
    }
    """

  public let operationName = "getOfficeTime"

  public var userId: String

  public init(userId: String) {
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("officePeriods", arguments: ["where": ["user": ["userId": GraphQLVariable("userId")]]], type: .nonNull(.list(.nonNull(.object(OfficePeriod.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(officePeriods: [OfficePeriod]) {
      self.init(unsafeResultMap: ["__typename": "Query", "officePeriods": officePeriods.map { (value: OfficePeriod) -> ResultMap in value.resultMap }])
    }

    public var officePeriods: [OfficePeriod] {
      get {
        return (resultMap["officePeriods"] as! [ResultMap]).map { (value: ResultMap) -> OfficePeriod in OfficePeriod(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: OfficePeriod) -> ResultMap in value.resultMap }, forKey: "officePeriods")
      }
    }

    public struct OfficePeriod: GraphQLSelectionSet {
      public static let possibleTypes = ["OfficePeriod"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("crontab", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(crontab: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "OfficePeriod", "crontab": crontab])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var crontab: String? {
        get {
          return resultMap["crontab"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "crontab")
        }
      }
    }
  }
}

public struct UserApolloFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment UserApolloFragment on User {
      __typename
      id
      type
      role
      userId
      name
      profileImageUrl
      phoneNumber
    }
    """

  public static let possibleTypes = ["User"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("type", type: .nonNull(.scalar(UserType.self))),
    GraphQLField("role", type: .nonNull(.scalar(Role.self))),
    GraphQLField("userId", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("profileImageUrl", type: .scalar(String.self)),
    GraphQLField("phoneNumber", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, type: UserType, role: Role, userId: String, name: String, profileImageUrl: String? = nil, phoneNumber: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "User", "id": id, "type": type, "role": role, "userId": userId, "name": name, "profileImageUrl": profileImageUrl, "phoneNumber": phoneNumber])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: UserType {
    get {
      return resultMap["type"]! as! UserType
    }
    set {
      resultMap.updateValue(newValue, forKey: "type")
    }
  }

  public var role: Role {
    get {
      return resultMap["role"]! as! Role
    }
    set {
      resultMap.updateValue(newValue, forKey: "role")
    }
  }

  public var userId: String {
    get {
      return resultMap["userId"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "userId")
    }
  }

  public var name: String {
    get {
      return resultMap["name"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var profileImageUrl: String? {
    get {
      return resultMap["profileImageUrl"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "profileImageUrl")
    }
  }

  public var phoneNumber: String? {
    get {
      return resultMap["phoneNumber"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }
}

public struct KidApolloFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment KidApolloFragment on Kid {
      __typename
      id
      name
      parents {
        __typename
        ...UserApolloFragment
      }
    }
    """

  public static let possibleTypes = ["Kid"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("parents", type: .list(.nonNull(.object(Parent.selections)))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, parents: [Parent]? = nil) {
    self.init(unsafeResultMap: ["__typename": "Kid", "id": id, "name": name, "parents": parents.flatMap { (value: [Parent]) -> [ResultMap] in value.map { (value: Parent) -> ResultMap in value.resultMap } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String {
    get {
      return resultMap["name"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var parents: [Parent]? {
    get {
      return (resultMap["parents"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Parent] in value.map { (value: ResultMap) -> Parent in Parent(unsafeResultMap: value) } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Parent]) -> [ResultMap] in value.map { (value: Parent) -> ResultMap in value.resultMap } }, forKey: "parents")
    }
  }

  public struct Parent: GraphQLSelectionSet {
    public static let possibleTypes = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(UserApolloFragment.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, type: UserType, role: Role, userId: String, name: String, profileImageUrl: String? = nil, phoneNumber: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id, "type": type, "role": role, "userId": userId, "name": name, "profileImageUrl": profileImageUrl, "phoneNumber": phoneNumber])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var userApolloFragment: UserApolloFragment {
        get {
          return UserApolloFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct ChatRoomSummaryApolloFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment ChatRoomSummaryApolloFragment on ChatRoom {
      __typename
      id
      name
      admins {
        __typename
        ...UserApolloFragment
      }
      chatRoomAt
      createdAt
    }
    """

  public static let possibleTypes = ["ChatRoom"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("admins", type: .list(.nonNull(.object(Admin.selections)))),
    GraphQLField("chatRoomAt", type: .nonNull(.scalar(String.self))),
    GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, admins: [Admin]? = nil, chatRoomAt: String, createdAt: String) {
    self.init(unsafeResultMap: ["__typename": "ChatRoom", "id": id, "name": name, "admins": admins.flatMap { (value: [Admin]) -> [ResultMap] in value.map { (value: Admin) -> ResultMap in value.resultMap } }, "chatRoomAt": chatRoomAt, "createdAt": createdAt])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String {
    get {
      return resultMap["name"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var admins: [Admin]? {
    get {
      return (resultMap["admins"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Admin] in value.map { (value: ResultMap) -> Admin in Admin(unsafeResultMap: value) } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Admin]) -> [ResultMap] in value.map { (value: Admin) -> ResultMap in value.resultMap } }, forKey: "admins")
    }
  }

  public var chatRoomAt: String {
    get {
      return resultMap["chatRoomAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "chatRoomAt")
    }
  }

  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public struct Admin: GraphQLSelectionSet {
    public static let possibleTypes = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(UserApolloFragment.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, type: UserType, role: Role, userId: String, name: String, profileImageUrl: String? = nil, phoneNumber: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id, "type": type, "role": role, "userId": userId, "name": name, "profileImageUrl": profileImageUrl, "phoneNumber": phoneNumber])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var userApolloFragment: UserApolloFragment {
        get {
          return UserApolloFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct ChatRoomApolloFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment ChatRoomApolloFragment on ChatRoom {
      __typename
      id
      name
      admins {
        __typename
        ...UserApolloFragment
      }
      users {
        __typename
        ...UserApolloFragment
      }
      kids {
        __typename
        ...KidApolloFragment
      }
      inviteCode
      chatRoomAt
      createdAt
    }
    """

  public static let possibleTypes = ["ChatRoom"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("admins", type: .list(.nonNull(.object(Admin.selections)))),
    GraphQLField("users", type: .list(.nonNull(.object(User.selections)))),
    GraphQLField("kids", type: .list(.nonNull(.object(Kid.selections)))),
    GraphQLField("inviteCode", type: .nonNull(.scalar(String.self))),
    GraphQLField("chatRoomAt", type: .nonNull(.scalar(String.self))),
    GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, admins: [Admin]? = nil, users: [User]? = nil, kids: [Kid]? = nil, inviteCode: String, chatRoomAt: String, createdAt: String) {
    self.init(unsafeResultMap: ["__typename": "ChatRoom", "id": id, "name": name, "admins": admins.flatMap { (value: [Admin]) -> [ResultMap] in value.map { (value: Admin) -> ResultMap in value.resultMap } }, "users": users.flatMap { (value: [User]) -> [ResultMap] in value.map { (value: User) -> ResultMap in value.resultMap } }, "kids": kids.flatMap { (value: [Kid]) -> [ResultMap] in value.map { (value: Kid) -> ResultMap in value.resultMap } }, "inviteCode": inviteCode, "chatRoomAt": chatRoomAt, "createdAt": createdAt])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String {
    get {
      return resultMap["name"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var admins: [Admin]? {
    get {
      return (resultMap["admins"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Admin] in value.map { (value: ResultMap) -> Admin in Admin(unsafeResultMap: value) } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Admin]) -> [ResultMap] in value.map { (value: Admin) -> ResultMap in value.resultMap } }, forKey: "admins")
    }
  }

  public var users: [User]? {
    get {
      return (resultMap["users"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [User] in value.map { (value: ResultMap) -> User in User(unsafeResultMap: value) } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [User]) -> [ResultMap] in value.map { (value: User) -> ResultMap in value.resultMap } }, forKey: "users")
    }
  }

  public var kids: [Kid]? {
    get {
      return (resultMap["kids"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Kid] in value.map { (value: ResultMap) -> Kid in Kid(unsafeResultMap: value) } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Kid]) -> [ResultMap] in value.map { (value: Kid) -> ResultMap in value.resultMap } }, forKey: "kids")
    }
  }

  public var inviteCode: String {
    get {
      return resultMap["inviteCode"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "inviteCode")
    }
  }

  public var chatRoomAt: String {
    get {
      return resultMap["chatRoomAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "chatRoomAt")
    }
  }

  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public struct Admin: GraphQLSelectionSet {
    public static let possibleTypes = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(UserApolloFragment.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, type: UserType, role: Role, userId: String, name: String, profileImageUrl: String? = nil, phoneNumber: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id, "type": type, "role": role, "userId": userId, "name": name, "profileImageUrl": profileImageUrl, "phoneNumber": phoneNumber])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var userApolloFragment: UserApolloFragment {
        get {
          return UserApolloFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct User: GraphQLSelectionSet {
    public static let possibleTypes = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(UserApolloFragment.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, type: UserType, role: Role, userId: String, name: String, profileImageUrl: String? = nil, phoneNumber: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id, "type": type, "role": role, "userId": userId, "name": name, "profileImageUrl": profileImageUrl, "phoneNumber": phoneNumber])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var userApolloFragment: UserApolloFragment {
        get {
          return UserApolloFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Kid: GraphQLSelectionSet {
    public static let possibleTypes = ["Kid"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(KidApolloFragment.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var kidApolloFragment: KidApolloFragment {
        get {
          return KidApolloFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct MessageSubscriptionPayloadApolloFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment MessageSubscriptionPayloadApolloFragment on MessageSubscriptionPayload {
      __typename
      mutation
      node {
        __typename
        ...MessageApolloFragment
      }
      updatedFields
      previousValues {
        __typename
        ...MessagePreviousValuesApolloFragment
      }
    }
    """

  public static let possibleTypes = ["MessageSubscriptionPayload"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("mutation", type: .nonNull(.scalar(MutationType.self))),
    GraphQLField("node", type: .object(Node.selections)),
    GraphQLField("updatedFields", type: .list(.nonNull(.scalar(String.self)))),
    GraphQLField("previousValues", type: .object(PreviousValue.selections)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(mutation: MutationType, node: Node? = nil, updatedFields: [String]? = nil, previousValues: PreviousValue? = nil) {
    self.init(unsafeResultMap: ["__typename": "MessageSubscriptionPayload", "mutation": mutation, "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }, "updatedFields": updatedFields, "previousValues": previousValues.flatMap { (value: PreviousValue) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var mutation: MutationType {
    get {
      return resultMap["mutation"]! as! MutationType
    }
    set {
      resultMap.updateValue(newValue, forKey: "mutation")
    }
  }

  public var node: Node? {
    get {
      return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "node")
    }
  }

  public var updatedFields: [String]? {
    get {
      return resultMap["updatedFields"] as? [String]
    }
    set {
      resultMap.updateValue(newValue, forKey: "updatedFields")
    }
  }

  public var previousValues: PreviousValue? {
    get {
      return (resultMap["previousValues"] as? ResultMap).flatMap { PreviousValue(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "previousValues")
    }
  }

  public struct Node: GraphQLSelectionSet {
    public static let possibleTypes = ["Message"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(MessageApolloFragment.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var messageApolloFragment: MessageApolloFragment {
        get {
          return MessageApolloFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct PreviousValue: GraphQLSelectionSet {
    public static let possibleTypes = ["MessagePreviousValues"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(MessagePreviousValuesApolloFragment.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, text: String? = nil, createdAt: String, readedAt: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "MessagePreviousValues", "id": id, "text": text, "createdAt": createdAt, "readedAt": readedAt])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var messagePreviousValuesApolloFragment: MessagePreviousValuesApolloFragment {
        get {
          return MessagePreviousValuesApolloFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct MessageApolloFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment MessageApolloFragment on Message {
      __typename
      id
      chatRoom {
        __typename
        id
      }
      text
      receivers {
        __typename
        userId
        profileImageUrl
        name
      }
      sender {
        __typename
        userId
        profileImageUrl
        name
      }
      createdAt
      readedAt
    }
    """

  public static let possibleTypes = ["Message"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("chatRoom", type: .nonNull(.object(ChatRoom.selections))),
    GraphQLField("text", type: .scalar(String.self)),
    GraphQLField("receivers", type: .list(.nonNull(.object(Receiver.selections)))),
    GraphQLField("sender", type: .nonNull(.object(Sender.selections))),
    GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
    GraphQLField("readedAt", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, chatRoom: ChatRoom, text: String? = nil, receivers: [Receiver]? = nil, sender: Sender, createdAt: String, readedAt: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Message", "id": id, "chatRoom": chatRoom.resultMap, "text": text, "receivers": receivers.flatMap { (value: [Receiver]) -> [ResultMap] in value.map { (value: Receiver) -> ResultMap in value.resultMap } }, "sender": sender.resultMap, "createdAt": createdAt, "readedAt": readedAt])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var chatRoom: ChatRoom {
    get {
      return ChatRoom(unsafeResultMap: resultMap["chatRoom"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "chatRoom")
    }
  }

  public var text: String? {
    get {
      return resultMap["text"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "text")
    }
  }

  public var receivers: [Receiver]? {
    get {
      return (resultMap["receivers"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Receiver] in value.map { (value: ResultMap) -> Receiver in Receiver(unsafeResultMap: value) } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Receiver]) -> [ResultMap] in value.map { (value: Receiver) -> ResultMap in value.resultMap } }, forKey: "receivers")
    }
  }

  public var sender: Sender {
    get {
      return Sender(unsafeResultMap: resultMap["sender"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "sender")
    }
  }

  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var readedAt: String? {
    get {
      return resultMap["readedAt"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "readedAt")
    }
  }

  public struct ChatRoom: GraphQLSelectionSet {
    public static let possibleTypes = ["ChatRoom"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "ChatRoom", "id": id])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }
  }

  public struct Receiver: GraphQLSelectionSet {
    public static let possibleTypes = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("userId", type: .nonNull(.scalar(String.self))),
      GraphQLField("profileImageUrl", type: .scalar(String.self)),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(userId: String, profileImageUrl: String? = nil, name: String) {
      self.init(unsafeResultMap: ["__typename": "User", "userId": userId, "profileImageUrl": profileImageUrl, "name": name])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var userId: String {
      get {
        return resultMap["userId"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "userId")
      }
    }

    public var profileImageUrl: String? {
      get {
        return resultMap["profileImageUrl"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "profileImageUrl")
      }
    }

    public var name: String {
      get {
        return resultMap["name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }
  }

  public struct Sender: GraphQLSelectionSet {
    public static let possibleTypes = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("userId", type: .nonNull(.scalar(String.self))),
      GraphQLField("profileImageUrl", type: .scalar(String.self)),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(userId: String, profileImageUrl: String? = nil, name: String) {
      self.init(unsafeResultMap: ["__typename": "User", "userId": userId, "profileImageUrl": profileImageUrl, "name": name])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var userId: String {
      get {
        return resultMap["userId"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "userId")
      }
    }

    public var profileImageUrl: String? {
      get {
        return resultMap["profileImageUrl"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "profileImageUrl")
      }
    }

    public var name: String {
      get {
        return resultMap["name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }
  }
}

public struct MessagePreviousValuesApolloFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment MessagePreviousValuesApolloFragment on MessagePreviousValues {
      __typename
      id
      text
      createdAt
      readedAt
    }
    """

  public static let possibleTypes = ["MessagePreviousValues"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("text", type: .scalar(String.self)),
    GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
    GraphQLField("readedAt", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, text: String? = nil, createdAt: String, readedAt: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "MessagePreviousValues", "id": id, "text": text, "createdAt": createdAt, "readedAt": readedAt])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var text: String? {
    get {
      return resultMap["text"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "text")
    }
  }

  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var readedAt: String? {
    get {
      return resultMap["readedAt"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "readedAt")
    }
  }
}

public struct MessageSummaryApolloFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment MessageSummaryApolloFragment on MessageSummary {
      __typename
      id
      chatRoom {
        __typename
        ...ChatRoomSummaryApolloFragment
      }
      sender {
        __typename
        ...UserApolloFragment
      }
      receiver {
        __typename
        ...UserApolloFragment
      }
      unReadMessageCount
      lastMessage {
        __typename
        ...MessageApolloFragment
      }
      createdAt
    }
    """

  public static let possibleTypes = ["MessageSummary"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("chatRoom", type: .nonNull(.object(ChatRoom.selections))),
    GraphQLField("sender", type: .nonNull(.object(Sender.selections))),
    GraphQLField("receiver", type: .nonNull(.object(Receiver.selections))),
    GraphQLField("unReadMessageCount", type: .nonNull(.scalar(Int.self))),
    GraphQLField("lastMessage", type: .object(LastMessage.selections)),
    GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, chatRoom: ChatRoom, sender: Sender, receiver: Receiver, unReadMessageCount: Int, lastMessage: LastMessage? = nil, createdAt: String) {
    self.init(unsafeResultMap: ["__typename": "MessageSummary", "id": id, "chatRoom": chatRoom.resultMap, "sender": sender.resultMap, "receiver": receiver.resultMap, "unReadMessageCount": unReadMessageCount, "lastMessage": lastMessage.flatMap { (value: LastMessage) -> ResultMap in value.resultMap }, "createdAt": createdAt])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var chatRoom: ChatRoom {
    get {
      return ChatRoom(unsafeResultMap: resultMap["chatRoom"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "chatRoom")
    }
  }

  public var sender: Sender {
    get {
      return Sender(unsafeResultMap: resultMap["sender"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "sender")
    }
  }

  public var receiver: Receiver {
    get {
      return Receiver(unsafeResultMap: resultMap["receiver"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "receiver")
    }
  }

  public var unReadMessageCount: Int {
    get {
      return resultMap["unReadMessageCount"]! as! Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "unReadMessageCount")
    }
  }

  public var lastMessage: LastMessage? {
    get {
      return (resultMap["lastMessage"] as? ResultMap).flatMap { LastMessage(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "lastMessage")
    }
  }

  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public struct ChatRoom: GraphQLSelectionSet {
    public static let possibleTypes = ["ChatRoom"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(ChatRoomSummaryApolloFragment.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var chatRoomSummaryApolloFragment: ChatRoomSummaryApolloFragment {
        get {
          return ChatRoomSummaryApolloFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Sender: GraphQLSelectionSet {
    public static let possibleTypes = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(UserApolloFragment.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, type: UserType, role: Role, userId: String, name: String, profileImageUrl: String? = nil, phoneNumber: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id, "type": type, "role": role, "userId": userId, "name": name, "profileImageUrl": profileImageUrl, "phoneNumber": phoneNumber])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var userApolloFragment: UserApolloFragment {
        get {
          return UserApolloFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Receiver: GraphQLSelectionSet {
    public static let possibleTypes = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(UserApolloFragment.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, type: UserType, role: Role, userId: String, name: String, profileImageUrl: String? = nil, phoneNumber: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id, "type": type, "role": role, "userId": userId, "name": name, "profileImageUrl": profileImageUrl, "phoneNumber": phoneNumber])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var userApolloFragment: UserApolloFragment {
        get {
          return UserApolloFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct LastMessage: GraphQLSelectionSet {
    public static let possibleTypes = ["Message"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(MessageApolloFragment.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var messageApolloFragment: MessageApolloFragment {
        get {
          return MessageApolloFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}
