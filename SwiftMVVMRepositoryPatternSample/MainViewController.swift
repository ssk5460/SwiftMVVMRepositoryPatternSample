//
//  ViewController.swift
//  SwiftMVVMRepositoryPatternSample
//
//  Created by Tomohiro Sasaki on 2017/10/17.
//  Copyright © 2017年 Tomohiro Sasaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class MainViewController: UIViewController {

    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, UserEntity>>()
    private let bag = DisposeBag()
    private(set) lazy var viewModel: MainViewModel = .init(itemSelected: self.tableView.rx.itemSelected)

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        setTableViewCell()

        viewModel.users
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        viewModel.showDetail
            .bind(to: showDetail)
            .disposed(by: bag)

        viewModel.getUsers()
    }

    private func setTableViewCell() {
        dataSource.configureCell = { _, tableView, indexPath, user in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainViewListCell.self), for: indexPath) as! MainViewListCell
            cell.titleLabel.text = "\(user.name)"
            cell.followLabel.text = user.isFollow ? "Follow" : "UnFollow"
            return cell
        }
    }

    private var showDetail: AnyObserver<UserEntity> {
        return UIBindingObserver(UIElement: self) { vc, user in
            let detailVC = DetailViewController.instantiate(user: user)
            vc.navigationController?.pushViewController(detailVC, animated: true)
            }.asObserver()
    }
}

// For Header or Footer
//extension MainViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UITableViewHeaderFooterView()
//        return view
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
//}
