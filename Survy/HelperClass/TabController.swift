//
//  TabController.swift
//  Survy
//
//  Created by Mac mini on 2023/05/26.
//

import UIKit


class TabController: UIViewController {
    var index: Int
    
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
