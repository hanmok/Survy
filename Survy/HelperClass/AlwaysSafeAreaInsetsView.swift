import UIKit

class AlwaysSafeAreaInsetsView: UIView {

    @available(iOS 11.0, *)
    override var safeAreaInsets: UIEdgeInsets {
        if let window = UIApplication.shared.keyWindow {
            return window.safeAreaInsets
        }
        return super.safeAreaInsets
    }

}
