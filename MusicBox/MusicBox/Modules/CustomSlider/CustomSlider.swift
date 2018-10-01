//
//  CustomSlider.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/3/28.
//  Copyright © 2018年 Bok Man. All rights reserved.
//

import UIKit

public enum SliderImageModel:Int {
    
    case color = 0
    
    case image = 1
    
}

class CustomSlider: UISlider {


    //左侧轨道的颜色
    var leftBarColor: UIColor?
    //右侧轨道的颜色
    var rightBarColor:UIColor?
    
    var leftImage:UIImage?
    
    var rightImage:UIImage?
    
    var sliderModel:SliderImageModel = .color
    //轨道高度
    var barHeight: CGFloat? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var barTipTitle:String = ""
    
    //初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置样式的默认值
        
        leftBarColor = UIColor.colorWithTheme()
        rightBarColor = UIColor.groupTableViewBackground
        leftImage = UIImage.imageWithColor(leftBarColor!)
        rightImage = UIImage.imageWithColor(rightBarColor!)
        barHeight = 20.0
        barTipTitle = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if sliderModel == .color {
            let leftTrackImage = createTrackImage(rect: rect, barColor: self.leftBarColor!,isdrawText: true)
            let rightTrackImage = createTrackImage(rect: rect, barColor: self.rightBarColor!,isdrawText: true)
            
            self.setMinimumTrackImage(leftTrackImage, for: .normal)
            self.setMaximumTrackImage(rightTrackImage, for: .normal)
        } else {
            let leftTrackImage = createTrackCustomImage(rect: rect, image: leftImage!,isdrawText: false) .resizableImage(withCapInsets: .zero)
            
            let rightTrackImage = createTrackCustomImage(rect: rect, image: rightImage!,isdrawText: true) .resizableImage(withCapInsets: .zero)
            
            self.setMinimumTrackImage(leftTrackImage, for: .normal)
            self.setMaximumTrackImage(rightTrackImage, for: .normal)
        }
        
        
    }
    
    //生成轨道图片
    func createTrackCustomImage(rect: CGRect,image:UIImage,isdrawText:Bool) -> UIImage {
        //开始图片处理上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        //绘制轨道背景
        context.draw(image.cgImage!, in: rect)
        // 绘制文字
        if isdrawText {
            let text:NSString = barTipTitle as NSString
            let label = UILabel()
            label.text = text as String
            label.font = UIFont.systemFont(ofSize: 28.0.cgFloat)
            let size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height:self.barHeight!))
            
            text.draw(at: CGPoint(x:(rect.width - size.width)*0.5, y:(rect.height - size.height)*0.5), withAttributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 28.0.cgFloat),NSAttributedString.Key.foregroundColor:UIColor.darkGray.cgColor])
        }
        
        //得到带有刻度的轨道图片
        let trackImage = UIGraphicsGetImageFromCurrentImageContext()!
        //结束上下文
        UIGraphicsEndImageContext()
        return trackImage
    }
    
    func createTrackImage(rect: CGRect, barColor:UIColor,isdrawText:Bool) -> UIImage {
        //开始图片处理上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        //绘制轨道背景
        context.setLineCap(.round)
        context.setLineWidth(self.barHeight!)
        context.move(to: CGPoint(x:self.barHeight!/2, y:rect.height/2))
        context.addLine(to: CGPoint(x:rect.width-self.barHeight!/2, y:rect.height/2))
        context.setStrokeColor(barColor.cgColor)
        context.strokePath()
        
        
        // 绘制文字
        if isdrawText {
            let text:NSString = barTipTitle as NSString
            let label = UILabel()
            label.text = text as String
            label.font = UIFont.systemFont(ofSize: 28.0.cgFloat)
            let size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height:self.barHeight!))
                
            text.draw(at: CGPoint(x:(rect.width - size.width)*0.5, y:(rect.height - size.height)*0.5), withAttributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 28.0.cgFloat),NSAttributedString.Key.foregroundColor:UIColor.darkGray.cgColor])
        }
        
        //得到带有刻度的轨道图片
        let trackImage = UIGraphicsGetImageFromCurrentImageContext()!
        //结束上下文
        UIGraphicsEndImageContext()
        return trackImage
    }

}
