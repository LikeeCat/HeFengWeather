//
//  RegisterViewController.swift
//  和风天气
//
//  Created by 樊树康 on 17/3/23.
//  Copyright © 2017年 猫鼬鼠. All rights reserved.
//
import UIKit
import LeanCloud
class RegisterViewController: UIViewController,UITextFieldDelegate{
    //确认密码
    @IBOutlet weak var confirmPassWord: UITextField!
    //输入密码
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var userName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "splash_image_blue_bg01_640x960.jpg")!)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passWord.delegate = self
        userName.delegate = self
    }
    //MARK: -注册
    @IBAction func Register(_ sender: AnyObject)
    {
        
        if (userName.text! == "" || passWord.text! == "" || confirmPassWord.text! == "") {
            let emptyAlert = UIAlertController.init(title: "提示", message: "用户名或密码为空", preferredStyle: .alert)
            let hel = UIAlertAction.init(title: "知道了", style: .default)
            emptyAlert.addAction(hel)
            present(emptyAlert, animated: true, completion: nil)

        }
        else{
            let query = LCQuery.init(className:"UserTable")
            query.whereKey("userName", .equalTo(userName.text!))
            var isExit = false
            query.find
                { (result) in
                    if (result.objects?.count)! > 0
                    {
                        isExit = true
                        self.popAlert(registerResult: isExit)
                    }
                    else
                    {
                let user = UserTable()
                user.userName = LCString(self.userName.text!)
                user.passWord = LCString(self.passWord.text!)
                user.save()
                let notifacation = Notification.init(name: Notification.Name(rawValue: "传递用户"), object: user, userInfo: nil)
                NotificationCenter.default.post(notifacation)
                self.popAlert(registerResult: isExit)
                    }
                    
            }
        }
    }
    @IBAction func dismiss(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: -弹出注册结果
    func popAlert(registerResult:Bool){
        let succeedAlert = UIAlertController.init(title: "注册结果", message: "恭喜您注册成功", preferredStyle: .alert)
        let failedAlert = UIAlertController.init(title: "注册结果", message: "注册失败，用户名已被使用或者密码输入错误", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "好", style: .default) { (ok) in
            self.dismiss(animated: true, completion: nil)
        }
        let hel = UIAlertAction.init(title: "知道了", style: .default)
        succeedAlert.addAction(hel)
        failedAlert.addAction(hel)
        if registerResult {
            present(failedAlert, animated: true, completion: nil)
        }else{
            present(succeedAlert, animated: true, completion: nil)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
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
