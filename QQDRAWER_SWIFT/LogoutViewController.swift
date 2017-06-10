//
//  LogoutViewController.swift
//  和风天气
//
//  Created by 樊树康 on 17/3/23.
//  Copyright © 2017年 猫鼬鼠. All rights reserved.
//
import UIKit

class LogoutViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var userName = ""
    var imageName = ""
    var settingArray = ["昵称","性别","年龄","生日","个性签名"]
    var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()

        self.navigationItem.title = "账户管理"
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        super.navigationController?.navigationBar.isHidden = true
    }
    func setUI() {
        self.view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "splash_image_blue_bg01_640x960.jpg")!)
        self.tableView = UITableView.init(frame: self.view.frame, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = UIColor.clear
        tableView?.separatorStyle = .none
        self.view.addSubview(tableView!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return settingArray.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cell"
        tableView.dequeueReusableCell(withIdentifier: cellId)

        if indexPath.section == 0{
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellId)
            
            cell.textLabel?.text = settingArray[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = "mimi"
            case 1:
                cell.detailTextLabel?.text = "女"
            case 2:
                cell.detailTextLabel?.text = "20"
            case 3:
                cell.detailTextLabel?.text = "1993-3-20"
            case 4:
                cell.detailTextLabel?.text = "欢迎大家和我做朋友"
            default:
                break
            }
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.textColor = UIColor.white
            return cell
        }
        else{
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: cellId)
            cell.textLabel?.text = "注销登录"
            cell.backgroundColor = UIColor.clear

            cell.textLabel?.textColor = UIColor.white
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            UserDefaults.standard.set("false", forKey: "login")
            UserDefaults.standard.set("none", forKey: "loginUser")
          self.navigationController?.viewControllers.remove(at: 0)
          self.navigationController?.viewControllers.insert(LoginViewController.init(), at: 0)
            self.navigationController?.popViewController(animated: true)
            
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = ["个人信息","账号管理"]
        
        return section == 0 ? sectionTitle[0] : sectionTitle[1]
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
