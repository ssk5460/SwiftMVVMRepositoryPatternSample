//
//  Storyboard.swift
//  SwiftMVVMRepositoryPatternSample
//
//  Created by Tomohiro Sasaki on 2017/10/17.
//  Copyright © 2017年 Tomohiro Sasaki. All rights reserved.
//

import UIKit

class Storyboard {

    static func instantiate<T: UIViewController>(_ type: T.Type) -> T {
        let storyboardName = String(describing: type)
        let sb = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = sb.instantiateInitialViewController() as! T
        return vc
    }
    
}
