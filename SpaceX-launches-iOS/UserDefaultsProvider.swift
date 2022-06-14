//
//  UserDefaultsProvider.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 13.06.2022.
//

import Foundation

enum UserDefaultsKey: String {
    case sort
}

final class UserDefaultsProvider {

    static func set(key: UserDefaultsKey, value: Any) {
         let standard = UserDefaults.standard
         standard.set(value, forKey: key.rawValue)
         standard.synchronize()
     }

    static func string(key: UserDefaultsKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
}
