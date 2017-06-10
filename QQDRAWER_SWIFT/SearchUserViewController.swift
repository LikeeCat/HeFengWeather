//
//  SearchUserViewController.swift
//  和风天气
//
//  Created by 樊树康 on 17/3/23.
//  Copyright © 2017年 猫鼬鼠. All rights reserved.
//

import UIKit
import LeanCloud

class SearchUserViewController: UIViewController,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    var currentUser:UserTable?
    var currentUserName:NSString?
    var sc:UISearchController?
    var searchResult:[UserTable]?{
        didSet{
            self.tableview?.reloadData()
        }
    }
    
    var attionUserList:NSMutableArray?
    var tableview:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setUI()
        configTableView()
               // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    //MARK: -获取当前登录用户
    func getcurrentUser(userName:NSString){
        let query = LCQuery.init(className: "UserTable")
        query.whereKey("userName", .equalTo(userName as!String))
        query.find { (result) in
            self.currentUser = result.objects?.first as! UserTable
        }
    }
    
    func configTableView (){
        view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "bg_rain_night.jpg")!)
        self.tableview = UITableView.init(frame: self.view.frame, style:.plain)
        tableview?.dataSource = self
        tableview?.backgroundColor = UIColor.clear
        tableview?.delegate = self
        tableview?.tableHeaderView = sc?.searchBar
        
        self.view.addSubview(tableview!)

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.sc?.isActive = false
        self.dismiss(animated: true, completion: nil)
    }

    
    func setUI()  {
        
        
        sc = UISearchController(searchResultsController: nil)
        sc?.searchResultsUpdater = self
        sc?.dimsBackgroundDuringPresentation = false
        sc?.definesPresentationContext = true
        sc?.hidesNavigationBarDuringPresentation = false
        sc?.searchBar.delegate = self
        sc?.searchBar.placeholder = "请输入用户名"
        

        sc?.searchBar.backgroundImage = UIImage()
        sc?.searchBar.isTranslucent = true
        self.navigationController?.navigationBar.addSubview((sc?.searchBar)!)
        

    }
    //MARK: -tableView DataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return (sc?.isActive)! ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sc?.isActive)! ? (searchResult?.count)!  : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "userID"
        
        tableView.dequeueReusableCell(withIdentifier: cellID)
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: cellID)
        
        cell.textLabel?.text = searchResult?[indexPath.row].userName?.value
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    //添加关注
    //MARK: -tableView DataSource

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        
        let userCell = tableview?.cellForRow(at: indexPath)
        let attionName = userCell?.textLabel?.text as! NSString
        let attionArray = attionUserList as! [UserRelationShipTable]
        var attionUserNameArr  = [String]()
        for user in attionArray {
            attionUserNameArr.append((user.attionName?.value)!)
        }
        
        if (!attionUserNameArr.contains((userCell?.textLabel?.text)!)){
        let query = LCQuery.init(className: "UserTable")
        query.whereKey("UserName", .equalTo(attionName as! String))
        //添加关注
        query.find { (result) in
        UserRelationShipTable.addfriend(own: self.currentUserName!, attion: attionName, complete: { (isok) in
            let notification = Notification.init(name: Notification.Name(rawValue: "关注用户成功"))
            NotificationCenter.default.post(notification as Notification)
            self.sc?.dismiss(animated: true, completion: {
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.navigationBar.isHidden = true

            })
        })
        }
        }else{
            tableView.deselectRow(at: indexPath, animated: true)
            self.sc?.dismiss(animated: true, completion: {
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.navigationBar.isHidden = true

            })

        }
        
        
    }
    
    //MARK: -SearchControllerDelegate

    func updateSearchResults(for searchController: UISearchController) {
        
        let query = LCQuery.init(className: "UserTable")
        query.whereKey("userName",.equalTo(searchController.searchBar.text!))
        query.find { (result) in
            
            if (result.objects?.count)! > 0{
                self.searchResult = result.objects as! [UserTable]
            }
            else{
                self.searchResult = [UserTable]()
            
            }
            
            
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
