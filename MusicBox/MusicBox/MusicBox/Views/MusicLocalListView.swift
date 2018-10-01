//
//  MusicLocalListView.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/14.
//  Copyright © 2018年 Bok Man. All rights reserved.
// 本地音乐列表

import UIKit
import QorumLogs

class MusicLocalListView: UIView {

    var viewModel:MusicLocalListViewModel? {
        didSet {
            updateMusicLocalListView(viewModel)
        }
    }
    /// 屏幕属性
    fileprivate var screen_type:ScreenDirection = .portrail
    
    fileprivate var dataList:[MusicListCellViewModel]?
    
    // MARK :懒加载
    
    /// 关闭
    fileprivate var closeButton:UIButton = {
        let button = UIButton(type: .custom)
        
        return button
    }()
    
    /// 添加配乐
    fileprivate var addMusicLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32.0.cgFloat)
        label.textColor = UIColor.colorWithHex(rgb: 0x333333)
        label.textAlignment = .center
        return label
    }()
    
    /// 配乐总歌曲数目
    fileprivate var totalMusicLabel:AttributeLabel = {
        let label = AttributeLabel()
    
        return label
    }()
    
    
    /// 顶部工具条
    fileprivate lazy var topBarView:UIView = {
        let view = UIView()
        view.addSubview(addMusicLabel)
        view.addSubview(totalMusicLabel)
        view.addSubview(closeButton)
        
        addMusicLabel.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        
        totalMusicLabel.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(addMusicLabel.snp.bottom).offset(15.0.cgFloat)
        })
    
        closeButton.snp.makeConstraints({ (make) in
            make.centerY.equalTo(addMusicLabel.snp.centerY)
            make.width.height.equalTo(60.0.cgFloat)
            make.right.equalToSuperview().offset(-30.0.cgFloat)
        })
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(bottomLine)
        
        bottomLine.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(2.0.cgFloat)
        })
        
        return view
    }()
    
    /// 底部工具条
    fileprivate lazy var bottomBarView:UIView = {
        let view = UIView()
       
        
        return view
    }()
    
    /// 音乐列表视图
    fileprivate lazy var listView:UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = UIColor.groupTableViewBackground
        view.separatorStyle = .none
        view.tableHeaderView = UIView(frame: CGRect.zero)
        view.rowHeight = 120.cgFloat
        view.dataSource = self
        
        return view
    }()
    /// 无数据显示的时候
    fileprivate lazy var noDataView:MusicNoDataView = {
        let view = MusicNoDataView()
        view.isHidden = true
        return view
    }()
    
    /// 弹框
    fileprivate var popView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    fileprivate var coverView:UIView = {
        let view = UIView()
        
        return view
    }()
    
    fileprivate var completed:((_ action:MusicActionType,_ info:PersionPreference)->())?
    
    fileprivate var finished:(()->())?
    
    // MARK : 构造方法
    convenience init(_ screen:ScreenDirection = .portrail, complete:@escaping (_ action:MusicActionType,_ info:PersionPreference)->(),finish:@escaping ()->()) {
        self.init()
        screen_type = screen
        completed = complete
        finished = finish
        setupMorePopView()
        layoutConstraint()
    }
    
    // MARK: 私有方法
    fileprivate func setupMorePopView() {
        coverView.backgroundColor = UIColor(white: 0.1, alpha: 0.2)
        addSubview(coverView)
        addSubview(popView)
        
        popView.addSubview(topBarView)
        popView.addSubview(listView)
        listView.addSubview(noDataView)
        popView.addSubview(bottomBarView)
        
 
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHidden(_:)))
        coverView.addGestureRecognizer(tap)
        
        closeButton.addTarget(self, action: #selector(closeButtonClick(_:)), for: .touchUpInside)

    }
    
    fileprivate func layoutConstraint() {
        switch screen_type {
        case .portrail:
            frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
            layoutPortrailConstrait()
            
        case .landscape:
            frame = CGRect(x: 0, y: 0, width: ScreenHeight, height: ScreenWidth)
            layoutLandScapeConstraint()
        }
        
        coverView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        noDataView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50.0.cgFloat)
        }
    }
    
    
    fileprivate func layoutPortrailConstrait() {
        popView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(ScreenHeight)
            make.bottom.equalToSuperview().offset(ScreenHeight)
        }
        
        topBarView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(204.0.cgFloat)
        }
        
        listView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topBarView.snp.bottom)
            make.bottom.equalTo(bottomBarView.snp.top)
        }
        
        bottomBarView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(104.0.cgFloat)
        }
    }
    
    fileprivate func layoutLandScapeConstraint() {
        popView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(750.0.cgFloat)
            make.right.equalToSuperview().offset(750.0.cgFloat)
        }
        
        topBarView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(164.0.cgFloat)
        }
        
        addMusicLabel.snp.remakeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(topBarView.snp.centerY)
        })
        
        
        totalMusicLabel.snp.updateConstraints({ (make) in
            make.top.equalTo(addMusicLabel.snp.bottom)
        })
        
        listView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topBarView.snp.bottom)
            make.bottom.equalTo(bottomBarView.snp.top)
        }
        
        bottomBarView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44.0.cgFloat)
        }
    }
    
    /// 更新视图模型
    ///
    /// - Parameter viewModel: <#viewModel description#>
    fileprivate func updateMusicLocalListView(_ viewModel:MusicLocalListViewModel?) {
        
        addMusicLabel.text = viewModel?.addMusicTitleText
        
        if let model = viewModel {
            switch model.status {
            case .start:
                let content = model.startLoadingText
                totalMusicLabel.setContent(content, withAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 26.0.cgFloat),NSAttributedString.Key.foregroundColor:UIColor.colorWithHex(rgb: 0x888888)], withActionAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 26.0.cgFloat),NSAttributedString.Key.foregroundColor:UIColor.colorWithHex(rgb: 0x888888)], withActionTextRange: NSMakeRange(content.count, 0))
            case .loading:
                let content = model.loadingText
                
                totalMusicLabel.setContent(content, withAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 26.0.cgFloat),NSAttributedString.Key.foregroundColor:UIColor.colorWithHex(rgb: 0x888888)], withActionAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 26.0.cgFloat),NSAttributedString.Key.foregroundColor:UIColor.colorWithHex(rgb: 0x888888)], withActionTextRange: NSMakeRange(content.count, 0))
            case .loaded:
                
                let head = model.totalMusicText
                let active = model.totalMusicNumText ?? ""
                let content = head + active + model.totalMusicUnitText
                
                let range = NSMakeRange(head.count, active.count)
                
                totalMusicLabel.setContent(content, withAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 26.0.cgFloat),NSAttributedString.Key.foregroundColor:UIColor.colorWithHex(rgb: 0x888888)], withActionAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 26.0.cgFloat),NSAttributedString.Key.foregroundColor:UIColor.colorWithTheme()], withActionTextRange: range)
            }
        }
        
        
        closeButton.setImage(UIImage(named: viewModel?.closeButtonIcon ?? ""), for: .normal)
        
        dataList = viewModel?.dataList
        
        listView.reloadData()
        
        if let list = dataList,list.count > 0 {
            noDataView.isHidden = true
            return
        }
        
        noDataView.isHidden = false
        
    }
    // MARK: 内部响应
    
    @objc fileprivate func tapHidden(_ gesture:UITapGestureRecognizer) {
   
    }
    
    @objc fileprivate func popViewButtonClick(_ button:UIButton) {
        button.isSelected = !button.isSelected
        
    }
    
    
    // MARK: 外部接口
    
    fileprivate func showUpdateConstraint() {
        switch screen_type {
        case .portrail:
            popView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview().offset(0)
            })
        case .landscape:
            popView.snp.updateConstraints({ (make) in
                make.right.equalToSuperview().offset(0)
            })
        }
    }
    
    fileprivate func hiddenUpdateConstraint() {
        switch screen_type {
        case .portrail:
            popView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview().offset(ScreenHeight)
            })
        case .landscape:
            popView.snp.updateConstraints({ (make) in
                make.right.equalToSuperview().offset(750.0.cgFloat)
            })
        }
    }
    
    open func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(musicListLoadingUpdate(_:)), name: MusicBoxSongLoadingStatusKey, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * 0.2 )) / Double(NSEC_PER_SEC), execute: {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
                self?.showUpdateConstraint()
                
                self?.layoutIfNeeded()
            }) { (complete) in
                UIApplication.shared.statusBarStyle = .default
            }
        })
    }
    
    open func hidden(_ completed:@escaping ()->()) {
        
        NotificationCenter.default.removeObserver(self, name: MusicBoxSongLoadingStatusKey, object: nil)
        
        viewModel?.updateLocalList()
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
            self?.hiddenUpdateConstraint()
            
            self?.layoutIfNeeded()
        }) { [weak self] (complete) in
            self?.coverView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
            if let subviews = self?.subviews {
                for (_,view) in subviews.enumerated() {
                    view.removeFromSuperview()
                }
            }
            
            self?.removeFromSuperview()
            completed()
            self?.finished?()
            UIApplication.shared.statusBarStyle = .lightContent
            
        }
    }

}

extension MusicLocalListView {
    @objc fileprivate func closeButtonClick(_ button:UIButton) {
        hidden {
            
        }
    }
}

extension MusicLocalListView:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MusicListCell.cellWithView(tableView)
    
        cell.viewModel = dataList?[indexPath.item]
        cell.delegate = self
        
        return cell
    }
}

extension MusicLocalListView:MusicListCellProtocol {
    func musicListCellDidAddMusic(_ cellModel: MusicListCellViewModel?) {
        viewModel?.updateViewModel(cellModel)
    }
}

extension MusicLocalListView {
    @objc fileprivate func musicListLoadingUpdate(_ notification:Notification) {
        DispatchQueue.main.async { [weak self] in
            if let userInfo:[String:Int] = notification.object as? [String:Int],
                let statusValue = userInfo["status"],let status = MusicLoadingStatus(rawValue: statusValue) {
                let model = MusicLocalListViewModel.createViewModel()
                model.status = status
                self?.viewModel = model
                
                switch status {
                case .start:
                    QL1("开始加载")
                case .loading:
                    QL1("加载中")
                case .loaded:
                    QL1("加载完成")
                }
            }
        }
    }
}


