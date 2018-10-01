//
//  MusicNoDataView.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/17.
//  Copyright © 2018年 Bok Man. All rights reserved.
// 音乐无数据

import UIKit

class MusicNoDataView: UIView {

    /// 懒加载
    lazy var iconView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "nodata")
        return view
    }()
    
    lazy var tipLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWithHex(rgb: 0x888888)
        label.text = "暂无数据,往Appstore Music添加音乐"
        label.font = UIFont.systemFont(ofSize: 24.0.cgFloat)
        return label
    }()
    
    /// 构造方法
    ///
    /// - Parameter frame: <#frame description#>
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMusicNoDataView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutConstraint()
    }
    
}

extension MusicNoDataView {
    fileprivate func setupMusicNoDataView() {
        backgroundColor = UIColor.colorWithHex(rgb: 0xf5f5f5)
        
        addSubview(iconView)
        addSubview(tipLabel)
    }
    
    fileprivate func layoutConstraint() {
        
        tipLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(iconView.snp.bottom).offset(8.0.cgFloat)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY).offset(-50.0.cgFloat)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalToSuperview().multipliedBy(3 / 7.5)
            make.height.equalTo(iconView.snp.width).multipliedBy(394 / 374.0)
        }
    }
}
