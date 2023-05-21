//
//  ScrollViewController6.swift
//  Survy
//
//  Created by Mac mini on 2023/05/22.
//



//
//  ViewController4.swift
//  scrollViewPractice
//
//  Created by Mac mini on 2021/04/06.
//

import UIKit
//import ScrollingFollowView

//var counter = 0
var hasPage2Appeared = false
class ViewController6 : UIViewController {
    
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
        v.isHidden = true
        return v
    }()
    
    var whiteView : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.isHidden = true
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
    
    var pageButton12 : UIButton = {
        let b = UIButton()
        b.setTitle("상품정보", for: .normal)
//        b.setTitleColor(.black, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return b
    }()
    
    var pageButton22 : UIButton = {
        let b = UIButton()
        b.setTitle("리뷰", for: .normal)
//        b.setTitleColor(.black, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return b
    }()
    
    var pageButton32 : UIButton = {
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
        b.text = " 상품정보 "
        return b
    }()
    
    var pageName2 : UILabel = {
        let b = UILabel()
        b.backgroundColor = .yellow
        b.text = " 리뷰 "
        return b
    }()
    
    var pageName3 : UILabel = {
        let b = UILabel()
        b.backgroundColor = .green
        b.text = " 문의 "
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
//        pageName1.backgroundColor = .orange
        scrollView.addSubview(pageName1)
        
        // third view, y : selfHeight * 4.0 , height  : selfHeight * 3
        
        let thirdView = UIView(frame: CGRect(x: 0, y: selfHeight * 4, width: selfWidth, height: selfHeight*3))
        thirdView.backgroundColor = .purple
        
        scrollView.addSubview(thirdView)
        
        pageName2 = UILabel(frame: CGRect(x: 0, y: selfHeight * 4.0, width: selfWidth, height: 50))
        pageName2.backgroundColor = .yellow
        pageName2.text = " 리뷰 "
        pageName2.textAlignment = .center
        scrollView.addSubview(pageName2)
        
        
        // forth view, y : selfHeight * 7.0, height : selfHeight * 3
        
        let forthView = UIView(frame: CGRect(x: 0, y: selfHeight * 7, width: selfWidth, height: selfHeight * 3))
        forthView.backgroundColor = .magenta
        
        scrollView.addSubview(forthView)
        
        pageName3 = UILabel(frame: CGRect(x: 0, y: selfHeight * 7.0, width: selfWidth, height: 50))
        pageName3.backgroundColor = .brown
        pageName3.text = " 문의"
        pageName3.textAlignment = .center
        scrollView.addSubview(pageName3)
        
        
        whiteView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        view.addSubview(whiteView)
        whiteView.isHidden = true
        whiteView.backgroundColor = .white
        
        // pageView ( red backgroundColor with 3 buttons)
        pageView = UIView(frame: CGRect(x: 0, y: selfHeight * 1.5, width: selfWidth, height: 50))
        scrollView.addSubview(pageView)
        
        pageView2 = UIView(frame: CGRect(x: 0, y: 30, width: self.view.bounds.width, height: 50))
        view.addSubview(pageView2)
        
        pageView2.isHidden = true
        pageView2.backgroundColor = .blue
        
        pageView.addSubview(pageButton1)
        pageView.addSubview(pageButton2)
        pageView.addSubview(pageButton3)
        
        pageView2.addSubview(pageButton12)
        pageView2.addSubview(pageButton22)
        pageView2.addSubview(pageButton32)
        
        
        NSLayoutConstraint.activate([
            pageButton1.heightAnchor.constraint(equalToConstant: 30),
            pageButton1.centerYAnchor.constraint(equalTo: pageView.centerYAnchor),
            pageButton1.leadingAnchor.constraint(equalTo: pageView.leadingAnchor),
            pageButton1.widthAnchor.constraint(equalTo: pageView.widthAnchor, multiplier: 0.33),
            
            pageButton2.heightAnchor.constraint(equalToConstant: 30),
            pageButton2.centerYAnchor.constraint(equalTo: pageView.centerYAnchor),
            pageButton2.leadingAnchor.constraint(equalTo: pageButton1.trailingAnchor),
            pageButton2.widthAnchor.constraint(equalTo: pageView.widthAnchor, multiplier: 0.33),
            
            pageButton3.heightAnchor.constraint(equalToConstant: 30),
            pageButton3.centerYAnchor.constraint(equalTo: pageView.centerYAnchor),
            pageButton3.leadingAnchor.constraint(equalTo: pageButton2.trailingAnchor),
            pageButton3.widthAnchor.constraint(equalTo: pageView.widthAnchor, multiplier: 0.33),
            
            
            
            pageButton12.heightAnchor.constraint(equalToConstant: 30),
            pageButton12.centerYAnchor.constraint(equalTo: pageView2.centerYAnchor),
            pageButton12.leadingAnchor.constraint(equalTo: pageView2.leadingAnchor),
            pageButton12.widthAnchor.constraint(equalTo: pageView2.widthAnchor, multiplier: 0.33),
            
            pageButton22.heightAnchor.constraint(equalToConstant: 30),
            pageButton22.centerYAnchor.constraint(equalTo: pageView2.centerYAnchor),
            pageButton22.leadingAnchor.constraint(equalTo: pageButton12.trailingAnchor),
            pageButton22.widthAnchor.constraint(equalTo: pageView2.widthAnchor, multiplier: 0.33),
            
            pageButton32.heightAnchor.constraint(equalToConstant: 30),
            pageButton32.centerYAnchor.constraint(equalTo: pageView2.centerYAnchor),
            pageButton32.leadingAnchor.constraint(equalTo: pageButton22.trailingAnchor),
            pageButton32.widthAnchor.constraint(equalTo: pageView2.widthAnchor, multiplier: 0.33)
        ])
    }
    
     
    @objc func buttonClicked(_ sender : UIButton) {
        print(sender.frame.minX)
        switch sender.frame.minX {
        case 0.0 :
            print("first button clicked")
            
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


extension ViewController6 : UIScrollViewDelegate {
    // 맨 위 화면의 y 좌표를 detect.. wow..
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        switch scrollView.contentOffset.y {
        case -100 ..< self.view.bounds.height * 1.5:
            pageButton1.setTitleColor(.black, for: .normal)
            pageButton2.setTitleColor(.white, for: .normal)
            pageButton3.setTitleColor(.white, for: .normal)
            
            if hasPage2Appeared {
                pageView.isHidden = false
                pageView2.isHidden = true
                whiteView.isHidden = true
                hasPage2Appeared = false
            }
            
            pageButton12.setTitleColor(.black, for: .normal)
            pageButton22.setTitleColor(.white, for: .normal)
            pageButton32.setTitleColor(.white, for: .normal)
            
            
        case self.view.bounds.height * 1.5 ..< self.view.bounds.height * 4.0 - 80 :
            
            if !hasPage2Appeared {
                pageView.isHidden = true
                pageView2.isHidden = false
                whiteView.isHidden = false
                hasPage2Appeared = true
            }
            
            pageButton1.setTitleColor(.black, for: .normal)
            pageButton2.setTitleColor(.white, for: .normal)
            pageButton3.setTitleColor(.white, for: .normal)
            
            pageButton12.setTitleColor(.black, for: .normal)
            pageButton22.setTitleColor(.white, for: .normal)
            pageButton32.setTitleColor(.white, for: .normal)

        case self.view.bounds.height * 4.0 - 80 ..< self.view.bounds.height * 7.0 - 80 :
            
            pageButton12.setTitleColor(.white, for: .normal)
            pageButton22.setTitleColor(.black, for: .normal)
            pageButton32.setTitleColor(.white, for: .normal)

        default:

            pageButton12.setTitleColor(.white, for: .normal)
            pageButton22.setTitleColor(.white, for: .normal)
            pageButton32.setTitleColor(.black, for: .normal)
        }
    }
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
