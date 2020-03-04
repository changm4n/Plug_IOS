//
//  GraphQLExtension.swift
//  Plug
//
//  Created by changmin lee on 2020/02/29.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation

extension ChatRoomApolloFragment: Equatable {
    var admin: UserApolloFragment? {
        self.admins?.first?.fragments.userApolloFragment
    }
    
    func getKid(parent: UserApolloFragment) -> KidApolloFragment? {
        return kids?.filter({ $0.fragments.kidApolloFragment.parentUserID == parent.userId }).first?.fragments.kidApolloFragment
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension KidApolloFragment {
    var parent: UserApolloFragment? {
        return self.parents?.first?.fragments.userApolloFragment
    }
    
    var profileURL: String? {
        return self.parents?.first?.fragments.userApolloFragment.profileImageUrl
    }
    
    var parentUserID: String? {
        return self.parents?.first?.fragments.userApolloFragment.userId
    }
}


extension UserApolloFragment: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.userId == rhs.userId
    }
}
