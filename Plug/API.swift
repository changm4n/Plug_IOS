//  This file was automatically generated and should not be edited.

import Apollo

public enum UserType: RawRepresentable, Equatable, Hashable, Apollo.JSONDecodable, Apollo.JSONEncodable {
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
}

public enum Role: RawRepresentable, Equatable, Hashable, Apollo.JSONDecodable, Apollo.JSONEncodable {
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
}

public enum MutationType: RawRepresentable, Equatable, Hashable, Apollo.JSONDecodable, Apollo.JSONEncodable {
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
}

public final class SignInMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation SignIn($userId: String!, $password: String!) {\n  signin(userId: $userId, password: $password) {\n    __typename\n    token\n  }\n}"

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

public final class CreateRoomMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation createRoom($roomName: String!, $userId: ID!) {\n  createChatRoom(data: {name: $roomName, userIds: [$userId]}) {\n    __typename\n    users {\n      __typename\n      userId\n    }\n  }\n}"

  public var roomName: String
  public var userId: GraphQLID

  public init(roomName: String, userId: GraphQLID) {
    self.roomName = roomName
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["roomName": roomName, "userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createChatRoom", arguments: ["data": ["name": GraphQLVariable("roomName"), "userIds": [GraphQLVariable("userId")]]], type: .nonNull(.object(CreateChatRoom.selections))),
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
        GraphQLField("users", type: .list(.nonNull(.object(User.selections)))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(users: [User]? = nil) {
        self.init(unsafeResultMap: ["__typename": "ChatRoom", "users": users.flatMap { (value: [User]) -> [ResultMap] in value.map { (value: User) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
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
}

public final class MyChatroomsQuery: GraphQLQuery {
  public let operationDefinition =
    "query MyChatrooms($userId: String) {\n  chatRooms(where: {admins_some: {userId: $userId}}) {\n    __typename\n    ...ChatRoomApolloFragment\n  }\n}"

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
  public let operationDefinition =
    "query MessageSummaries($myId: String!, $pageCount: Int!, $startCursor: String) {\n  messageSummaries(where: {receiver: {userId_in: [$myId]}}, first: $pageCount, after: $startCursor) {\n    __typename\n    ...MessageSummaryApolloFragment\n  }\n}"

  public var queryDocument: String { return operationDefinition.appending(MessageSummaryApolloFragment.fragmentDefinition).appending(ChatRoomSummaryApolloFragment.fragmentDefinition).appending(UserApolloFragment.fragmentDefinition).appending(MessageApolloFragment.fragmentDefinition) }

  public var myId: String
  public var pageCount: Int
  public var startCursor: String?

  public init(myId: String, pageCount: Int, startCursor: String? = nil) {
    self.myId = myId
    self.pageCount = pageCount
    self.startCursor = startCursor
  }

  public var variables: GraphQLMap? {
    return ["myId": myId, "pageCount": pageCount, "startCursor": startCursor]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("messageSummaries", arguments: ["where": ["receiver": ["userId_in": [GraphQLVariable("myId")]]], "first": GraphQLVariable("pageCount"), "after": GraphQLVariable("startCursor")], type: .nonNull(.list(.object(MessageSummary.selections)))),
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

public final class MessagesQuery: GraphQLQuery {
  public let operationDefinition =
    "query Messages($chatRoomId: ID!, $myId: String!, $userId: String!, $pageCount: Int!, $startCursor: String) {\n  messages(where: {chatRoom: {id: $chatRoomId}, receivers_some: {userId_in: [$myId, $userId]}, sender: {userId_in: [$myId, $userId]}}, first: $pageCount, after: $startCursor) {\n    __typename\n    ...MessageApolloFragment\n  }\n}"

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
      GraphQLField("messages", arguments: ["where": ["chatRoom": ["id": GraphQLVariable("chatRoomId")], "receivers_some": ["userId_in": [GraphQLVariable("myId"), GraphQLVariable("userId")]], "sender": ["userId_in": [GraphQLVariable("myId"), GraphQLVariable("userId")]]], "first": GraphQLVariable("pageCount"), "after": GraphQLVariable("startCursor")], type: .nonNull(.list(.nonNull(.object(Message.selections))))),
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
  public let operationDefinition =
    "query Me {\n  me {\n    __typename\n    ...UserApolloFragment\n  }\n}"

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

public final class MessageSubscriptionSubscription: GraphQLSubscription {
  public let operationDefinition =
    "subscription MessageSubscription {\n  message {\n    __typename\n    ...MessageSubscriptionPayloadApolloFragment\n  }\n}"

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
  public let operationDefinition =
    "mutation SendMessage($text: String!, $chatRoomId: ID!, $receiverId: ID!, $fileIds: [ID!]!) {\n  sendMessage(data: {text: $text, chatRoomId: $chatRoomId, fileIds: $fileIds, receiverIds: [$receiverId]}) {\n    __typename\n    ...MessageApolloFragment\n  }\n}"

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
  public let operationDefinition =
    "mutation VerifyEmailResponse($email: String!) {\n  verifyEmail(email: $email) {\n    __typename\n    verifyCode\n  }\n}"

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

public struct UserApolloFragment: GraphQLFragment {
  public static let fragmentDefinition =
    "fragment UserApolloFragment on User {\n  __typename\n  id\n  type\n  role\n  userId\n  name\n  profileImageUrl\n  phoneNumber\n}"

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
  public static let fragmentDefinition =
    "fragment KidApolloFragment on Kid {\n  __typename\n  id\n  name\n  parents {\n    __typename\n    ...UserApolloFragment\n  }\n}"

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
  public static let fragmentDefinition =
    "fragment ChatRoomSummaryApolloFragment on ChatRoom {\n  __typename\n  id\n  name\n  chatRoomAt\n  createdAt\n}"

  public static let possibleTypes = ["ChatRoom"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("chatRoomAt", type: .nonNull(.scalar(String.self))),
    GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, chatRoomAt: String, createdAt: String) {
    self.init(unsafeResultMap: ["__typename": "ChatRoom", "id": id, "name": name, "chatRoomAt": chatRoomAt, "createdAt": createdAt])
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
}

public struct ChatRoomApolloFragment: GraphQLFragment {
  public static let fragmentDefinition =
    "fragment ChatRoomApolloFragment on ChatRoom {\n  __typename\n  id\n  name\n  admins {\n    __typename\n    ...UserApolloFragment\n  }\n  users {\n    __typename\n    ...UserApolloFragment\n  }\n  kids {\n    __typename\n    ...KidApolloFragment\n  }\n  inviteCode\n  chatRoomAt\n  createdAt\n}"

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
  public static let fragmentDefinition =
    "fragment MessageSubscriptionPayloadApolloFragment on MessageSubscriptionPayload {\n  __typename\n  mutation\n  node {\n    __typename\n    ...MessageApolloFragment\n  }\n  updatedFields\n  previousValues {\n    __typename\n    ...MessagePreviousValuesApolloFragment\n  }\n}"

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
  public static let fragmentDefinition =
    "fragment MessageApolloFragment on Message {\n  __typename\n  id\n  chatRoom {\n    __typename\n    id\n  }\n  text\n  receivers {\n    __typename\n    userId\n    profileImageUrl\n    name\n  }\n  sender {\n    __typename\n    userId\n    profileImageUrl\n    name\n  }\n  createdAt\n  readedAt\n}"

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
  public static let fragmentDefinition =
    "fragment MessagePreviousValuesApolloFragment on MessagePreviousValues {\n  __typename\n  id\n  text\n  createdAt\n  readedAt\n}"

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
  public static let fragmentDefinition =
    "fragment MessageSummaryApolloFragment on MessageSummary {\n  __typename\n  id\n  chatRoom {\n    __typename\n    ...ChatRoomSummaryApolloFragment\n  }\n  sender {\n    __typename\n    ...UserApolloFragment\n  }\n  receiver {\n    __typename\n    ...UserApolloFragment\n  }\n  unReadMessageCount\n  lastMessage {\n    __typename\n    ...MessageApolloFragment\n  }\n  createdAt\n}"

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

    public init(id: GraphQLID, name: String, chatRoomAt: String, createdAt: String) {
      self.init(unsafeResultMap: ["__typename": "ChatRoom", "id": id, "name": name, "chatRoomAt": chatRoomAt, "createdAt": createdAt])
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