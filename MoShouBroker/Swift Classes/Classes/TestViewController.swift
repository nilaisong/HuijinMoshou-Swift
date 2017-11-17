//
//  TestViewController.swift
//  MoShou2
//  熟悉rxCocoa、Kingfisher、SnapKit框架的使用
//  Created by NiLaisong on 2017/10/31.
//  Copyright © 2017年 5i5j. All rights reserved.
//
import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SnapKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let frame = CGRect.init(x: 0, y: 0, width: 400, height: 400)
//            CGRectFromString("{0,0},{400,400}")
        self.view.frame = frame
        self.view.backgroundColor = UIColor.white

        if NetworkStatus.shareInstance.isConnected
        {
            print("有网络")
        }
        else
        {
            print("无网络")
        }
        testRxSwift0()
        

//        testDeferNormal()
    }
    
    func testRxSwift0()
    {//创建一个整数的被观察对象，并订阅其数值
        let observableA: Observable = Observable.of([1,2,3,4,5])//序列
        let observableB: Observable = Observable.of([6,7,8,9,10])//序列
        observableA.concat(observableB).subscribe({ (event) in
            switch event
            {
            case .next(let num):
                print("\(num)")
            case .completed:
                print("completed!")
            case .error(let error):
                print("error:\(error.localizedDescription)")
            }
            //            print(event)
            
            //当disposeBag生命周期结束时，即便subscribe没有收到.completed或.error事件，observable sequence也将会被终止，--这种情况很少出现
        }).disposed(by: DisposeBag())
        
        let subject = PublishSubject<String>()
        subject.onNext("Is anyone listening?")
        subject.subscribe { (event) in
            print(event)
        }
    }
    
    func testRxSwift1()
    {//创建一个整数的被观察对象，并订阅其数值
        let observable: Observable<Int> = Observable<Int>.from([1,2,3,4,5])
        //把小于5的过滤掉，然后再订阅；这个方法一般适用于数组和字典等类型的被观察者
        observable.filter({ (i) -> Bool in
            if i < 5{
                return false //会被过滤掉
            }
            else
            {
                return true
            }
        }).subscribe({ (event) in
            switch event
            {
            case .next(let num):
                print("\(num)")
            case .completed:
                print("completed!")
            case .error(let error):
                print("error:\(error.localizedDescription)")
            }
//            print(event)
            
            //当disposeBag生命周期结束时，即便subscribe没有收到.completed或.error事件，observable sequence也将会被终止，--这种情况很少出现
        }).disposed(by: DisposeBag())
    }
    
    func testRxSwift2()
    {
        enum MyError: Error { case anError }
        //创建一个字符串类型的被观察对象，并设定向观察者提供的事件和内容
        let observable = Observable<String>.create({ (observer) -> Disposable in
            //把每次累加结果发送给观察者
            var sum:Int = 0
            for i in 1...3
            {
                sum = sum + i
                observer.onNext("\(sum)")
            }
            //如果大于5则表示成功，否则按失败出来
            if sum > 5
            {
                observer.onCompleted()//
            }
            else
            {
                observer.onError(MyError.anError)
            }
            return Disposables.create()
        })
        //先对结果进行映射，让后再订阅其事件结果
        observable.map({ (str) -> Int in
//            return "sum:\(str)"
            if let i =  Int(str)
            {
                return i
            }
            else
            {
                return 0
            }
        }).toArray().subscribe({ (event) in
            print(event) }).disposed(by: DisposeBag())
    }
    
    func testRxCocoa()
    {//rxSwift在Cocoa中的实际应用
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
    }
    
    func testKingfisher()
    {
        let imgView = UIImageView.init(frame: CGRect.init(x: 10, y: 200, width: 300, height: 200))
        imgView.kf.setImage(with: URL.init(string: "http://app.huijinmoshou.com/ios/1.jpg"), placeholder: UIImage.init(named: "defaultImageBig"))
        self.view.addSubview(imgView)
    }
    
    func testSnapKit1()  {
        //方块1
        let box1 = UIView()
        //方块2
        let box2 = UIView()
        
        box1.backgroundColor = UIColor.orange
        self.view.addSubview(box1)
        box2.backgroundColor = UIColor.green
        self.view.addSubview(box2)
        
        box1.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
            make.top.equalTo(20)
        }
        
        box2.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(box1)
            make.left.equalTo(box1) //等同于 make.left.equalTo(box1.snp.left)
            make.top.equalTo(box1.snp.bottom)
        }
    }
    
    func testSnapKit2()  {
        //外部方块
        let boxOutter = UIView()
        //内部方块
        let boxInner = UIView()

        boxOutter.backgroundColor = UIColor.orange
        self.view.addSubview(boxOutter)
        boxInner.backgroundColor = UIColor.green
        boxOutter.addSubview(boxInner)
        
        boxOutter.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(200)
            make.center.equalTo(self.view)
        }
        
        boxInner.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
    }
    
    func testDeferNormal() {
        print("testDefer begin")
        defer {//代码块结束后必被调用
            print("testDefer exit")
        }
        
        print("testDefer end")
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
