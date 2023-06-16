//
//  Coordinator.swift
//  Survy
//
//

import UIKit

protocol Coordinator {
    
    var provider: ProviderType { get set }

    var navigationController: StartingNavigationController? { get set }
    
    func move(to type: Destination)
    
    func start()
    
    func manipulate(_ childView: ChildView, command: Command)
    
    func testSetup()
    
    func setIndicatorSpinning(_ shouldSpin: Bool)
    
    func toastMessage(title: String, message: String)
}

enum ChildView {
    case categorySelection(CategorySelectionPurpose?)
    
    case targetSelection
    case confirmation
}

extension ChildView: Equatable {
    public static func == (lhs: ChildView, rhs: ChildView) -> Bool {
        switch (lhs, rhs) {
            case (.targetSelection, .targetSelection): return true
            case (.confirmation, .confirmation): return true
            case (.categorySelection, .categorySelection): return true
            default: return false
        }
    }
}

enum Command {
    case present
    case dismiss(Bool?)
}
