////
////  DiffableTablePractice.swift
////  Survy
////
////  Created by Mac mini on 2023/05/11.
////
//
//import UIKit
//
//class DiffableTablePracticeViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.delegate = self
//        view.addSubview(tableView)
//        tableView.frame = view.bounds
//        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
//            <#code#>
//        })
//    }
//    
//    enum Section {
//        case first
//    }
//    
//    struct Fruit: Hashable {
//        let title: String
//    }
//    
//    var dataSource: UITableViewDiffableDataSource<Section, Fruit>!
//    
//    let tableView: UITableView = {
//        let table = UITableView()
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        return table
//    }()
//    
//    
//}
