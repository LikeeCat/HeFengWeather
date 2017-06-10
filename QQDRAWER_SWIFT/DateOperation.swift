//
//  DateOperation.swift
//  和风天气
//
//  Created by 樊树康 on 2017/3/11.
//  Copyright © 2017年 BlackSky. All rights reserved.
//

import Foundation



class DateOperation {
    
    let calendar = Calendar.current
    
    static let operation = DateOperation()
    
    private init() {
        
    }
    //MARK: -获取日出日落的 Date 对象
    func getSunriseAndSet(sunrise:String,sunset:String) -> (Date,Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let srDate = dateFormatter.date(from: sunrise)
        
        let ssDate = dateFormatter.date(from: sunset)
        
        return(srDate!,ssDate!)
    }
    //MARK: -是否是白天
    
    func isDay(nowDate:Date,srDate:Date,ssDate:Date)->Bool{
        if ((srDate.compare(nowDate) == .orderedAscending || srDate.compare(nowDate) == .orderedSame) && (nowDate.compare(ssDate) == .orderedAscending) ) {
            return true
        }
        else{
            return false
        }
    }
    
    //MARK: - 根据当天的时间去计算本周的日期
    func setWeekday(today:Date) ->[String]
    {
        
        var weekArray =  ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
        
        let dateComp = calendar.component(.weekday, from: today)
        if weekArray[dateComp - 1] != "今天" {
            weekArray[dateComp - 1] = "今天"
            
        }
        var deleyeArray = [String]()
        for _ in 0..<(dateComp - 1)
        {
            deleyeArray.append(weekArray.removeFirst())
        }
        
        return weekArray+deleyeArray
        
    }
    
}
