//
//  DiffableTablePractice.swift
//  Survy
//
//  Created by Mac mini on 2023/05/11.
//

import UIKit

class DiffableTablePracticeViewController: UIViewController {

    var dataSource: UITableViewDiffableDataSource<Section, Fruit>!
    var fruits = [Fruit]()
    
    enum Section {
        case first
    }

    struct Fruit: Hashable {
        let title: String
        
//        let id = UUID()
//        func hash(into hasher: inout Hasher) {
//            hasher.combine(id)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = itemIdentifier.title
            return cell
        })
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "My Fruits"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAdd))
    }
    
    @objc func didTapAdd() {
        let actionSheet = UIAlertController(title: "Select Fruit", message: nil, preferredStyle: .actionSheet)
        for x in 0 ... 100 {
            actionSheet.addAction(UIAlertAction(title: "Fruit \(x+1)", style: .default, handler: { [weak self] _ in
                let fruit = Fruit(title: "Fruit \(x+1)")
                self?.fruits.append(fruit)
                self?.updateDataSource()
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
    
    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Fruit>()
        snapshot.appendSections([.first])
        snapshot.appendItems(fruits)
//        snapshot.appendItems(<#T##identifiers: [Fruit]##[Fruit]#>, toSection: <#T##Section?#>)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
}

extension DiffableTablePracticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let fruit = dataSource.itemIdentifier(for: indexPath) else { return }
        print(fruit.title)
    }
}
