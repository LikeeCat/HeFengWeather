//
//  FileOperation.swift
//  和风天气
//
//  Created by 樊树康 on 17/3/22.
//  Copyright © 2017年 懒懒的猫鼬鼠. All rights reserved.
//

import Foundation

struct FileOperation {
    
    //単例
   static let fileOperation = FileOperation()
    
    //是否首次启动
   static let isFirstStart = UserDefaults.standard.bool(forKey: "firstLaunch")
    //文件管理
   static let fileManager = FileManager.default
    //获取沙盒的根目录
   static let rootPath =  NSHomeDirectory() as! NSString
    //获取Documents文件夹
   static let docPath = "Documents"
    //定义我的城市列表
   static let userCityList = "MyCityList.plist"
    //所有的城市列表
   static let AllCityList = "CityList.plist"
    
    //MARK: -检测文件是否存在
   static func isExit(folder:String,fileName:String) -> Bool {
        let docPath = rootPath.appendingPathComponent(folder) as! NSString
        
        let filePath = docPath.appendingPathComponent(fileName)

        let isExited =  self.fileManager.fileExists(atPath: filePath)
        print(filePath)
        return isExited
    }
    //MARK: -在制定位置创建文件
   static  func creatFilePath(folder:String,fileName:String) -> String {
    
       let folderPath = rootPath.appendingPathComponent(folder) as! NSString
        
        let filePath = folderPath.appendingPathComponent(fileName)
        
        return filePath
        
    }
    
    static func getDocPath() -> NSString{
        let  docPath = rootPath.appendingPathComponent(self.docPath)
        return docPath as NSString
        
    }
    
   // MARK: -搜索函数
    func search(key:String,array: [[String]] ) ->[[String]]{
        
        let searchString = "SELF CONTAINS" + " '" + key + "'"
        var arr = [[String]]()
        for citycontent in array {
//            let resultArray =  (citycontent[1] as! NSArray).filtered(using: NSPredicate.init(format: searchString))
//            arr.append(citycontent[1])
            if citycontent[1].contains(key){
                arr.append(citycontent)
            }
        }
//        let searchArray = arr as! NSArray
//        
//        let resultArray =  searchArray.filtered(using: NSPredicate.init(format: searchString))
//        for citycontent in array{
//        
//        }
//        return resultArray as! [String]
        return arr
        
        
    }
    
    // MARK: -用户是否登录
    static func userLogin() -> Bool{
     let isLogin = UserDefaults.standard.bool(forKey: "login")
     return isLogin
    }
    
    //MARK:- 城市是否存在
    func cityIsExit(key:String,array:[String]) ->Bool{
        let searchString = "SELF CONTAINS" + " '" + key + "'"
        
        let searchArray = array as! NSArray
        
        let resultArray =  searchArray.filtered(using: NSPredicate.init(format: searchString))
        
        return  resultArray.isEmpty ? false : true
    }
}
