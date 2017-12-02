//
//  ButtonTestViewController.swift
//  RXTest
//
//  Created by seven on 2017/11/21.
//  Copyright © 2017年 seven. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class ButtonTestViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.rx.tap.subscribe{[weak self] in
            self?.label.text = self?.button.title(for: .normal)
            }.disposed(by: disposeBag)
    
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
