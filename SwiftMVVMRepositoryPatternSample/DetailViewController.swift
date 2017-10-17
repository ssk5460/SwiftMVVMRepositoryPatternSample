//
//  DetailViewController.swift
//  SwiftMVVMRepositoryPatternSample
//
//  Created by Tomohiro Sasaki on 2017/10/17.
//  Copyright © 2017年 Tomohiro Sasaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class DetailViewController: UIViewController {

    static func instantiate(user: UserEntity) -> DetailViewController {
        let vc = Storyboard.instantiate(self)
        vc.user = user
        return vc
    }

    private let bag = DisposeBag()
    private var user: UserEntity?
    private(set) lazy var viewModel: DetailViewModel = {
        .init(user: self.user,
              likeButtonTap: self.followButton.rx.tap)
    }()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.user
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                self?.nameLabel.text = user.name
                let label = user.isFollow ? "Follow" : "UnFollow"
                self?.followButton.setTitle(label, for: .normal)
            })
            .disposed(by: bag)
    }
}
