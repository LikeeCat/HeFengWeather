//
//  UIImageExtension.swift
//  和风天气
//
//  Created by 樊树康 on 17/3/1.
//  Copyright © 2017年 懒懒的猫鼬鼠. All rights reserved.
//

import UIKit

extension UIImage
{
    
    
    static  func getImageFromInternet(urlString:String) -> UIImage
    {
        
        let url = URL.init(string: urlString)
        let data = NSData.init(contentsOf: url! as URL)
        let image =  UIImage.init(data: data as! Data)
        return image!
    }
}




