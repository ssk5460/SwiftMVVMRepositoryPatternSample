//
//  ApiClient.swift
//  SwiftMVVMRepositoryPatternSample
//
//  Created by Tomohiro Sasaki on 2017/10/17.
//  Copyright © 2017年 Tomohiro Sasaki. All rights reserved.
//

import Foundation
import RxSwift

protocol ApiClientType: class {
    func getUsers() -> Observable<[UserEntity]>
    func updateUser(_ user: UserEntity) -> Observable<UserEntity>
}

final class ApiClient: ApiClientType {
    static let shared = ApiClient()

    func getUsers() -> Observable<[UserEntity]> {
        // TODO: needs API implementation
        return .never()
    }

    func updateUser(_ user: UserEntity) -> Observable<UserEntity> {
        // TODO: needs API implementation
        return .never()
    }
}
