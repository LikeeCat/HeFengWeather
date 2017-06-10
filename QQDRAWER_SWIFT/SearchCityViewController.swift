//
//  SearchCityViewController.swift
//  和风天气
//
//  Created by 樊树康 on 17/3/23.
//  Copyright © 2017年 猫鼬鼠. All rights reserved.
//

import UIKit

class SearchCityViewController: UITableViewController,UISearchResultsUpdating,UISearchBarDelegate{
    
    let notifacation = Notification.init(name: Notification.Name(rawValue: "添加完成"))
    
    
    var sc:UISearchController!
    //搜索结果
    var searchResults: [[String]]?
    //城市列表
    var citylist = [[String]](){
        didSet{
            tableView.reloadData()
        }
    }

    
    var defultCityList = [String](){
        didSet{
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        getAllCityFromFile()

    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)

    }
    //从文件中获取城市列表
    func getAllCityFromFile(){
        DispatchQueue.global(qos: .userInteractive).async {
            let cityModelPath = FileOperation.getDocPath().appendingPathComponent(FileOperation.AllCityList)
            let dic  = NSDictionary.init(contentsOfFile: cityModelPath) as! [String:[String]]
            for content in dic.values{
                self.citylist.append(content)
            }
          
            self.defultCityList =  NSArray.init(contentsOfFile: FileOperation.getDocPath().appendingPathComponent(FileOperation.userCityList)) as![String]
        }
        
        
    }
    
    func setUI()
    {
        if self.tableView.style == .plain{
            var contentInset = tableView.contentInset
            contentInset.top = 25
            tableView.contentInset = contentInset
        }

        //search config
        sc = UISearchController(searchResultsController: nil)
        sc?.searchResultsUpdater = self
        sc.dimsBackgroundDuringPresentation = false
        sc.definesPresentationContext = true
        sc.hidesNavigationBarDuringPresentation = false
        sc.searchBar.delegate = self
        sc.searchBar.placeholder = "请输入城市名进行搜索"
        //tableView config
        self.tableView.tableHeaderView = sc.searchBar
        self.tableView.backgroundColor = UIColor.clear
        let imageView = UIImageView.init(frame: self.tableView.frame)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.init(named: "bg_sunny_day.jpg")!
       self.tableView.backgroundView = imageView
        tableView?.separatorStyle = .none
        sc.searchBar.backgroundImage = UIImage()
        sc.searchBar.isTranslucent = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of 
        
        return citylist.isEmpty ? 0 : 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return sc.isActive ? searchResults!.count : defultCityList.count
        if (citylist != nil && sc != nil){
        if sc.isActive{
            return (searchResults?.count)!
        }else{
            return citylist.count
            }}
        else{
            return 0
        }
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cellIdentifier"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: tableView.frame.width, height: 40))
        
        cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellIdentifier)
        cell?.selectionStyle = .none
        cell?.backgroundColor = UIColor.clear

        if sc.isActive{
            cell?.textLabel?.text = searchResults?[indexPath.row][1]
            cell?.detailTextLabel?.text = searchResults?[indexPath.row][0]

        }else{
            //城市名
        cell?.textLabel?.text = citylist[indexPath.row][1]
            //管辖地
        cell?.detailTextLabel?.text = citylist[indexPath.row][0]
        }
        cell?.textLabel?.textColor = UIColor.white
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
 
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filePath = FileOperation.getDocPath().appendingPathComponent("MyCityList.plist")
        var myCityList = NSArray.init(contentsOfFile: filePath) as![String]
        let searchKey = sc.isActive ? searchResults?[indexPath.row] : citylist[indexPath.row]
        if (myCityList.contains((searchKey?[1])!)){
        }else{
            myCityList.append((searchKey?[1])!)
            (myCityList as! NSArray).write(toFile: filePath, atomically: true)
            self.sc.isActive = false
        }
        self.dismiss(animated: true) {
            NotificationCenter.default.post(self.notifacation)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.sc.isActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
     searchResults = FileOperation.fileOperation.search(key: searchController.searchBar.text!, array: citylist)
     tableView.reloadData()
    
    }
}
