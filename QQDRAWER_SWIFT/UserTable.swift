//
//  UserTable.swift
//  和风天气
//
//  Created by 樊树康 on 2017/4/8.
//  Copyright © 2017年 BlackSky. All rights reserved.
//

import Foundation
import LeanCloud
class UserTable : LCObject{
    
    dynamic var userName: LCString?
    dynamic var passWord: LCString?
    dynamic var nike: LCString?
    dynamic var sex: LCBool?
    dynamic var age: LCNumber?
    dynamic var birthday: LCDate?
    dynamic var isLogin: LCBool?
//    static var login = false 
    

    override static func objectClassName() -> String {
        return "UserTable"
    }
    
   static var CurrentUser = UserTable()
    
    //MARK: -登录成功
    static func loginSucceed (userName:String,passWord:String) -> Bool{
        
        var issucceed = false
        let query = LCQuery.init(className: self.objectClassName())
        query.whereKey("userName", .equalTo(userName))
        
        query.find { (result) in
            let user = result.objects?.first as! UserTable
            if passWord != user.passWord?.value{
//                print("登录失败")
                user.isLogin = false
            }else{
//                print("登录成功")
                user.isLogin = true
                issucceed = true
            }
        }
        
        return issucceed
    }
    
    //MARK:- 检查用户名和密码
    static func queryUserNameAndPassword(name:NSString,complete:@escaping (_ password:NSString) -> ())
    {
        let query = LCQuery.init(className: self.objectClassName())
        query.whereKey("userName", .equalTo(name as!String))
         query.find
        { (result) in
            if result.isSuccess != false && result.objects?.count != 0
            {
                let user = result.objects?.first as! UserTable
                let password = user.passWord?.value as! NSString
                
                complete(password)
                
                }
            else
            {
                let empty = "error" as! NSString
                complete(empty)
            }
        }

    }
    
    
 
    //MARK: -获取用户信息
    static func getInformationFromLeancloud(name:NSString,complete:@escaping (_ user:UserTable) -> ()){
        UserDefaults.standard.set(false, forKey: "login")
        let query = LCQuery.init(className: self.objectClassName())
        query.whereKey("userName", .equalTo(name as!String))
        query.find
            { (result) in
                if result.isSuccess != false && result.objects?.count != 0
                {
                    let user = result.objects?.first as! UserTable
                    
                    complete(user)
                }
        }
    }
    
}

