//
//  MainViewController.swift
//  QQDRAWER_SWIFT
//
//  Created by 樊树康 on 17/3/23.
//  Copyright © 2017年 猫鼬鼠. All rights reserved.
//
import UIKit
import JSONModel
class MainViewController: UITabBarController{
    
    var postButton:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.CreatNavBar()
        self.setPostButton()
        UITabBar.appearance().backgroundColor = UIColor.red
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.alpha = 0.9
        
        // Do any additional setup after loading the view.
        
    }
    
    func setPostButton(){
        postButton = UIButton.init(frame: CGRect.init(x: self.tabBar.center.x - 40, y: self.tabBar.center.y - 90, width: 80, height: 80))
        postButton?.setImage(UIImage.init(named: "live_camera_normal@2x"), for: .normal)
        postButton?.addTarget(self, action: #selector(postMessage), for: .touchUpInside)
        
        self.view.addSubview(postButton!)
        self.postButton?.isHidden = true
    }
    
    func postMessage(){
        let postVC = PostDiscoverViewController()
        self.present(postVC, animated: true) { 
            print("发送消息")
        }
    }
    
    func CreatNavBar() {
       
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 1
        view.layer.shadowOffset = CGSize(width: -1, height: -1)
        view.layer.shadowOpacity = 0.8
        
        self.addChildViewController(WeatherViewController.init() , defaultImageName: "tab_conversation",selectedImageName: "tab_conversation_click",title:"天气")
        self.addChildViewController(DynamicViewController.init(), defaultImageName: "tab_qworld_nor", selectedImageName: "tab_qworld_press",title:"朋友圈")
        
        if FileOperation.userLogin(){
            self.addChildViewController(MyViewController.init(), defaultImageName: "tab_buddy_nor",selectedImageName: "tab_buddy_press",title:"我的")
        }else{
            self.addChildViewController(LoginViewController.init(), defaultImageName: "tab_buddy_nor", selectedImageName: "tab_buddy_press",title:"我的")
        }
        
    }
       
   

    func addChildViewController(_ childController: UIViewController, defaultImageName: NSString, selectedImageName: NSString ,title:String) {
        
        let navViewController = UINavigationController.init(rootViewController: childController)
        
        self.addChildViewController(navViewController)
    
        childController.tabBarItem.image = UIImage.init(named: defaultImageName as String)
        childController.tabBarItem.selectedImage = UIImage.init(named: selectedImageName as String)
        childController.tabBarItem.title = title
        navViewController.navigationBar.isHidden = true
        if childController.isMember(of: WeatherViewController.self) {
            navViewController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            
            navViewController.navigationBar.shadowImage = UIImage()
            childController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "run10"), style: .plain , target: self, action: (#selector(
                MainViewController.openDrawer)))
        }
        
    }
    
    
    /// 打开抽屉效果
    func openDrawer(){
        DRrawerViewController.sharedDrawerViewController.openDrawer(openDrawerWithDuration: 0.2)
    }
    
    /// 遮罩按钮手势的回调
    ///
    /// - parameter pan: 手势
    func panGestureRecognizer(pan: UIPanGestureRecognizer) {
        DRrawerViewController.sharedDrawerViewController.panGestureRecognizer(pan: pan)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title != "朋友圈" {
            self.postButton?.isHidden = true
        }
        else{
            let user = UserDefaults.standard.value(forKey: "loginUser") as? String
            if (user == "none" || user == "" || user == nil)
            {
                
                self.postButton?.isHidden = true
            }
            else
            {
            self.postButton?.isHidden = false
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
