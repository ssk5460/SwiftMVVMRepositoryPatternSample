//
//  DetailViewModel.swift
//  SwiftMVVMRepositoryPatternSample
//
//  Created by Tomohiro Sasaki on 2017/10/17.
//  Copyright © 2017年 Tomohiro Sasaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class DetailViewModel {
    private let userRepository: UserRepository
    private let users = Variable<[UserEntity]>([])
    private let bag = DisposeBag()

    let user: Observable<UserEntity>
    private let _user: Variable<UserEntity?>

    init(userRepository: UserRepository = .shared,
         user: UserEntity?,
         likeButtonTap: ControlEvent<Void>) {
        self.userRepository = userRepository
        self._user = Variable(user)
        self.user = _user.asObservable()
            .filter { $0 != nil }
            .map { $0! }

        likeButtonTap
            .withLatestFrom(self.user)
            .flatMap { [weak userRepository] user -> Observable<Error> in
                guard let userRepository = userRepository else { return .empty() }
                var user = user
                user.isFollow = !user.isFollow
                return userRepository.updateUser(user: user)
            }
            .subscribe(onNext: { error in
                // TODO: error handling
            })
            .disposed(by: bag)

        userRepository.updatedUser
            .withLatestFrom(self.user) { $0 }
            .filter { $0.id == $1.id }
            .map { $0.0 }
            .bind(to: _user)
            .disposed(by: bag)
    }

    func getUsers() {
        userRepository.getUsers()
            .catchErrorJustReturn([])
            .bind(to: users)
            .disposed(by: bag)
    }
}
