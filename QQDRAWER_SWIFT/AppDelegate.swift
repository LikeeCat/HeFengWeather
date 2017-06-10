//
//  AppDelegate.swift
//  QQDRAWER_SWIFT
//
//  Created by 樊树康 on 17/3/23.
//  Copyright © 2017年 猫鼬鼠. All rights reserved.
//

import UIKit
import LeanCloud
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let locationCity = "LocationCity"

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        if !FileOperation.isExit(folder: "Documents", fileName: "CityList.plist"){
            self.getAllCity()
        }

        LeanCloud.initialize(applicationID: "VJwCgWQYIPacfeOI7pxpXSgp-gzGzoHsz", applicationKey: "4LsyJc4v7hyG3u4yoDadrLBR")

        ConfigAMapLocation()
        UserDefaults.standard.set("false", forKey: "login")
        UserDefaults.standard.set("none", forKey: "loginUser")
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let maxWidth = UIScreen.main.bounds.width * 0.9
        self.window?.rootViewController = DRrawerViewController.drawerWithViewController(_leftViewcontroller: LeftViewController.init(),_mainViewController: MainViewController.init(),DrawerMaxWithd:maxWidth)
        
        UIApplication.shared.statusBarStyle = .lightContent
       
       UINavigationBar.appearance().tintColor = UIColor.white
       UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        //为导航栏设置字体颜色等
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
   
    
    
    func getAllCity()
    {
        DispatchQueue.global(qos: .userInteractive).async
            {
                let urlString = "http://files.heweather.com/china-city-list.json"
                let url = URL.init(string: urlString)
                var citylist = [String:[String]]()
                do{
                    var string = try String.init(contentsOf: url!)
                    let modelList = try  CitylistModel.arrayOfModels(from: string) as! [CitylistModel]
                    for city in modelList
                        
                    {
                        var arr = [city.leaderZh,city.cityZh]
                        
                        citylist.updateValue(arr as! [String], forKey: city.id)
//                        citylist.append(city.cityZh)
                    }
                    
                    
                    let docPath = FileOperation.getDocPath() as! NSString
                    let filePath = docPath.appendingPathComponent(FileOperation.AllCityList)
                    let writeArray = citylist as! NSDictionary
                    writeArray.write(toFile: filePath, atomically: true)
                }
                catch{
                    print(error)
                }
                DispatchQueue.main.async
                    {
                        print("写入城市列表完成👌")
                }
        }
        
    }

    func ConfigAMapLocation(){
    
        AMapServices.shared().apiKey = "284589c0cade4061ba3092fff3367b37"
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.set("false", forKey: "login")
        UserDefaults.standard.set("none", forKey: "loginUser")
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

