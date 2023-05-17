//
//  BaseViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import UIKit

enum UpdatingDataType {
    case target
    case tag
}

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    
//    func updateMyUI(_ updatingDataType: UpdatingDataType) {
//
//    }
    
    func updateMyUI() { }
    
}
