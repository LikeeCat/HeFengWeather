//  chart.swift
//  和风天气
//
//  Created by 樊树康 on 2016/10/6.
//  Copyright © 2017年 懒懒的猫鼬鼠. All rights reserved.
//
import UIKit

//MARK: -定义ChartView的代理
protocol ViewChartDataSource {
    
    func getParmer(scale:CGFloat,frame:CGRect,data1:[Int],data2:TmpArray)
    
}

class ViewChart: UIView,ViewChartDataSource {
   
    var scale:CGFloat? = nil
    var cgFrame:CGRect? = nil
    var data1 = [Int]()
    var data2 = [Int]()
    var tmpArray: TmpArray?

    override  func draw(_ rect: CGRect) {
        
        guard (scale != nil && cgFrame != nil && data1.count != 0 && data2.count != 0) else {
            return
        }
        creatCoordinateSystem(scale: scale!, frame: cgFrame!, data1: data1, data2: data2)
    }
    
    //实现协议的方法
    func getParmer(scale:CGFloat,frame:CGRect,data1:[Int],data2:TmpArray){
        
      self.scale = scale
      self.cgFrame = frame
      self.data1 = data1
      self.data2 = data2.tmpMinArray
        
      self.tmpArray = data2
    
    }
    
    //MARK: - 创建坐标系,绘制贝塞尔曲线
    func creatCoordinateSystem(scale:CGFloat,frame:CGRect,data1:[Int],data2:[Int]){
        //原点
        let orginalPoint = CGPoint.init(x: 40, y: frame.height-100)
        //X轴最大值
        let xMax = CGPoint.init(x: frame.width-10, y: orginalPoint.y)
        //x轴长度
        let xScale = Double((xMax.x - orginalPoint.x)/scale)
        //y轴最大值
        let yMax = CGPoint.init(x: frame.origin.x , y: frame.origin.y+50)
        //y轴的长度
        let yScale = Double(orginalPoint.y - yMax.y)
        let yValue = Double((self.tmpArray?.tmpMinArray.max())! - (self.tmpArray?.tmpMinArray.min())!)
        let yMin = Double((self.tmpArray?.tmpMinArray.min())!)
        let path3 = UIBezierPath()
        var pointXArray = [Double]()
        var pointYArray = [Double]()
        let fillColor = UIColor.white
        fillColor.set()
        
        path3.fill()
        //计算point的x坐标
        for x in data1{
            var xPoint = Double(x) * xScale + Double(orginalPoint.x)
            pointXArray.append(xPoint)
        }
        
        //计算Point的y坐标
        for y in data2{
            var yPoint = Double(orginalPoint.y) -  (Double( Double(y) - yMin)
            / yValue * yScale )
            pointYArray.append(yPoint)
        }
       //绘制贝塞尔曲线
        for x in 0..<pointXArray.count{
            if x == 0 {
                let point =  CGPoint.init(x: pointXArray[x], y: pointYArray[x])
                path3.move(to: point)
                self.draWlabel(point: point, index: x, temArray: self.tmpArray!)
                self.drawImageForChart(index: x, tempArray: tmpArray!, point: point,orginalPoint: orginalPoint)
            }
            else{
                let controlPoint = pointXArray[x] - pointXArray[x-1]
               
                let drawPoint =  CGPoint.init(x: pointXArray[x], y: pointYArray[x])
                path3.addLine(to: CGPoint.init(x:pointXArray[x],y:pointYArray[x]))
                self.draWlabel(point: drawPoint, index: x, temArray: tmpArray!)
                self.drawImageForChart(index: x, tempArray: tmpArray!, point: drawPoint,orginalPoint: orginalPoint)
                if x == pointXArray.count-1 {
                    path3.stroke()
                }
            }
            
        }
    }
    
    //                path3.addCurve(to: CGPoint.init(x: pointXArray[x], y: pointYArray[x]), controlPoint1: CGPoint.init(x: controlPoint/2 + pointXArray[x-1], y: pointYArray[x-1] ),  controlPoint2: CGPoint.init(x: controlPoint/2 + pointXArray[x-1], y: pointYArray[x]))
    //                path3.addQuadCurve(to:CGPoint.init(x: pointXArray[x], y: pointYArray[x]), controlPoint: CGPoint.init(x: controlPoint/2 + pointXArray[x-1], y: pointYArray[x-1]))


    //MARK : -加载天气温度
    func draWlabel(point:CGPoint,index:Int,temArray:TmpArray) {
        
        let pointHeader = UILabel.init(frame: CGRect.init(x: point.x - 5, y: point.y - 25 , width: 30, height: 30))
        pointHeader.text = String(temArray.tmpMaxArray[index])
        pointHeader.font = UIFont.boldSystemFont(ofSize: 10)
        pointHeader.textColor = UIColor.white
        
        let pointFooter = UILabel.init(frame: CGRect.init(x: point.x - 5, y: point.y - 7 , width: 30, height: 30))
        pointFooter.text = String(temArray.tmpMinArray[index])
        pointFooter.font = UIFont.boldSystemFont(ofSize: 10)
        pointFooter.textColor  = UIColor.white
        self.addSubview(pointHeader)
        self.addSubview(pointFooter)
        
        
}
    //MARK: -加载天气图片
    
    func drawImageForChart(index:Int,tempArray:TmpArray,point:CGPoint,orginalPoint:CGPoint) {
        
        let imageWidth = CGFloat(Int( self.frame.width ) / tempArray.tmpMaxArray.count) - 30
        let imageView = UIImageView.init(frame: CGRect.init(x: point.x -
        5, y:orginalPoint.y+40 , width: imageWidth, height:imageWidth))
        let image = getCellImage(code: (tmpArray?.imageArray[index])!,imageView: imageView)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let imageViewOrginalPoint = imageView.frame.origin
        self.drwaImageViewDescribe(index: index, tempArray: tempArray, point: imageViewOrginalPoint, width: imageWidth)
        
        self.addSubview(imageView)
    }
    //MARK: -获取天气图片
    func getCellImage(code:String,imageView:UIImageView) -> UIImage {

        DispatchQueue.global(qos: .userInteractive).async{
            let image = UIImage.getImageFromInternet(urlString: NetworkHelper.imageURLHeader + code + ".png")
            

        
            DispatchQueue.main.async{
                imageView.image = image
            }

        }
        return UIImage.init()
        
    }
    //MARK: -加载天气图片
    func drwaImageViewDescribe(index:Int,tempArray:TmpArray,point:CGPoint,width:CGFloat)  {
        
        let label = UILabel.init(frame: CGRect.init(x:point.x , y:point.y + width , width: width*2.5, height: width))
        label.text = tempArray.weekArray[index]
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 10)
        self.addSubview(label)
    }

// MARK:-贝塞尔曲线连线
 func drawLine(moveToPoint:CGPoint,addLineToPoint:CGPoint,path:UIBezierPath){
    
    path.move(to: moveToPoint)
    
    path.addLine(to: addLineToPoint)
    
    path.lineWidth = 1
    
    path.lineJoinStyle = .round
    
    path.lineCapStyle = .round
    
    path.stroke()
}


}


