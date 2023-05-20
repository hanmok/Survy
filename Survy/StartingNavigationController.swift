//
//  StartingNavigationController.swift
//  MultiPeer
//
//  Created by 핏투비 on 2022/11/03.
//

import UIKit
import SnapKit
import Toast
/**
 NavigationController 에서 처음으로 띄어지는 Controller. Loading Bar, Alert 등을 일부 맡음.
 */
class StartingNavigationController: UINavigationController {

    public func toastMessage(title: String, message: String? = nil) {
        self.view.makeToast(title, duration: 3, position: .top, title: nil, image: nil, style: .init()) { didTap in }
    }
    
    // MARK: - Properties


    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.addSubview(spinner)
//        spinner.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.height.equalTo(100)
//        }

//        LoadingUtil.shared.shouldShowIndicator.asObservable()
//            .distinctUntilChanged()
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [ weak self] shouldRun in
//                guard let self = self else { return }
//                shouldRun ? self.spinner.startAnimating() : self.spinner.stopAnimating()
//            })
//            .disposed(by: disposeBag)
//
//        AlertMessageUtil.shared.alertMessage.asObservable()
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] message in
//                guard let self = self else { return }
//                self.showAlert(message.0 ?? "", message.1 ?? "")
//            })
//            .disposed(by: disposeBag)
    }

    // MARK: - Views
//    private let spinner = UIActivityIndicatorView().then {
//        $0.hidesWhenStopped = true
//        $0.color = .blue
//        $0.transform = CGAffineTransform(scaleX: 2, y: 2)
//    }
}
