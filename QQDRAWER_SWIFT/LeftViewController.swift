//
//  QQLeftViewController.swift
//  QQDRAWER_SWIFT
//
//  Created by 樊树康 on 17/3/23.
//  Copyright © 2017年 猫鼬鼠. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var headerView: UIView{
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: (boxView?.frame.width)!, height: 260))
        let imageview = UIImageView.init(frame: view.frame)
        imageview.image = UIImage.init(named: "Untitled.jpg")
        imageview.contentMode = .scaleAspectFill
        view.addSubview(imageview)
        return view
    }
    var tableView :UITableView?
    //创建容器View BoxView
    var boxView:UIView?
        
    var myCityList:[String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        let center = NotificationCenter.default
        if UserDefaults.standard.bool(forKey: "firstLaunch"){
            
        }else{
            getMyCityList()
        }
        center.addObserver(self, selector: #selector(notice(id:)), name: NSNotification.Name(rawValue: "change"), object: nil)
        center.addObserver(self, selector: #selector(reloadedDataForTableView), name:NSNotification.Name(rawValue:"添加完成"), object: nil)
        
    }
    //MARK: -configTableView
    func configTableView(){
        boxView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width * 0.9, height: view.frame.height))
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 200, width:(boxView?.frame.width)!, height: UIScreen.main.bounds.height - 200), style: .plain)
       
        tableView?.separatorStyle = .none
        tableView?.backgroundColor = UIColor.clear
        let backgroundView = UIImageView.init(frame: (tableView?.frame)!)
        backgroundView.image = UIImage.init(named: "splash_image_blue_bg01_640x960.jpg")!
        backgroundView.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor.white
        
        boxView?.addSubview(headerView)
        boxView?.addSubview(backgroundView)
        boxView?.addSubview(tableView!)
        view.addSubview(boxView!)
        tableView?.delegate = self
        tableView?.dataSource = self

    }
    
    
   //MARK: - 重新加载TableView,当城市列表发生变化
    func reloadedDataForTableView(){
        getMyCityList()
        tableView?.reloadData()
    }
    //MARK:-  从文件中加载城市列表
    func getMyCityList(){
        let filePath = FileOperation.getDocPath().appendingPathComponent(FileOperation.userCityList)
        
        myCityList = NSArray.init(contentsOfFile: filePath) as! [String]?
        DispatchQueue.global(qos: .userInitiated).async {
            let filePath = FileOperation.getDocPath().appendingPathComponent(FileOperation.userCityList)
            if self.myCityList != nil{
            (self.myCityList as! NSArray).write(toFile:filePath, atomically: true)
            }
            DispatchQueue.main.async {
//                print("保存城市成功 😯")
            }
        }
    }
    

    // MARK: - UITableViewDataSource,UITableViewDelegate
    func notice(id:AnyObject){
       
        let dic = id as! Notification
        let locationCity = (dic.object as! [String]).first
        if (myCityList == nil || (myCityList?.contains(locationCity!))!) == true{
            
        }
        else{
            myCityList?.insert(locationCity!, at: 0)

        }
        tableView?.reloadData()
        
    }
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myCityList == nil || myCityList?.isEmpty == true{
         return 1
        }
        else{
            return (myCityList?.count)! + 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
            
         var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: tableView.frame.width, height: 40))
        if !(cell != nil) {
            
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIdentifier)
            cell?.selectionStyle = .none
            cell?.backgroundColor = UIColor.clear
        }
        if indexPath.row == myCityList?.count||myCityList?.count == nil || myCityList?.isEmpty == true{
            cell?.textLabel?.text = "添加城市"
        }else{
            cell!.textLabel?.text = myCityList?[indexPath.row]

        }
        cell?.textLabel?.textColor = UIColor.white

        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1{
        DRrawerViewController.sharedDrawerViewController.closeDrawer(closeDrawerWithDuration: 0.2)
        DRrawerViewController.sharedDrawerViewController.jumpPage = indexPath.row
        }
        if indexPath.row == myCityList?.count||myCityList?.count == nil{
            let vc = SearchCityViewController()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            myCityList?.remove(at: indexPath.row)
            (myCityList as!NSArray).write(toFile: FileOperation.getDocPath().appendingPathComponent(FileOperation.userCityList), atomically: true)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
          
            let notifation = Notification.init(name: Notification.Name(rawValue: "删除成功"))
            
            NotificationCenter.default.post(notifation)
        }
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
