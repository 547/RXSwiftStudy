//
//  UserTestViewController.swift
//  RXTest
//
//  Created by seven on 2017/11/24.
//  Copyright © 2017年 seven. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class UserTestViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var affirmButton: UIButton!
    let disposeBag = DisposeBag()
    
    let a = Variable(0)
    let b = Variable(0)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let textInt = (nameTextField.rx.text).orEmpty.map {
//            return Int($0 ?? "") ?? 0
//            }.map {
//                return $0 > 10 ? "\($0) 大于 10" : "\($0) 小于 10"
//        }.debug().bind(to: passwordTextField.rx.text)
//        textInt.disposed(by: disposeBag)
        
//       let name = (nameTextField.rx.text).filter {
//            return ($0?.count ?? 0) > 5
//        }
//        let password = (passwordTextField.rx.text).filter {
//            return ($0?.count ?? 0) > 5
//        }
        
        //MARK:driver 版
        //MARK: orEmpty 就是一个 解包(安全的，如果 String == nil，默认赋值 "" ) 的过程
//        let nameDriver = (nameTextField.rx.text).orEmpty.asDriver().map { (str) -> Bool in
//            return str.count >= 5
//        }.debug()
//        let passwordDriver = (passwordTextField.rx.text).orEmpty.asDriver().map { (str) -> Bool in
//            return str.count >= 5
//        }.debug()
//        Driver.combineLatest(nameDriver,passwordDriver) { (nameResult,passwordResult) -> Bool in
//            return nameResult && passwordResult
//            }.debug().drive(affirmButton.rx.isEnabled).disposed(by: disposeBag)
        
        
        //MARK:observable 版
        let name = (nameTextField.rx.text).orEmpty.map {
            return $0.count >= 5
        }.debug()
        let password = (passwordTextField.rx.text).orEmpty.map { (str) -> Bool in
            return str.count >= 5
        }.debug()
        
        Observable.combineLatest(name,password) { (nameResult,passwordResult) -> Bool in
            return nameResult && passwordResult
            }.bind(to: affirmButton.rx.isEnabled).disposed(by: disposeBag)
        
    
        (affirmButton.rx.tap).subscribe(onNext: {
            print("affirmButton")
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        
        
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
