//
//  MusicPlayListCell.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/15.
//  Copyright © 2018年 Bok Man. All rights reserved.
//

import UIKit
import SnapKit

class MusicPlayListCell: UITableViewCell {

    var viewModel: MusicPlayListCellViewModel? {
        didSet {
            if let model = viewModel {
                titleLabel.text = model.titleText
                deleteButton.setImage(UIImage(named: model.deleteButtonIcon ?? ""), for: .normal)
                
                if model.isSelected {
                    titleLabel.textColor = UIColor.colorWithTheme()
                } else {
                    titleLabel.textColor = UIColor.colorWithHex(rgb: 0x333333)
                }
                
                setSelect(model.isSelected)
            }
        }
    }
    
    weak var delegate:MusicPlayListCellProtocol?
    
    /// 歌曲标题
    fileprivate var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30.0.cgFloat)
        label.textColor = UIColor.colorWithHex(rgb: 0x333333)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    /// 删除歌曲按钮
    fileprivate var deleteButton:UIButton = {
        let button = UIButton(type: .custom)
        
        button.imageView?.snp.updateConstraints({ (make) in
            make.width.height.equalTo(25.0.cgFloat)
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
        
        setupMusicPlayListCell()
        layoutConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 私有方法
    fileprivate func setupMusicPlayListCell() {
        backgroundColor = UIColor.white
        
        addSubview(titleLabel)
        addSubview(deleteButton)
        addSubview(bottomLine)
        
        deleteButton.addTarget(self, action: #selector(deleteButtonClick(_:)), for: .touchUpInside)
    }
    
    fileprivate func layoutConstraint() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40.0.cgFloat)
            make.centerY.equalToSuperview()
            make.right.equalTo(deleteButton.snp.left).offset(-40.0.cgFloat)
        }
        

        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(deleteButton.snp.height)
            make.right.equalToSuperview()
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(2.0.cgFloat)
        }
    }
    // MARK: 外部接口
    public class func cellWithView(_ tableView:UITableView) -> MusicPlayListCell {
        let id = "MusicPlayListCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: id)
        
        if cell == nil {
            cell = MusicPlayListCell(style: .default, reuseIdentifier: id)
            cell?.selectionStyle = .none
        }
        
        return cell as! MusicPlayListCell
    }

    /// 是否选中
    ///
    /// - Parameter isSelected: <#isSelected description#>
    func setSelect(_ isSelected:Bool) {
        if isSelected {
            titleLabel.textColor = UIColor.colorWithTheme()
        } else {
            titleLabel.textColor = UIColor.colorWithHex(rgb: 0x333333)
        }
    }
}

extension MusicPlayListCell {
    @objc fileprivate func deleteButtonClick(_ button:UIButton) {
        viewModel?.isDelete = true
        delegate?.musicListCellDidDeleteMusic(viewModel)
    }
}

protocol MusicPlayListCellProtocol:NSObjectProtocol {
    func musicListCellDidDeleteMusic(_ cellModel:MusicPlayListCellViewModel?)
}
