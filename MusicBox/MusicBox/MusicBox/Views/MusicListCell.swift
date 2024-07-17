//
//  MusicListCell.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/15.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  歌曲cell

import UIKit

class MusicListCell: UITableViewCell {

    var viewModel: MusicListCellViewModel? {
        didSet {
            if let model = viewModel {
                titleLabel.text = model.titleText
                timeLabel.text = model.timeLabelText
                albumImageView.image = UIImage(contentsOfFile: model.albumPicturePath ?? "")
                addButton.setImage(UIImage(named: model.addButtonNormalIcon ?? ""), for: .normal)
                addButton.setImage(UIImage(named: model.addButtonSeletedIcon ?? ""), for: .selected)
                
                addButton.isSelected = model.isAdd
                
            }
        }
    }
    
    weak var delegate:MusicListCellProtocol?
    
    /// 封面图
    fileprivate var albumImageView:UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    /// 歌曲标题
    fileprivate var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30.0.cgFloat)
        label.textColor = UIColor.colorWithHex(rgb: 0x333333)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    /// 时长
    fileprivate var timeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize:24.0.cgFloat)
        label.textColor = UIColor.colorWithHex(rgb: 0x888888)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    /// 添加歌曲按钮
    fileprivate var addButton:UIButton = {
        let button = UIButton(type: .custom)
        
        button.imageView?.snp.updateConstraints({ (make) in
            make.width.height.equalTo(50.0.cgFloat)
            make.center.equalToSuperview()
        })
        return button
    }()
    
    fileprivate var bottomLine:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        
        return view
    }()
    
    // MARK: 构造方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupMusicListCell()
        layoutConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
       
    }
    
    // MARK: 私有方法
    fileprivate func setupMusicListCell() {
        backgroundColor = UIColor.white

        contentView.addSubview(albumImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(addButton)
        contentView.addSubview(bottomLine)
        
        addButton.addTarget(self, action: #selector(addButtonClick(_:)), for: .touchUpInside)
    }
    
    fileprivate func layoutConstraint() {
        
        albumImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40.cgFloat)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(80.0.cgFloat)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(albumImageView.snp.right).offset(40.cgFloat)
            make.top.equalToSuperview().offset(20.cgFloat)
            make.right.equalTo(addButton.snp.left).offset(-40.0.cgFloat)
        }
        
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(albumImageView.snp.right).offset(40.cgFloat)
            make.top.equalTo(titleLabel.snp.bottom).offset(10.0.cgFloat)
            make.right.equalTo(addButton.snp.left).offset(-40.0.cgFloat)
        }
        
        addButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(addButton.snp.height)
            make.right.equalToSuperview()
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(2.0.cgFloat)
        }
    }
    
    // MARK: 外部接口
    public class func cellWithView(_ tableView:UITableView) -> MusicListCell {
        let id = "MusicListCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: id)
        
        if cell == nil {
            cell = MusicListCell(style: .default, reuseIdentifier: id)
            cell?.selectionStyle = .none
        }
        
        return cell as! MusicListCell
    }

}

extension MusicListCell {
    @objc fileprivate func addButtonClick(_ button:UIButton) {
        button.isSelected = true
        viewModel?.isAdd = true
        delegate?.musicListCellDidAddMusic(viewModel)
    }
}

protocol MusicListCellProtocol:NSObjectProtocol {
    func musicListCellDidAddMusic(_ cellModel:MusicListCellViewModel?)
}
