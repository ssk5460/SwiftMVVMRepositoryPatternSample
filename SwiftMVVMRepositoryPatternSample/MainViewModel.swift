//
//  MainViewModel.swift
//  SwiftMVVMRepositoryPatternSample
//
//  Created by Tomohiro Sasaki on 2017/10/17.
//  Copyright © 2017年 Tomohiro Sasaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class MainViewModel: NSObject {

    private let bag = DisposeBag()
    private let userRepository: UserRepository

    let users: Observable<[SectionModel<String, UserEntity>]>
    private let _users = Variable<[SectionModel<String, UserEntity>]>([])
    let showDetail: Observable<UserEntity>
    private let _showDetail = PublishSubject<UserEntity>()

    init(userRepository: UserRepository = .shared, itemSelected: ControlEvent<IndexPath>) {
        self.userRepository = userRepository
        self.users = _users.asObservable()
        self.showDetail = _showDetail

        super.init()

        itemSelected
            .withLatestFrom(users) { $0 }
            .map { $1[$0.section].items[$0.row] }
            .bind(to: _showDetail)
            .disposed(by: bag)

        startObserve()
    }

    func getUsers() {
        userRepository.getUsers()
            .catchErrorJustReturn([])
            .map { users in
                let section1Users = SectionModel(model: "1", items: users)
                return [section1Users]
            }
            .bind(to: _users)
            .disposed(by: bag)
    }

    private func startObserve() {
        userRepository.updatedUser
            .withLatestFrom(users) { $0 }
            .map { user, users in
                users.map { section -> SectionModel<String, UserEntity> in
                    let updateItems = section.items.map { $0.id == user.id ? user : $0 }
                    return SectionModel(model: section.model, items: updateItems)
                }
            }
            .bind(to: _users)
            .disposed(by: bag)
    }
}

