//
//  DetailPageCell.swift
//  和风天气
//
//  Created by 樊树康 on 2017/2/19.
//  Copyright © 2017年 BlackSky. All rights reserved.
//

import UIKit

class DetailPageCell: UITableViewCell,ViewChartDataSource {
    var isDay :Bool?
    var dalegate:ViewChartDataSource?
    var height:CGFloat? = nil
    var width:CGFloat? = nil
   
    var tmpArray = TmpArray.init(max: [Int](), min: [Int](),image: [String](),weekArray: [String]())

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    static   func cellForRowAtindexPath(jsonModel:HeWeatherModel,tableView:UITableView,width:CGFloat,isDay:Bool) -> DetailPageCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailPageCell") as! DetailPageCell
        cell.width = width
        let dailyModel = (jsonModel.daily_forecast) as! [DailyModel]
        cell.isUserInteractionEnabled = false

        //判断白天晚上
        cell.isDay = isDay
        
        let date = Date()
        
        cell.tmpArray.weekArray = DateOperation.operation.setWeekday(today: date)
        
        for model in dailyModel
        {
         
            let tmpMinInt = Int(model.tmp.min)
            let tmpMaxInt = Int(model.tmp.max)
            
            cell.tmpArray.tmpMaxArray.append(tmpMaxInt!)
            cell.tmpArray.tmpMinArray.append(tmpMinInt!)
            if isDay {
                cell.tmpArray.imageArray.append(model.cond.code_d)
            }else{
            cell.tmpArray.imageArray.append(model.cond.code_n)
            }
        }

        var chartIsExit = false
        for view in cell.contentView.subviews{
            if view.isMember(of: ViewChart.self){
                chartIsExit = true
            }
        }
        
        if !chartIsExit
      {
        cell.addChart(tableView: tableView, cell: cell,width: width)
        }
        cell.backgroundColor = UIColor.clear
        return cell
        
    }

    
    func addChart(tableView:UITableView,cell:DetailPageCell,width:CGFloat){
        DispatchQueue.global(qos: .userInteractive).async{

        let height = tableView.rowHeight
        
        let indexX = [0,1,2,3,4,5,6]
        let indexY = cell.tmpArray
        let number = CGFloat(indexX.count)
  
            DispatchQueue.main.async
                {
                    let view = ViewChart.init(frame: CGRect.init(x: 0, y: 0 , width: width , height:height))
                    view.backgroundColor = UIColor.clear
                    self.dalegate = view

                    self.getParmer(scale: number, frame: view.frame, data1: indexX, data2: indexY)

                    cell.contentView.addSubview(view)
            }

        }
    }
    
    //实现协议的方法 传递绘制参数
    func getParmer(scale: CGFloat, frame: CGRect, data1: [Int], data2: TmpArray) {
      
        self.dalegate?.getParmer(scale: scale, frame: frame, data1: data1, data2: data2)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


struct TmpArray {
    var tmpMaxArray:[Int]
    var tmpMinArray:[Int]
    var imageArray: [String]
    var weekArray:[String]
    init(max:[Int],min: [Int],image:[String],weekArray:[String]) {
        self.tmpMaxArray = max
        self.tmpMinArray = min
        self.imageArray = image
        self.weekArray = weekArray
    }
    

}
