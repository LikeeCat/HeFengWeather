//
//  DiscoverTable.swift
//  和风天气
//
//  Created by 樊树康 on 2017/4/17.
//  Copyright © 2017年 BlackSky. All rights reserved.
//

import Foundation
import LeanCloud

class DiscoverTable:LCObject{
    
    
    dynamic var isPraise:LCBool?
    dynamic var praiseCount:LCNumber?
    dynamic var location:LCString?
    dynamic var createTime:LCString?
    dynamic var type:LCNumber?
    dynamic var text:LCString?
    dynamic var imageCount:LCNumber?
    dynamic var replyCount:LCNumber?
    dynamic var userName:LCString?
    dynamic var praiseUserName:LCString?
    dynamic var commentCount:LCNumber?
    dynamic var image: LCData?
    
    
    override static func objectClassName() -> String {
        return "DiscoverTable"
    }
    
    static func  findAllObject(complete:@escaping ([DiscoverTable])->()){
        let query = LCQuery.init(className: self.objectClassName())
        
        query.whereKey("createdAt", .descending)
        
            query.find { (result) in
                complete((result.objects) as![DiscoverTable])
        }
    }
    
    static func getmyAttionUser(userName:NSString,complete:@escaping([DiscoverTable])->()){
        
        if userName != "none"{
          UserRelationShipTable.getMyAttionUser(own: userName) { (attionList) in
            
            if attionList.count <= 0{
                complete([DiscoverTable]())

            }
            else{
            var attionUserList =  [String]()
            var baseString = "select * from DiscoverTable where "
            for attion in attionList{
                if attion  == (attionList.last)!{
                    let value = "'\((attion.attionName?.value)!)'"
                    baseString += " userName = \(value)"
                }
                else{
                    let value = "'\((attion.attionName?.value)!)'"

                    baseString += " userName = \(value) or"
                }
                
            }
            baseString += " or userName = '\(userName as!String)'"
            baseString += " order by createdAt desc"
            LCCQLClient.execute(baseString, completion: { (jieguo) in
                
                switch jieguo {
                case .success(let result):
                    // todos 就是满足条件（status == 0 并且 priority == 1）的 Todo 对象集合
                    
                    let todos = result.objects as! [DiscoverTable]
                    complete(todos)
                case .failure(let error):
                    print(error)
                }
            })
      
        }
            }
        }else{
            complete([DiscoverTable]())
        }
    
    }
    static func praise(record:DiscoverTable,praiseUser:NSString, complete:@escaping (_ praiserUserString:NSString)->()){
        var userNameLable:String?
  
        //判读第一次点赞
        
        if record.praiseUserName == nil || record.praiseUserName?.value == ""{
            record.praiseUserName = LCString(praiseUser as! String)
            record.praiseCount = LCNumber.init((record.praiseCount?.value)! + 1)

        }
        //第二次点赞
        else {
            if record.praiseUserName?.value.contains(praiseUser as!String) == true{
            }
            else{
                record.praiseCount = LCNumber.init((record.praiseCount?.value)! + 1)
                record.praiseUserName = LCString((record.praiseUserName?.value)!  + "、"  + (praiseUser as String) as! String)
            }
        }
        complete(record.praiseUserName?.value as! NSString)

        record.save { (succeed) in
//            print("保存成功")
    
        }
    }
    
    static func deleteDiscover(record:DiscoverTable) -> Bool{
        var isOk = false
        
        record.delete { (ok) in
            if ok.isSuccess{
                let query = LCQuery.init(className: "CommentTable")
                query.whereKey("DiscoverID", .equalTo(record))
                query.find({ (result) in
                    if (result.objects?.count)! > 0{
                        let comments = result.objects as! [CommentTable]
                        CommentTable.delete(comments)
                        isOk = true
                    }
                })
            }
        }
        return isOk
    }
    
    
    static func findRecordComment(record:DiscoverTable,complete:@escaping(_ status: Bool,_ result:[CommentTable]) -> ())
    {
        let query = LCQuery.init(className: "CommentTable")
        
//        let innerQuery = LCQuery.init(className: "UserTable")
//        innerQuery.whereKey("userName", .ascending)
        
        query.whereKey("DiscoverID", .equalTo(record))
        
        var commentUser = [UserTable]()

        query.find { (result) in

            if(result.objects?.count != 0 && result.isFailure == false){
                let records = result.objects as![CommentTable]
//                 var arr = [String]()
//                for comment in records{
//                    arr.append((comment.commentContent?.value)!)
//                    commentUser.append(comment.commentUser!)
//                }
                complete(true,records)
            }else{
                complete(false,[CommentTable]())
            }
        }
        

    }
    //评论数目递增
    static func commentRecordCount(record:DiscoverTable){
        if  (record.commentCount == nil) {
            record.commentCount = 0
        }
        else{
           record.commentCount =  LCNumber((record.commentCount?.value)! + 1)
        }
        record.save()
    }
}
