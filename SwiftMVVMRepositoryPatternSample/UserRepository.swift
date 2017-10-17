//
//  UserRepository.swift
//  SwiftMVVMRepositoryPatternSample
//
//  Created by Tomohiro Sasaki on 2017/10/17.
//  Copyright © 2017年 Tomohiro Sasaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class UserRepository {

    // mock data
    private class UserApiClientMock: ApiClientType {
        private let mockData = [
            UserEntity(id: 1, name: "James", isFollow: false ),
            UserEntity(id: 2, name: "Robert", isFollow: false ),
            UserEntity(id: 3, name: "David", isFollow: false ),
            UserEntity(id: 4, name: "Jennipher", isFollow: false ),
            UserEntity(id: 5, name: "Lisa", isFollow: false ),
            ]

        func getUsers() -> Observable<[UserEntity]> {
            return .just(mockData)
        }

        func updateUser(_ user: UserEntity) -> Observable<UserEntity> {
            return .just(user)
        }
    }

    static let shared = UserRepository()

    private let apiClient: ApiClientType
    private let bag = DisposeBag()

    let updatedUser: Observable<UserEntity>
    private let _updatedUser = PublishSubject<UserEntity>()

    init(apiClient: ApiClientType = UserApiClientMock()) { //ApiClient.shared) {
        self.apiClient = apiClient
        self.updatedUser = _updatedUser
    }

    func getUsers() -> Observable<[UserEntity]> {
        return apiClient.getUsers().take(1)
    }

    func updateUser(user: UserEntity) -> Observable<Error> {
        return apiClient.updateUser(user)
            .do(onNext: { [weak self] in
                self?._updatedUser.onNext($0)
            })
            .flatMap { _ in Observable<Error>.empty() }
            .catchError { .just($0) }
    }
    
    
}
