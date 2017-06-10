//
//  SuggestCell.swift
//  和风天气
//
//  Created by 樊树康 on 2017/5/9.
//  Copyright © 2017年 BlackSky. All rights reserved.
//

import UIKit

class SuggestCell: UITableViewCell {
    //降水量 mm
    @IBOutlet weak var pcpn: UILabel!
    //降水概率
    
    @IBOutlet weak var pop: UILabel!
    
    //相对湿度 %
    @IBOutlet weak var hum: UILabel!
    //风向
    @IBOutlet weak var dir: UILabel!
    //风速 kmph
    @IBOutlet weak var spd: UILabel!
    //风力等级
    @IBOutlet weak var sc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static   func cellForRowAtindexPath(jsonModel:HeWeatherModel,tableView:UITableView) -> SuggestCell {
 
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SuggestCell
        
        cell.isUserInteractionEnabled = false
        let dailyModel = ( (jsonModel.daily_forecast) as! [DailyModel]).first
        cell.pcpn.text = dailyModel!.pcpn + " mm"
        cell.pop.text = dailyModel?.pop
        cell.hum.text = (dailyModel?.hum)! + " %"
        cell.dir.text = dailyModel?.wind.dir
        cell.spd.text = (dailyModel?.wind.spd)! + " kmph"
        cell.sc.text = dailyModel?.wind.sc
        cell.backgroundColor = UIColor.clear
        return cell
        
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
