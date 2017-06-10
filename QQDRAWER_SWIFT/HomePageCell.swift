//
//  HomePageCell.swift
//  和风天气
//
//  Created by 樊树康 on 2017/2/19.
//  Copyright © 2017年 BlackSky. All rights reserved.
//

import UIKit

class HomePageCell: UITableViewCell {

    @IBOutlet weak var condTxt: UILabel!
    @IBOutlet weak var qlty: UILabel!
    @IBOutlet weak var pm25: UILabel!
    @IBOutlet weak var tomorrowCondTxt: UILabel!
    @IBOutlet weak var todayCondTxt: UILabel!
    @IBOutlet weak var tomorrowTmp: UILabel!
    @IBOutlet weak var todayTmp: UILabel!
    @IBOutlet weak var tomorrowImg: UIImageView!
    @IBOutlet weak var todayImg: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var tmp: UILabel!
    var isday:Bool?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static   func cellForRowAtindexPath(jsonModel:HeWeatherModel,tableView:UITableView,isday:Bool) -> HomePageCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageCell") as! HomePageCell
        cell.isday = isday
        cell.isUserInteractionEnabled = false
        cell.creatCellDataObject(jsonModel: jsonModel, cell: cell)
        return cell
        
    }
    
    
    func creatCellDataObject(jsonModel:HeWeatherModel,cell:HomePageCell) {
        
        let str = jsonModel.now.tmp
        cell.tmp.text = str
        cell.location.text = jsonModel.basic.city
        if jsonModel.aqi == nil {
            cell.pm25.text = "抱歉"
            cell.qlty.text = "暂无空气质量数据"
        }else{
        cell.pm25.text = "pm2.5: " + jsonModel.aqi.city.pm25
        
        cell.qlty.text =  "空气质量：" + jsonModel.aqi.city.qlty
        }
        let date = Date()
        let dailyModel = (jsonModel.daily_forecast) as! [DailyModel]
        let todayModel = dailyModel[0]
        let  tomorrowModel = dailyModel[1]
       
        cell.condTxt.text = jsonModel.now.cond.txt
        cell.todayTmp.text = todayModel.tmp.max + "/" +  todayModel.tmp.max
        cell.tomorrowTmp.text = tomorrowModel.tmp.min + "/" + tomorrowModel.tmp.max

        if cell.isday!{
            cell.todayImg.image = cell.getCellImage(code: todayModel.cond.code_d,istoday: true)
            cell.tomorrowImg.image = cell.getCellImage(code: tomorrowModel.cond.code_d,istoday:false)

        }
        else{
            cell.todayImg.image = cell.getCellImage(code: todayModel.cond.code_n,istoday: true)
            cell.tomorrowImg.image = cell.getCellImage(code: tomorrowModel.cond.code_n,istoday: false)

        }
       
        cell.todayCondTxt.text = cell.isday! ? todayModel.cond.txt_d : todayModel.cond.txt_n
        cell.tomorrowCondTxt.text = cell.isday! ? tomorrowModel.cond.txt_d : tomorrowModel.cond.txt_n
        cell.backgroundColor = UIColor.clear
    }
    
//    func isDay(date:Date,dateModel:AstroModel) -> Bool{
//        
//         let sunInformation = DateOperation.operation.getSunriseAndSet(sunrise: dateModel.sr, sunset: dateModel.ss)
//        
//         let isday = DateOperation.operation.isDay(nowDate: date, srDate: sunInformation.0, ssDate: sunInformation.1)
//        
//        return isday
//        
//    }
//    
    
    func getCellImage(code:String,istoday:Bool) -> UIImage {
        
        DispatchQueue.global(qos: .userInteractive).async{

        let image = UIImage.getImageFromInternet(urlString: NetworkHelper.imageURLHeader + code + ".png")
            DispatchQueue.main.async{
                
                if istoday{
                    self.todayImg.image = image
                }
                else{
                    self.tomorrowImg.image = image
                }
            }
    }
        return UIImage.init()
    
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
