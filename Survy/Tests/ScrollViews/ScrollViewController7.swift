//
//  ViewController4.swift
//  scrollViewPractice
//
//  Created by Mac mini on 2021/04/06.
//

import UIKit
//import ScrollingFollowView

//var counter = 0
//var hasPage2Appeared = false
//var hasPageAppeared = false
var isPageOnScrollView = true
class ViewController7 : UIViewController {
    
    var scrollView : UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    var pageView : UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    
    var pageView2 : UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        return v
    }()
    
    var pageButton1 : UIButton = {
        let b = UIButton()
        b.setTitle("상품정보", for: .normal)
//        b.setTitleColor(.black, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return b
    }()
    
    var pageButton2 : UIButton = {
        let b = UIButton()
        b.setTitle("리뷰", for: .normal)
//        b.setTitleColor(.black, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return b
    }()
    
    var pageButton3 : UIButton = {
        let b = UIButton()
        b.setTitle("문의", for: .normal)
//        b.setTitleColor(.black, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return b
    }()
    
    
    var pageName1 : UILabel = {
        let b = UILabel()
        b.backgroundColor = .orange
        return b
    }()
    
    var pageName2 : UILabel = {
        let b = UILabel()
        b.backgroundColor = .yellow
        return b
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for convenience..
        let selfHeight = self.view.bounds.height
        let selfWidth = self.view.bounds.width
        
        // scrollView
//        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        
        scrollView.delegate = self
        
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: selfWidth, height: self.view.bounds.height * 10)
        view.addSubview(scrollView)
        
        
        
        
        // first view , selfHeight * 1.5
        
        let firstView = UIView(frame: CGRect(x: 0, y: 0, width: selfWidth, height: selfHeight * 1.5))
        scrollView.addSubview(firstView)
        firstView.backgroundColor = UIColor(red: 0.5, green: 0.3, blue: 0.1, alpha: 0.5)
        
        
        // second view , y : selfHeight * 1.5, height : selfHeight * 2.5
        
        let secondView = UIView(frame: CGRect(x: 0, y: selfHeight * 1.5, width: selfWidth, height: selfHeight * 2.5))
        secondView.backgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.6, alpha: 0.5)
        scrollView.addSubview(secondView)
        
        pageName1 = UILabel(frame: CGRect(x: 0, y: selfHeight * 1.5, width: selfWidth, height: 50))
        pageName1.backgroundColor = .orange
        scrollView.addSubview(pageName1)
        
        
        
        // third view, y : selfHeight * 4.0 , height  : selfHeight * 3
        
        
        
            
        let thirdView = UIView(frame: CGRect(x: 0, y: selfHeight * 4, width: selfWidth, height: selfHeight*3))
        thirdView.backgroundColor = .purple
        
        scrollView.addSubview(thirdView)
        
        pageName2 = UILabel(frame: CGRect(x: 0, y: selfHeight * 4.0, width: selfWidth, height: 50))
        pageName2.backgroundColor = .yellow
        scrollView.addSubview(pageName2)
        
        
        // pageView ( red backgroundColor with 3 buttons)
        pageView = UIView(frame: CGRect(x: 0, y: selfHeight * 1.5, width: selfWidth, height: 70))
        pageView.backgroundColor = .systemPink
//        view.addSubview(pageView)
        scrollView.addSubview(pageView)
        
//        let stackView = UIStackView(arrangedSubviews: [pageButton1, pageButton2, pageButton3])
//        stackView.distribution = .fillEqually
//        stackView.axis = .horizontal
        
//        pageView.addSubview(stackView)
        
        
        pageView.addSubview(pageButton1)
        pageView.addSubview(pageButton2)
        pageView.addSubview(pageButton3)
        
        NSLayoutConstraint.activate([
            pageButton1.heightAnchor.constraint(equalToConstant: 30),
            pageButton1.bottomAnchor.constraint(equalTo: pageView.bottomAnchor),
            pageButton1.leadingAnchor.constraint(equalTo: pageView.leadingAnchor),
            pageButton1.widthAnchor.constraint(equalTo: pageView.widthAnchor, multiplier: 0.33),
            
            pageButton2.heightAnchor.constraint(equalToConstant: 30),            pageButton2.bottomAnchor.constraint(equalTo: pageView.bottomAnchor),
            pageButton2.leadingAnchor.constraint(equalTo: pageButton1.trailingAnchor),
            pageButton2.widthAnchor.constraint(equalTo: pageView.widthAnchor, multiplier: 0.33),
            
            pageButton3.heightAnchor.constraint(equalToConstant: 30),
            pageButton3.bottomAnchor.constraint(equalTo: pageView.bottomAnchor),
            pageButton3.leadingAnchor.constraint(equalTo: pageButton2.trailingAnchor),
            pageButton3.widthAnchor.constraint(equalTo: pageView.widthAnchor, multiplier: 0.33),
            
            
        ])
       

        
//
//        pageView2 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 70))
//        pageView2.backgroundColor = .blue
//        view.addSubview(pageView2)
        
        
        
       
    }
    
    @objc func buttonClicked(_ sender : UIButton) {
//        print("who's the sender ?  ;  \(sender)")
        print(sender.frame.minX)
        switch sender.frame.minX {
        case 0.0 :
            print("first button clicked")
            
//            let frame = CGRect(
            self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), animated: true)
        case 136.5 :
            print("second button clicked")
            self.scrollView.scrollRectToVisible(CGRect(x: 0, y: self.view.bounds.height * 1.5, width: self.view.bounds.width, height: self.view.bounds.height), animated: true)
        case 273.0 :
            self.scrollView.scrollRectToVisible(CGRect(x: 0, y: self.view.bounds.height * 4.0, width: self.view.bounds.width, height: self.view.bounds.height), animated: true)
            print("third button clicked")
        default :
            print("none of them clicked ")
            
        }
    }
    
}


extension ViewController7 : UIScrollViewDelegate {
    // 맨 위 화면의 y 좌표를 detect.. wow..
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        if scrollView.contentOffset.y > self.view.bounds.height * 1.5 {
//        }
//        if scrollView.contentOffset.y < self.view.bounds.height * 1.5 {
//        }
        
        
        switch scrollView.contentOffset.y {
        case -100 ..< self.view.bounds.height * 1.5:
            // remove from view
            // set in on scrollView
            pageButton1.setTitleColor(.black, for: .normal)
            pageButton2.setTitleColor(.white, for: .normal)
            pageButton3.setTitleColor(.white, for: .normal)
            // true 로 시작.
            if !isPageOnScrollView {
                pageView.removeFromSuperview()
                pageView = UIView(frame: CGRect(x: 0, y: self.view.bounds.height * 1.5, width: self.view.bounds.width, height: 70))
                scrollView.addSubview(pageView)
                isPageOnScrollView = true
            }
            
            
        case self.view.bounds.height * 1.5 ..< self.view.bounds.height * 4.0 :
            // set it on view
            // remove from scrollView
            if isPageOnScrollView {
                pageView.removeFromSuperview()
                pageView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 70))
                view.addSubview(pageView)
                isPageOnScrollView = false
            }
            
            
            pageButton1.setTitleColor(.white, for: .normal)
            pageButton2.setTitleColor(.black, for: .normal)
            pageButton3.setTitleColor(.white, for: .normal)

        case self.view.bounds.height * 4.0 ..< self.view.bounds.height * 7.0 :
            
            pageButton1.setTitleColor(.white, for: .normal)
            pageButton2.setTitleColor(.white, for: .normal)
            pageButton3.setTitleColor(.black, for: .normal)
            if isPageOnScrollView {
                pageView.removeFromSuperview()
                pageView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 70))
                view.addSubview(pageView)
                isPageOnScrollView = false
            }

        default:
            pageButton1.setTitleColor(.white, for: .normal)
            pageButton2.setTitleColor(.white, for: .normal)
            pageButton3.setTitleColor(.white, for: .normal)
            if isPageOnScrollView {
                pageView.removeFromSuperview()
                pageView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 70))
                view.addSubview(pageView)
                isPageOnScrollView = false
            }
        }
    }
}

extension ViewController7 : UIScrollViewAccessibilityDelegate {
//    scroll
}



//우선, autolayout 없이, 만들어보자.


// from stack overflow .
// Q : How to keep UIButton floating After scrollViewDidScroll reached bottom ?
// Address :  https://stackoverflow.com/questions/46027102/how-to-keep-uibutton-floating-after-scrollviewdidscroll-scrollview-uiscrollvi


//
//override func scrollViewDidScroll(scrollView: UIScrollView) {
//
//if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
//    //reached bottom - how to show button below yellow
//    // and keep it floating as shown above
//}
//}


//override func scrollViewDidScroll(scrollView: UIScrollView) {
//  if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) && self.button.isHidden {
//    self.button.isHidden = false
//    self.button.frame = startingFrame // outside of screen somewhere in bottom
//    UIView.animate(withDuration: 1.0) {
//      self.button.frame = yourFrame // where it should be placed
//    }
//  }
//}


//override func viewDidLoad() {
//    super.viewDidLoad()
//    self.button.isHidden = true
//}
