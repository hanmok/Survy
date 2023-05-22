////
////  Menu.swift
////  Survy
////
////  Created by Mac mini on 2023/05/22.
////
//
//import Foundation
//
//
//internal func setupWorkspacePickerMenu(_ myHandler: @escaping (String) -> ()) {
//
//    var workspaces: [String] = [.all]
//    let fetchedWorkspaces = coreDataManager.fetchWorkspace()
//
//    fetchedWorkspaces.forEach {
//        workspaces.append($0.title)
//    }
//
//    let menu = UIMenu(title: "")
//
//    var children = [UIMenuElement]()
//
//    // make image too if has one
//    workspaces.forEach { [weak self] workspaceTitle in
//        children.append(UIAction(title: workspaceTitle, handler: { handler in
//            self?.navTitleWorkspaceButton.setAttributedTitle(NSAttributedString(
//                string: workspaceTitle,
//                attributes:
//                    [.font: CustomFont.navigationWorkspace,
//                     .foregroundColor: UIColor(white: 0.1, alpha: 0.8)]),
//                                                             for: .normal)
//            UserDefaults.standard.lastUsedWorkspace = workspaceTitle
//            myHandler(workspaceTitle)
//            print("selected workspace: \(workspaceTitle)")
//            self?.workspacePickerButton.setTitle(workspaceTitle, for: .normal)
//            self?.pickedWorkspaceForNewTodo = workspaceTitle
//        }))
//    }
//
//    children.append(UIAction(title: "Add", handler: { handler in
//        self.addWorkspaceAction()
//    }))
//
//    var newMenu = menu.replacingChildren(children)
//    self.navTitleWorkspaceButton.menu = newMenu
//    self.navTitleWorkspaceButton.showsMenuAsPrimaryAction = true
//
//
//    children.removeFirst() // Remove 'All'
//    children.reverse()
//    newMenu = menu.replacingChildren(children)
//    self.workspacePickerButton.menu = newMenu
//    self.workspacePickerButton.showsMenuAsPrimaryAction = true
//
//    // set lastUsedWorkspace to navigationWorkspace Title
//    let lastUsedWorkspace = UserDefaults.standard.lastUsedWorkspace ?? .all
//
//    self.setAttributedNavigationTitle(lastUsedWorkspace)
//}
