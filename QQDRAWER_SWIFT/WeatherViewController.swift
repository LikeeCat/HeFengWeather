//
//  WeatherViewController.swift
//  QQDRAWER_SWIFT
//
//  Created by 樊树康 on 17/3/23.
//  Copyright © 2017年 猫鼬鼠. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
  
    var scroll:UIScrollView?
    //MARK: - datasource property
    
    //星期几
    var isDay:Bool?
    //城市模型
    var nowModel = HeWeatherModel()
    // 定位城市
    let locationCity = "LocationCity"
    //城市列表
    var citylist = [String](){
        didSet{
            self.spin?.stopAnimating()
            scroll?.contentSize = CGSize.init(width: Int(self.view.frame.width) * (citylist.count) ,height: Int(self.view.frame.height))
            
        }
    }
    var spin:UIActivityIndicatorView?
    //当前是第几页
    var page = 0{
        
        didSet{
//            print("当前是第\(page) 现在的个数是\(cityListTableView.count)")

            if citylist.count > cityListTableView.count{
                
                configTableView()
            }
                getWeather(cityName: citylist[page])
        }
    }
    //存放所有用户城市的TableView
    var cityListTableView = [UITableView]()
    
    var height:CGFloat
    {
        let height = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
        return height
        
    }
    //城市名
    var city : String?{
        
        didSet{
            /*
             在城市名发生改变的时候(地理位置变化) -> 更新用户城市列表 ->
             
             ScrollView 更新页数 -> 监听页数改变 -> 获取当前页面天气信息 -> 刷新TableView
            */
            
            self.spin?.stopAnimating()
            configTableView()
            getWeather(cityName: city!)
            DispatchQueue.global(qos: .userInteractive).async
                {
                    let filePath =  FileOperation.getDocPath().appendingPathComponent(FileOperation.userCityList)
                    if self.city != self.citylist[0] && self.citylist.contains(self.city!) == false
                    {
                        let cityDefults = UserDefaults.standard.value(forKey: self.locationCity)
                        if (self.city !=  String(describing: cityDefults) )
                        {
                            UserDefaults.standard.set(self.city, forKey: self.locationCity)
                        }
                        
                    }
                    (self.citylist as! NSArray).write(toFile: filePath, atomically: true)
            
                }
                    DispatchQueue.main.async
                        {
//                            print("保存好了👌")
                        }
            }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.startLocation()
        self.setUI()
        if FileOperation.isExit(folder:"Documents", fileName: FileOperation.userCityList) {
            getMyCityList()
            if self.citylist.count != 0 {
                getWeather(cityName: self.citylist.first!)
            }

        }

        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(cityListHasBeenChanged), name:NSNotification.Name(rawValue:"添加完成"), object: nil)
        center.addObserver(self, selector: #selector(jumpToSelectedCity), name:NSNotification.Name(rawValue:"JumpToPage") , object: nil)
        center.addObserver(self, selector: #selector(cityListHasBeenChanged), name:NSNotification.Name(rawValue:"删除成功"), object: nil)
        //        let array = NSArray.init(contentsOfFile:   FileOperation.getDocPath().appendingPathComponent(FileOperation.AllCityList))
        
        //        }
        //
        //        if FileOperation.isFirstStart == false{
        //            getMyCityList()
        //            getWeather(cityName: citylist.first!)
        //        }

        
    }
    override func viewWillAppear(_ animated: Bool) {
        if self.citylist.isEmpty || !(self.city == nil) {
            spin = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
            spin?.frame = CGRect.init(x: self.view.center.x, y: self.view.center.y, width: 70, height: 70)
            self.view .addSubview(spin!)
            spin?.startAnimating()
        }
    }

    //在点击对应城市跳转
    func jumpToSelectedCity(notification:AnyObject){
        let jumpIndex = (notification as! Notification).object as! Int
        page = (notification as! Notification).object as! Int
        scroll?.contentOffset =  CGPoint.init(x: self.view.frame.width * CGFloat(page), y: 0)
    }
    //在城市列表发生改变时调用
    func cityListHasBeenChanged(){
        let path = FileOperation.getDocPath().appendingPathComponent(FileOperation.userCityList)
        self.citylist = NSArray.init(contentsOfFile: path) as! [String]
        
    }
    //MARK: 获取城市列表

    func getMyCityList(){
        
                let path = FileOperation.getDocPath().appendingPathComponent(FileOperation.userCityList)
                self.citylist = NSArray.init(contentsOfFile: path) as! [String]
                self.loadTableViewFromFile()
    }
    //MARK: Start Location
    
    func startLocation()
    {
        
    let mapmanager = Location.singleLocation.configManager()
    Location.singleLocation.locationResult(mapManager: mapmanager)
    { (code) in
        if(code.city != nil)
        {
            if(self.citylist.isEmpty)
            {
                self.setUI()
                self.citylist.append(code.city)
                self.city = code.city
            }
            else{
                if !self.citylist.contains(code.city)
                {
                    self.setUI()
                    self.citylist.insert(code.city, at: 0)
                    self.city = code.city
                }

            }
//                    }
    }
    
    }
    }
    //MARK: -设置背景图片
    func setUI(){
        let imageView = UIImageView()
        imageView.frame = self.view.frame
        imageView.image = UIImage(named: "bg_rain_day.jpg")
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        scroll = UIScrollView.init(frame: self.view.frame)
        scroll?.contentSize = CGSize.init(width: Int(self.view.frame.width) * (citylist.count) ,height: Int(self.view.frame.height))
        scroll?.backgroundColor = UIColor.clear
        scroll?.delegate = self
        scroll?.contentOffset = CGPoint.init(x: 0, y: 0)
        self.scroll?.isPagingEnabled = true
        self.view.addSubview(scroll!)
    }
    
    // MARK: -Config TableView
    func configTableView()
    {
        

        //进入app 打开天气列表 -> 2个
//        if citylist.count > page {
        let tabHeight = self.tabBarController?.tabBar.frame.height
//        print("this is the \(tabHeight)")
        let tableHeight = self.view.frame.height - tabHeight! - height
            let tableview =  UITableView.init(frame:CGRect.init(x: CGFloat((citylist.count - 1) * Int(self.view.frame.width)), y: height, width: self.view.bounds.width, height: tableHeight), style: .plain)
            self.scroll?.addSubview(tableview)
            self.initXIB(tableView: tableview)
          self.automaticallyAdjustsScrollViewInsets = true
            cityListTableView.append(tableview)
            setTableViewpropety(tabelView: tableview)
        

      
    }
    //MARK: - 当不是第一次启动时,从文件中读取城市列表,加载Scroll View
    func loadTableViewFromFile(){
        for i in 0..<citylist.count{
            let tabHeight = self.tabBarController?.tabBar.frame.height
//            print("this is the \(tabHeight)")
            let tableHeight = self.view.frame.height - tabHeight! - height
            let tableview =  UITableView.init(frame:CGRect.init(x: CGFloat(i * Int(self.view.frame.width)), y: height, width: self.view.bounds.width, height: tableHeight), style: .plain)
            self.scroll?.addSubview(tableview)
            self.initXIB(tableView: tableview)
            cityListTableView.append(tableview)
            setTableViewpropety(tabelView: tableview)
        }
    }
    //MARK: -初始化 UI 界面
    func setTableViewpropety(tabelView:UITableView)
    {
        
        let tabHeight = self.tabBarController?.tabBar.frame.height
        
        let tableHeight = self.view.frame.height - tabHeight! - height
        

        tabelView.backgroundColor = UIColor.clear
        tabelView.rowHeight = self.view.frame.height  - tabHeight! - height
        tabelView.allowsSelection = false
        tabelView.dataSource = self
        tabelView.delegate = self
        tabelView.separatorStyle = .none
        
    }
    
    func initXIB(tableView:UITableView)
    {
        let nibcell = UINib.init(nibName: "HomePageCell", bundle: nil)
        let nib1Cell = UINib.init(nibName: "DetailPageCell", bundle: nil)
        let nib2Cell = UINib.init(nibName: "SuggestCell", bundle: nil)

        tableView.register(nib1Cell, forCellReuseIdentifier:"DetailPageCell")
        tableView.register(nibcell, forCellReuseIdentifier:"HomePageCell" )
        tableView.register(nib2Cell, forCellReuseIdentifier: "cell")
    }
    
    
    //MARK: Get Weather Model111
    func getWeather(cityName:String)
    {
        DispatchQueue.global(qos: .userInteractive).async
            {
            let url =  NetworkHelper.netHelper.creatUrlRequest(cityName: cityName, type: .weather)
            do{
//                print(url)
                let jsonString = try String.init(contentsOf: url)
                let jsonModel = Model.init(string: jsonString, error: nil)
                let model = jsonModel?.heWeather5
                self.nowModel = model?[0] as!HeWeatherModel
                
                }
            catch{}
            
            DispatchQueue.main.async
                {
                
                self.cityListTableView[self.page].reloadData()

                }
            }
    }
    

    //MARK: TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if nowModel.status == nil
        {
            return 0
        }
        else
        {
            return 3
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let date = Date()
        let dailyModel = (nowModel.daily_forecast) as! [DailyModel]
        let todayModel = dailyModel[0]
        isDay = isDayNow(date: date, dateModel: todayModel.astro)
        let homePageCell = HomePageCell.cellForRowAtindexPath(jsonModel: nowModel, tableView: tableView,isday: isDay!)
       
        
        
        if indexPath.section == 0{
            let tabHeight = self.tabBarController?.tabBar.frame.height
            
            tableView.rowHeight = view.frame.height  - tabHeight! - self.height
        }
//       
        if indexPath.section == 1
        {
            tableView.rowHeight = 200
           let cell = DetailPageCell.cellForRowAtindexPath(jsonModel: nowModel, tableView: tableView,width: self.view.frame.width,isDay: isDay!)
//            cell.height = 200
            return cell
        }
        
        if indexPath.section == 2{
            tableView.rowHeight = 188
            let cell = SuggestCell.cellForRowAtindexPath(jsonModel: nowModel, tableView: tableView)
//            cell.height = 188
            return cell
            
        }
            return homePageCell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if indexPath.section == 0{
//            let cell = tableView.cellForRow(at: indexPath) as!HomePageCell
//            
//            return cell.frame.size.height
//
//        }
//        if indexPath.section == 1{
//            let cell = tableView.cellForRow(at: indexPath) as! DetailPageCell
//            return cell.frame.size.height
//
//        }
//        if indexPath.section == 2{
//            let cell = tableView.cellForRow(at: indexPath) as! SuggestCell
//            return cell.frame.size.height
//        }
//        return 0
//    }
    
    //MARK: - tableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  CGFloat(0.001)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: -监听滑动事件
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView.isMember(of: UIScrollView.self)
        {
            let offSetX = scrollView.contentOffset.x
            if offSetX == 0 || offSetX == CGFloat(citylist.count) * ((self.scroll?.frame.width)!)
            {
            }else
            {
                page = Int(Double((scroll?.contentOffset.x)!)/Double(self.view.frame.width - 0.5));
            }
            
        }

    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
            if scrollView.isMember(of: UIScrollView.self){
                if scrollView.contentOffset.x < -30 {
                    DRrawerViewController.sharedDrawerViewController.openDrawer(openDrawerWithDuration: 0.4)
                }
                
            
        }
    }
    //MARK: -判断今天是星期几
    func isDayNow(date:Date,dateModel:AstroModel) -> Bool{
        
        let sunInformation = DateOperation.operation.getSunriseAndSet(sunrise: dateModel.sr, sunset: dateModel.ss)
        
        let isday = DateOperation.operation.isDay(nowDate: date, srDate: sunInformation.0, ssDate: sunInformation.1)
        
        return isday
        
    }

   


}
