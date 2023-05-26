//
//  StoreViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import UIKit

class StoreViewController: TabController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIView()
    }
    
    override init(index: Int) {
        super.init(index: index)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
