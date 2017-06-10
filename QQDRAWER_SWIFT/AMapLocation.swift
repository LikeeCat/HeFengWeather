//  AMapLocation.swift
//  和风天气
//
//  Created by 樊树康 on 2016/10/6.
//  Copyright © 2017年 懒懒的猫鼬鼠. All rights reserved.
//


import Foundation

struct Location {
    
    private func configAccuracy() -> AMapLocationManager{
        let manager = AMapLocationManager()
        
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.locationTimeout = 3
        manager.reGeocodeTimeout = 3
        
        return manager
    }
    
    func configManager() -> AMapLocationManager  {
        let mapManager = configAccuracy()
        return mapManager
    }
    
    static let singleLocation = Location()
    
    //MARK: - 调用定位信息
    func locationResult(mapManager:AMapLocationManager,closer_: @escaping (_ getRecode:AMapLocationReGeocode) -> ())
    {
        mapManager.requestLocation(withReGeocode: true)
        {
            (location, regeocode, error) in
            if ((error) != nil)
            {
               let error = error as! NSError
                
                self.locationResult(mapManager: mapManager, closer_: closer_)
                
                if((Int((error.code)) == AMapLocationErrorCode.locateFailed.rawValue))
                     {
                    return
                
            }
        }
            if (regeocode != nil)
            {
                
                closer_(regeocode!)
            }
        }        
        
    }
}
