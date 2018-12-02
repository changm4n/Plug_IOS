//  This file was automatically generated and should not be edited.

import Apollo

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

public final class MessageSummariesQuery: GraphQLQuery {
  public let operationDefinition =
    "query MessageSummaries {\n  messageSummaries {\n    __typename\n    chatRoom {\n      __typename\n      name\n    }\n    sender {\n      __typename\n      name\n    }\n    receiver {\n      __typename\n      name\n    }\n    id\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("messageSummaries", type: .nonNull(.list(.object(MessageSummary.selections)))),
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
        GraphQLField("chatRoom", type: .nonNull(.object(ChatRoom.selections))),
        GraphQLField("sender", type: .nonNull(.object(Sender.selections))),
        GraphQLField("receiver", type: .nonNull(.object(Receiver.selections))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(chatRoom: ChatRoom, sender: Sender, receiver: Receiver, id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "MessageSummary", "chatRoom": chatRoom.resultMap, "sender": sender.resultMap, "receiver": receiver.resultMap, "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
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

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public struct ChatRoom: GraphQLSelectionSet {
        public static let possibleTypes = ["ChatRoom"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String) {
          self.init(unsafeResultMap: ["__typename": "ChatRoom", "name": name])
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

      public struct Sender: GraphQLSelectionSet {
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

      public struct Receiver: GraphQLSelectionSet {
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
}