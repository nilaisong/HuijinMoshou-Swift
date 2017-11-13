//
//  TestViewController.swift
//  MoShou2
//
//  Created by NiLaisong on 2017/10/31.
//  Copyright © 2017年 5i5j. All rights reserved.
//
import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let frame = CGRect.init(x: 0, y: 0, width: 400, height: 400)
//            CGRectFromString("{0,0},{400,400}")
        self.view.frame = frame
        self.view.backgroundColor = UIColor.white
        
        let button:UIButton = UIButton.init(frame:CGRect.init(x: 20, y: 20, width: 100, height: 30))
        button.backgroundColor = UIColor.red
        button.titleLabel?.text = "button"
        self.view.addSubview(button)
        
        let text:UITextView = UITextView.init(frame:CGRect.init(x: 100, y: 100, width: 100, height: 100))
         self.view.addSubview(text)
        
        _ = button.rx.tap.subscribe{ event in
            switch event
            {
            case .next(_):
                text.text = "welcome to you"
                text.backgroundColor = UIColor.blue
            case .completed:
                break
            case .error(let errorInfo):
                print(errorInfo.localizedDescription)
                break
            }
        }
        
//        button.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(onNext: {
//            text.text = "hello,world!"
//            text.backgroundColor = UIColor.green
//        }, onError: nil, onCompleted: {
//
//        }, onDisposed: nil)
        
        _ = text.rx.didChange.subscribe(onNext: {
            button.setTitle("测试按钮", for: UIControlState.normal)
        }, onError: nil, onCompleted: nil, onDisposed: nil)

        let txtField = UITextField.init(frame:CGRect.init(x: 20, y: 100, width: 60, height: 100))
        txtField.backgroundColor = UIColor.green
        self.view.addSubview(txtField)
        txtField.rx.controlEvent(UIControlEvents.editingChanged).subscribe { (envent) in
            print(txtField.text ?? "")
        }
        
        let imgView = UIImageView.init(frame: CGRect.init(x: 10, y: 200, width: 300, height: 200))
        imgView.kf.setImage(with: URL.init(string: "http://app.huijinmoshou.com/ios/1.jpg"), placeholder: UIImage.init(named: "defaultImageBig"))
        self.view.addSubview(imgView)
        // Do any additional setup after loading the view.
        
//        func testDeferNormal() {
//            print("testDefer begin")
//            defer {//代码块结束后必被调用
//                print("testDefer exit")
//            }
//
//            print("testDefer end")
//        }
//        testDeferNormal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
