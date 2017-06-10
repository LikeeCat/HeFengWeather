//
//  NetworkHelpier.swift
//  
//
//  Created by 樊树康 on 2017/2/18.
//
//

import Foundation


struct NetworkHelper {
  
    static let imageURLHeader = "http://files.heweather.com/cond_icon/"
    static let baseURL = "https://free-api.heweather.com/v5/"
    static let personalKey = "&key=7b7b2605e91d46a19f1eaa79394435bc"
    static let netHelper =  NetworkHelper()
    
    private func `init`(){
        
    }
    
    enum RequestType:String {
        
        //7-10天天气预报
        case forecate = "forecate?"
        
        //实况天气
        case now = "now?"
        
        //每小时预报
        case hourly = "hourly?"
        
        //生活指数
        case suggestion = "suggestion?"
        
        //灾害预警
        case alarm = "alarm?"
        
        //获取所有数据一次性
        case weather = "weather?"
        
        func creatURLHeader(type:String) -> String {
            
            let urlHeader  =  NetworkHelper.baseURL + type
            
            return urlHeader
            
        }
        
    }
    
    
    func creatUrlRequest(cityName:String,type:RequestType) -> URL {
        
       
       let urlrequest = type.creatURLHeader(type: type.rawValue) + "city=" + cityName + NetworkHelper.personalKey
       let encoding = urlrequest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
       let url = URL.init(string: encoding!)
        return url!
        
    }
    
    
    
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
