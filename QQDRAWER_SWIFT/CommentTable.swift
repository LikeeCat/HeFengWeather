//
//  CommentTable.swift
//  和风天气
//
//  Created by 樊树康 on 2017/4/17.
//  Copyright © 2017年 BlackSky. All rights reserved.
//

import Foundation
import LeanCloud

class CommentTable:LCObject{
    
    //关联动态
    dynamic var DiscoverID:DiscoverTable?
    
    //发送人关联
    dynamic var postUser:UserTable?
    dynamic var postUserName:LCString?
    //评论人关联
    dynamic var commentUser:UserTable?
    
    //评论内容
    dynamic var commentContent:LCString?
    dynamic var commentUserName:LCString?
    
    override static func objectClassName() -> String {
        return "CommentTable"
    }

    static func insertComment(comment:CommentTable){
        comment.save()
    }
    
    static func getMyInformation(name:NSString,complete:@escaping(_ status: Bool,_ result:[CommentTable]) -> ()){
        
        if(name).boolValue{
        let query = LCQuery.init(className: "CommentTable")
        query.whereKey("postUserName", .equalTo(name as! String))
        query.find { (result) in
            if result.objects?.count != 0{
            let comments = result.objects as! [CommentTable]
                complete(true,comments)
            }else{
                complete(false,[CommentTable]())
            }
        }
    }
    else
        {
    complete(false,[CommentTable]())

    }
    }
}
