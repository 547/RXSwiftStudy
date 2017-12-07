//
//  PropertyChangeViewController.swift
//  RxSwiftStudy
//
//  Created by seven on 2017/12/7.
//  Copyright © 2017年 seven. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class PropertyChangeViewController: UIViewController {
    @IBOutlet weak var testButton: UIButton!
    let test = Test()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        (testButton.rx.tap).subscribe {[weak self] (event) in
            self?.test.count.value += 1
            print("+++count++\(self?.test.count.value ?? 0)+++event ======= \(event)")
        }.disposed(by: disposeBag)
        
        test.count.asObservable().subscribe {[weak self] (event) in
            guard let value = event.element else { return }
            switch value {
            case 0:
                self?.testButton.backgroundColor = UIColor.groupTableViewBackground
            case 1:
                self?.testButton.backgroundColor = UIColor.yellow
            case 2:
                self?.testButton.backgroundColor = UIColor.blue
            case 3:
                self?.testButton.backgroundColor = UIColor.cyan
            case 4:
                self?.testButton.backgroundColor = UIColor.purple
            default:
                self?.testButton.backgroundColor = UIColor.red
            }
        }.disposed(by: disposeBag)
        
        
        test.array.value.test()
        
        
        
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
class Test {
    //MARK:Variable可变，可以通过 asObservable 或 asDriver 成为可监听的
    let count = Variable(0)
    var array = Variable([3,2,0])
    //MARK:Observable可监听,但是不可变
    var ob = Observable.just(9)
    
}
//MARK:where 后面的应该是 泛型， == 意思是 这个泛型现在的真实类型是 == 后面的类型，比如 extension Array where Iterator.Element == Int 就是说这个extension当数组里面的值都是Int类型的时候适用 而如果把 == 换成 ： 就是遵循某种协议
extension Array where Iterator.Element == Int {
    func test() -> () {
        print(self)
    }
}
extension Dictionary where Key == String {
    
}


