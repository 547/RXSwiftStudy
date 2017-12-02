//
//  SimpleTableViewTestViewController.swift
//  RXTest
//
//  Created by seven on 2017/11/21.
//  Copyright © 2017年 seven. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SimpleTableViewTestViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewModel = SimpleTableViewTestViewModel()
    let disposeBag = DisposeBag() //这个是用于释放内存的 （RXSwift 整体贯彻 观察者模式，disposebag就是用于释放(解除监听) 观察者 的）
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:显示相同的cell
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "subtitle")
//        viewModel.data
//            .bind(to: tableView.rx.items(cellIdentifier: "UITableViewCell", cellType: UITableViewCell.self)) { index, dataItem, cell in
//                cell.textLabel?.text = dataItem
//        }.disposed(by: disposeBag)
//
        
        
        
        //MARK:显示不同的cell 使用RxDataSources
//        let data = RxTableViewSectionedReloadDataSource<SimpleTableViewData>.init( configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
//            print("==\(indexPath)====\(item)====")
//            if item < 2 {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Basic") else { return UITableViewCell() }
//                cell.textLabel?.text = "\(item)"
//                return cell
//            }else if item >= 2{
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Subtitle") else { return UITableViewCell() }
//                cell.textLabel?.text = "\(item)"
//                cell.detailTextLabel?.text = "45455"
//                return cell
//            }else{
//                return UITableViewCell()
//            }
//        })
//        Observable.just(viewModel.mutData).bind(to: tableView.rx.items(dataSource: data)).disposed(by: disposeBag)
        
        
        
        //MARK:显示自定义cell 经测试会自适应高度
//        Observable.just(viewModel.data).asObservable().bind(to: tableView.rx.items(cellIdentifier: "CoustomTableViewCell", cellType: CoustomTableViewCell.self)) { (index, dataItem, cell) in
//            cell.setContentView(content: dataItem)
//        }.disposed(by: disposeBag)
        
        
        
        //MARK:移动cell 未使用RxDataSources （delete，remove，insert都这么操作） PS:编辑 tableView 要使用 Variable（可变的，可以改变数据源改，并监听到数据源改变） Observable（是不可以监听到数据源的改变的）
//        let variableData = Variable.init(viewModel.data)
//        variableData.asObservable().bind(to: tableView.rx.items(cellIdentifier: "CoustomTableViewCell", cellType: CoustomTableViewCell.self)) { (index, dataItem, cell) in
//            cell.setContentView(content: dataItem)
//            }.disposed(by: disposeBag)
//
//        tableView.setEditing(true, animated: true)
//
//        tableView.rx.itemMoved.subscribe(onNext: {[weak self] (indexPath) in
//            print("==sourceIndex=\(indexPath.sourceIndex)=destinationIndex==\(indexPath.destinationIndex)====")
//            guard let sourceItem = self?.viewModel.data.remove(at: indexPath.sourceIndex.row) else { return }
//            self?.viewModel.data.insert(sourceItem, at: indexPath.destinationIndex.row)
//            if let da = self?.viewModel.data {
//                //MARK:- 改变数据源，之后会触发 variableData bind 事件（就是刷新tableView）
//                variableData.value = da
//            }
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        
        
        //MARK:移动cell 使用RxDataSources （delete，remove，insert都这么操作）
        tableView.setEditing(true, animated: true)
        
        let variableData = Variable.init(viewModel.mutData) //这样子给是分区的 mutData 里面的 items 是分行
        
        let data = RxTableViewSectionedReloadDataSource<SimpleTableViewData>.init(configureCell: { (dataSource, tableView, indexPath, dataItem) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoustomTableViewCell") as? CoustomTableViewCell else { return UITableViewCell() }
            cell.setContentView(content: "\(dataItem)")
            return cell
        }, titleForHeaderInSection: { (dataSource, dataItem) -> String? in
            return "title For Header In Section"
        }, titleForFooterInSection: { (dataSource, dataItem) -> String? in
            return "title For Footer In Section"
        }, canEditRowAtIndexPath: { (dataSource, indexPath) -> Bool in
            return true
        }, canMoveRowAtIndexPath: { (dataSource, indexPath) -> Bool in
            print("+++++++\(dataSource)++++++++\(indexPath)++++++")
//            if indexPath == IndexPath.init(row: 0, section: 1){
//                return true
//            }else {
//                return false
//            }
            return true
        }, sectionIndexTitles: { (dataSource) -> [String]? in
            return nil
        }) { (dataSource, title, dataItem) -> Int in
            print("--\(dataSource)--\(title)--\(dataItem)---")
            return dataItem
        }

        variableData.asObservable().bind(to: tableView.rx.items(dataSource: data)).disposed(by: disposeBag)
        
        
        
        tableView.rx.itemMoved.subscribe {[weak self] (event) in
            guard let destinationSection = event.element?.destinationIndex.section, let sourceSection = event.element?.sourceIndex.section, let sourceItem = self?.viewModel.mutData.remove(at: sourceSection) else { return }
            self?.viewModel.mutData.insert(sourceItem, at: destinationSection)
            if let da = self?.viewModel.mutData {
                //MARK:- 改变数据源，之后会触发 variableData bind 事件（就是刷新tableView）
                variableData.value = da
            }
        }.disposed(by: disposeBag)
        
        
        //MARK:点击cell
        tableView.rx.itemSelected.subscribe {[weak self] (indexPath) in
            guard let indexpath = indexPath.element else { return }
            self?.tableView.deselectRow(at: indexpath, animated: false)
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





class SimpleTableViewTestViewModel {
    var data = ["Get the new view controller using segue.destinationViewController.Get the new view controller using segue.destinationViewController.Get the new view controller using segue.destinationViewController.Get the new view controller using segue.destinationViewController.",
                "000,002",
                "000,003",
                "Get the new view controller using segue.destinationViewController.",
                "000,005",
                "000,006",
                "Get the new view controller using segue.destinationViewController.Get the new view controller using segue.destinationViewController.",
                "000,008",
                "Get the new view controller using segue.destinationViewController.Get the new view controller using segue.destinationViewController.Get the new view controller using segue.destinationViewController.Get the new view controller using segue.destinationViewController.Get the new view controller using segue.destinationViewController."]
    
    var mutData:[SimpleTableViewData] = [.init(items: [0]),.init(items: [1]),.init(items: [2]),.init(items: [22])]
    
}
///SectionModelType :table view sections data
struct SimpleTableViewData: SectionModelType{
    //items == rows data
    var items: [Int]
    
    init(original: SimpleTableViewData, items: [Int]) {
        self.items = items
    }
    init(items: [Int]) {
        self.items = items
    }
    
    typealias Item = Int
    
}
