//
//  UserRelationShipTable.swift
//  和风天气
//
//  Created by 樊树康 on 2017/4/9.
//  Copyright © 2017年 BlackSky. All rights reserved.
//

import Foundation
import LeanCloud
class UserRelationShipTable:LCObject{
    
    dynamic var own: UserTable?
    dynamic var ownName:LCString?
    dynamic var attion: UserTable?
    dynamic var attionName:LCString?
    override static func objectClassName() -> String {
        return "UserRelationShipTable"
    }
    
    //MARK:-添加好友
    static func addfriend(own:NSString,attion:NSString,complete:@escaping (_ isOk:Bool)->()){
        
        let queryOwnUser = LCQuery.init(className:"UserTable")
        queryOwnUser.whereKey("userName", .equalTo(own as!String))
        
        let queryattion = LCQuery.init(className:"UserTable")
        queryattion.whereKey("userName", .equalTo(attion as! String))
        var isok = false

        let query = queryattion.or(queryOwnUser)
        query.find { (result) in
            if result.objects?.count == 2
            {
                let userRelation = UserRelationShipTable()
                let user = result.objects?.first as! UserTable
                if user.userName?.value == own as!String{
                    userRelation.own = user
                    userRelation.ownName = user.userName
                    userRelation.attion = result.objects?.last as! UserTable
                    userRelation.attionName = (result.objects?.last as! UserTable).userName
                    userRelation.save()
                }
                else{
                    userRelation.attion = user
                    userRelation.attionName = user.userName
                    userRelation.ownName =  (result.objects?.last as! UserTable).userName
                    userRelation.own = result.objects?.last as! UserTable
                    userRelation.save()
                }
                isok = true
              }
            else{
                print("添加失败")
            }
           complete(isok)
        }
        
    }
    
    //MARK:-获取关注列表
    static func getMyAttionUser(own:NSString,complation:@escaping (_ userResult:[UserRelationShipTable])->()){
        print(own)
        let query = LCQuery.init(className: self.objectClassName())
        query.whereKey("ownName", .equalTo(own as! String))
        query.find { (results) in
            if (results.objects?.count)! > 0{
            let users = results.objects as! [UserRelationShipTable]
            complation(users)
            }
            else{
                complation([UserRelationShipTable]())
            }
        }
        
    }
    //MARK:-获取关注我的列表
    static func getAttionMeUser(own:NSString,complation:@escaping (_ userResult:[UserRelationShipTable])->()){
        let query = LCQuery.init(className: self.objectClassName())
        query.whereKey("attionName", .equalTo(own as! String))
        query.find { (results) in
            let users = results.objects as! [UserRelationShipTable]
            complation(users)
        }
        
    }
    //MARK:-取消关注

    static func unfollowUser(own:NSString,attion:NSString,complete:@escaping (_ isOk:Bool)->()){
        
        let queryOwnUser = LCQuery.init(className:self.objectClassName())
        queryOwnUser.whereKey("ownName", .equalTo(own as!String))
        
        let queryattion = LCQuery.init(className:self.objectClassName())
        queryattion.whereKey("attionName", .equalTo(attion as! String))
        var isok = false
        
        let query = queryattion.and(queryOwnUser)
        query.find { (result) in
            if (result.objects != nil){
           let deleteObj = result.objects?.first as! UserRelationShipTable
            deleteObj.delete({ (isdelete) in
                complete(isok)
                
            })
            }
        }
        
    }
    
}
