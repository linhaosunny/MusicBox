//
//  MusicBoxPopView.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/13.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  音乐盒

import UIKit
import SnapKit

class MusicBoxPopView: UIView {

    var viewModel:MusicBoxViewModel? {
        didSet {
            updateMusicBoxView(viewModel)
        }
    }
    /// 屏幕属性
    fileprivate var screen_type:ScreenDirection = .portrail

    fileprivate var dataList:[MusicPlayListCellViewModel]?
    
    // MARK :懒加载
    
    /// 播放动图
    fileprivate var albumImageView:UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    /// 播放器按钮
    fileprivate var playerButton:UIButton = {
        let button = UIButton(type: .custom)
        
        return button
    }()
    
    /// 播放循环按钮
    fileprivate var playloopButton:UIButton = {
        let button = UIButton(type: .custom)
        
        return button
    }()
    
    /// 静音按钮
    fileprivate var muteButton:UIButton = {
        let button = UIButton(type: .custom)
        
        return button
    }()
    
    /// 音量滑块
    fileprivate var volumeSlider:CustomSlider = {
        let slider = CustomSlider()
        slider.sliderModel = .color
        slider.leftBarColor = UIColor.colorWithTheme()
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .touchCancel)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .touchUpInside)
        return slider
    }()
    
    /// 音乐列表
    fileprivate var musicListButton:UIButton = {
        let button = UIButton(type: .custom)
        
        return button
    }()
    
    /// 配乐标签
    fileprivate var musicLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32.0.cgFloat)
        label.textColor = UIColor.colorWithHex(rgb: 0x333333)
        label.textAlignment = .center
        return label
    }()

    /// 顶部工具条
    fileprivate lazy var topBarView:UIView = {
        let view = UIView()
        view.addSubview(musicLabel)
        view.addSubview(musicListButton)
        
        musicLabel.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        
        musicListButton.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44.0.cgFloat)
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
        view.addSubview(albumImageView)
        view.addSubview(playerButton)
        view.addSubview(muteButton)
        view.addSubview(volumeSlider)
        view.addSubview(playloopButton)
        
        albumImageView.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(80.0.cgFloat)
            make.left.equalToSuperview().offset(40.0.cgFloat)
        })
        
        playerButton.snp.makeConstraints({ (make) in
            make.width.height.equalTo(56.0.cgFloat)
            make.centerX.equalTo(albumImageView.snp.centerX)
            make.centerY.equalTo(albumImageView.snp.centerY)
        })
        
        muteButton.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(52.0.cgFloat)
            make.left.equalTo(albumImageView.snp.right).offset(40.0.cgFloat)
        })
        
        volumeSlider.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(muteButton.snp.right).offset(30.0.cgFloat)
            make.right.equalTo(playloopButton.snp.left).offset(-30.0.cgFloat)
            make.height.equalTo(30.0.cgFloat)
        })
        
        playloopButton.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(52.0.cgFloat)
            make.right.equalToSuperview().offset(-40.0.cgFloat)
        })
        
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
        view.delegate = self
        return view
    }()
    
    /// 无数据显示的时候
    fileprivate lazy var noDataView:MusicNoDataView = {
        let view = MusicNoDataView()
        view.isHidden = true
        return view
    }()
    
    /// 选中的cell
    fileprivate var selectedIndexPath:IndexPath? {
        get {
            return MusicBox.shared.playListSelectIndexPath
        }
        set {
            MusicBox.shared.playListSelectIndexPath = newValue
        }
    }
    
    /// 是否播放
    fileprivate var isPlaying:Bool  {
        get {
            return MusicBox.shared.isPlaying
        }
        set {
            MusicBox.shared.isPlaying = newValue
        }
    }
    
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
    
    fileprivate var finished:((_ view:MusicBoxPopView?)->())?
    
    // MARK : 构造方法
    convenience init(_ screen:ScreenDirection = .portrail, complete:@escaping (_ action:MusicActionType,_ info:PersionPreference)->(),finish:@escaping (_ view:MusicBoxPopView?)->()) {
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
        popView.addSubview(noDataView)
        popView.addSubview(bottomBarView)

        volumeSlider.barHeight = 2.0.cgFloat
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHidden(_:)))
        coverView.addGestureRecognizer(tap)
        
        playerButton.addTarget(self, action: #selector(playerButtonClick(_:)), for: .touchUpInside)
        muteButton.addTarget(self, action: #selector(muteButtonClick(_:)), for: .touchUpInside)
        playloopButton.addTarget(self, action: #selector(playloopButtonClick(_:)), for: .touchUpInside)
        musicListButton.addTarget(self, action: #selector(musiclistButtonClick(_:)), for: .touchUpInside)
        
        
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
        
    }
    
    
    fileprivate func layoutPortrailConstrait() {
        popView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(580.0.cgFloat + CGFloat(kBottomSafeOffset))
            make.bottom.equalToSuperview().offset(580.0.cgFloat + CGFloat(kBottomSafeOffset))
        }
        
        topBarView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(104.0.cgFloat)
        }
        
        listView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topBarView.snp.bottom)
            make.bottom.equalTo(bottomBarView.snp.top)
        }
        
        noDataView.snp.makeConstraints { (make) in
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
            make.width.equalTo(750.0.cgFloat + CGFloat(kBottomSafeOffset))
            make.right.equalToSuperview().offset(750.0.cgFloat + CGFloat(kBottomSafeOffset))
        }
        
        topBarView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(104.0.cgFloat)
        }
        
        listView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topBarView.snp.bottom)
            make.bottom.equalTo(bottomBarView.snp.top)
        }
        
        noDataView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topBarView.snp.bottom)
            make.bottom.equalTo(bottomBarView.snp.top)
        }
        
        bottomBarView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(104.0.cgFloat)
            make.bottom.equalToSuperview().inset(kBottomSafeOffset)
        }
    }
    
    fileprivate func updateMusicBoxView(_ viewModel:MusicBoxViewModel?) {
        musicLabel.text = viewModel?.musicLabelText
        musicListButton.setImage(UIImage(named: viewModel?.musicListButtonIcon ?? ""), for: .normal)
        playerButton.setImage(UIImage(named: viewModel?.playerButtonPlayIcon ?? ""), for: .normal)
        playerButton.setImage(UIImage(named: viewModel?.playerButtonPauseIcon ?? ""), for: .selected)
        
        muteButton.setImage(UIImage(named: viewModel?.muteButtonNormalIcon ?? ""), for: .normal)
        muteButton.setImage(UIImage(named: viewModel?.muteButtonSelectIcon ?? ""), for: .selected)
        
        playloopButton.setImage(UIImage(named: viewModel?.playloopButtonNormalIcon ?? ""), for: .normal)
        playloopButton.setImage(UIImage(named: viewModel?.playloopButtonSingleLoopIcon ?? ""), for: .selected)
        
        volumeSlider.setThumbImage(UIImage(named: viewModel?.playvolumeSliderButtonIcon ?? ""), for: .normal)
        
        if let volume = viewModel?.currentPlayVolume {
            volumeSlider.value = Float(volume) / 100.0
            
            if let preference = Preference.shared.preference {
                preference.volume = Int(volumeSlider.value * 100)
                completed?(.volume,preference)
            }
        }
        
        if let isMute = viewModel?.isMute {
            muteButton.isSelected = isMute
            
            if let preference = Preference.shared.preference {
                preference.isMute = isMute
                completed?(.mute,preference)
            }
        }
        
        if let isRunLoop = viewModel?.isRunLoop {
            playloopButton.isSelected = isRunLoop
            
            if let preference = Preference.shared.preference {
                preference.isRunLoop = isRunLoop
                completed?(.runLoop,preference)
            }
        }
        
        if let list = viewModel?.playList,list.count > 0 {
            if let item = selectedIndexPath?.item {
                let cellModel = viewModel?.playList?[item]
                cellModel?.isSelected = true
                
                let albumPath = AlbumPictures.albumPicturesLocalPath(cellModel?.song?.albumPicturePath ?? "")
                albumImageView.cornerImage(UIImage(contentsOfFile: albumPath), size: CGSize(width: 80.0.cgFloat, height: 80.0.cgFloat))
            }
            
        }
        
        dataList = viewModel?.playList
        
        DispatchQueue.main.async { [weak self] in
            
            self?.listView.reloadData()
            
            if let item = self?.selectedIndexPath?.item,let list = self?.dataList {
                self?.scrollToSong(item,list:list)
            }
        }
        
        playerButton.isSelected = isPlaying
        
        albumImageView.addRotationAnimation()
        if !isPlaying {
            albumImageView.pauseAnimation()
        }
        
        if let list = dataList,list.count > 0 {
            noDataView.isHidden = true
            isShowPlayBar(true)
            return
        }
        
        noDataView.isHidden = false
        
        isShowPlayBar(false)
        
    }
    // MARK: 内部响应
    
    @objc fileprivate func tapHidden(_ gesture:UITapGestureRecognizer) {
        hidden {
            
        }
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
                make.bottom.equalToSuperview().offset(580.0.cgFloat + CGFloat(kBottomSafeOffset))
            })
        case .landscape:
            popView.snp.updateConstraints({ (make) in
                make.right.equalToSuperview().offset(750.0.cgFloat + CGFloat(kBottomSafeOffset))
            })
        }
    }
    
    open func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        
        MusicBox.shared.isMusixBoxBackground = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(playListPlayNextSong), name: MusicBoxPlayNextSongKey, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * 0.2 )) / Double(NSEC_PER_SEC), execute: {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
                self?.showUpdateConstraint()
                
                self?.layoutIfNeeded()
            }) { (complete) in
                // 监听音量变化
                Volume.when(.up) { [weak self] (stepValue) in
                    self?.volumeChanged(.up,stepValue: stepValue)
                }
                
                Volume.when(.down) { [weak self] (stepValue) in
                    self?.volumeChanged(.down,stepValue: stepValue)
                }
            }
        })
        
        
    }
    
    open func hidden(_ completed:@escaping ()->()) {
       
        NotificationCenter.default.removeObserver(self, name: MusicBoxPlayNextSongKey, object: nil)
        
        MusicBox.shared.isMusixBoxBackground = true
        
        
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
            self?.hiddenUpdateConstraint()
            
            self?.layoutIfNeeded()
        }) { [weak self] (complete) in
            Volume.reset()
            
            self?.coverView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
            if let subviews = self?.subviews {
                for (_,view) in subviews.enumerated() {
                    view.removeFromSuperview()
                }
            }
            self?.removeFromSuperview()
            completed()
            self?.finished?(self)
            
        }
    }
    
    /// 是否隐藏播放进度条
    ///
    /// - Parameter isShow: <#isShow description#>
    open func isShowPlayBar(_ isShow:Bool) {
        bottomBarView.isHidden = !isShow
        
        if isShow {
            bottomBarView.snp.updateConstraints { (make) in
                 make.height.equalTo(104.0.cgFloat)
            }
        } else {
            bottomBarView.snp.updateConstraints { (make) in
                 make.height.equalTo(0.0.cgFloat)
            }
        }
    }
}

extension MusicBoxPopView {
    func playNextSong() {
        if let index  = selectedIndexPath?.item , let list = dataList {
            var item = index + 1
            if item >= list.count {
                item = 0
            }
            
            tableView(listView, didSelectRowAt: IndexPath(item: item, section: 0))
            
//            listView.reloadRows(at: [IndexPath(item: item - 1, section: 0),IndexPath(item: item, section: 0)], with: UITableViewRowAnimation.none)
            
            DispatchQueue.main.async {[weak self] in
                self?.listView.reloadData()
                
                self?.scrollToSong(item,list:list)
            }
            
        }
    }
    
    /// 移动到歌曲
    ///
    /// - Parameter item: <#item description#>
    fileprivate func scrollToSong(_ item:Int,list:[MusicPlayListCellViewModel]) {
        var scrollItem = 0
        if item < 1  {
            if list.count > 2 {
                scrollItem = 2
            } else {
                if list.count > 1 {
                    scrollItem = list.count - 1
                }
            }
        } else if item + 1 < list.count {
            scrollItem = item + 1
        } else {
            scrollItem = item
        }
        listView.scrollToRow(at: IndexPath(item: scrollItem, section: 0), at: .bottom, animated: true)
    }
}

extension MusicBoxPopView:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MusicPlayListCell.cellWithView(tableView)

        cell.viewModel = dataList?[indexPath.item]
        cell.delegate = self
        
        return cell
    }
}

extension MusicBoxPopView:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let model = dataList?[indexPath.item],let song = model.song  else {
            return
        }
        
        if let oldIndexPath = selectedIndexPath,let oldModel = dataList?[oldIndexPath.item], let oldSong = oldModel.song, MusicBox.isSameSong(oldSong, checkSong: song) {
            return
        }
        

        model.isSelected = true
        if let cell = tableView.cellForRow(at: indexPath) as? MusicPlayListCell {
            cell.setSelect(true)
        }
        
        if let oldIndexPath = selectedIndexPath {
            let oldModel = dataList?[oldIndexPath.item]
            oldModel?.isSelected = false
            
            if let oldCell = tableView.cellForRow(at: oldIndexPath) as? MusicPlayListCell {
                oldCell.setSelect(false)
            }
        }
    
        selectedIndexPath = indexPath
        viewModel?.playList = dataList
        
        if let preference = Preference.shared.preference {
            preference.songName = song.title ?? ""
            preference.songArtist = song.artist ?? ""
            if let playUrl = song.localUrl {
                preference.playUrl = MusicBox.songLocalPath(playUrl)
            } else {
                preference.playUrl = song.serverUrl ?? ""
            }
            
            albumImageView.pauseAnimation()
            let albumPath = AlbumPictures.albumPicturesLocalPath(song.albumPicturePath ?? "")
            albumImageView.cornerImage( UIImage(contentsOfFile: albumPath), size: CGSize(width: 80.0.cgFloat, height: 80.0.cgFloat))
            
            playerButton.isSelected = true
            isPlaying = playerButton.isSelected
            completed?(.switchPlay,preference)
            albumImageView.resumeAnimation()
        }
    }
}

extension MusicBoxPopView:MusicPlayListCellProtocol {
    func musicListCellDidDeleteMusic(_ cellModel: MusicPlayListCellViewModel?) {
       
        if let item = selectedIndexPath?.item,let song = dataList?[item].song,let deleteSong = cellModel?.song {
            if MusicBox.isSameSong(song, checkSong: deleteSong) {
                viewModel?.updateViewModel(cellModel)
                if isPlaying {
                    playerButtonClick(playerButton)
                }
                
                selectedIndexPath = nil
                updateMusicBoxView(viewModel)
            } else {
                viewModel?.updateViewModel(cellModel)
                if let list = viewModel?.playList {
                    for (index,model) in list.enumerated() {
                        if let checkSong = model.song,MusicBox.isSameSong(song, checkSong: checkSong) {
                            selectedIndexPath = IndexPath(item: index, section: 0)
                        }
                    }
                }
                updateMusicBoxView(viewModel)
            }
        } else {
            viewModel?.updateViewModel(cellModel)
            updateMusicBoxView(viewModel)
        }
    }
}

extension MusicBoxPopView {
    
    
    /// 音量变化监听
    ///
    /// - Parameters:
    ///   - type: <#type description#>
    ///   - stepValue: <#stepValue description#>
    fileprivate func volumeChanged(_ type:Volume,stepValue:Float) {
        var volume = volumeSlider.value
        
        switch type {
        case .up:
            if volume + stepValue > 1.0 {
                volume = 1.0
            } else {
                volume += stepValue
            }
            
            
        case .down:
            if volume - stepValue <= 0 {
                volume = 0.0
            } else {
                volume -= stepValue
            }
        }
        
        volumeSlider.value = volume
        sliderValueChanged(volumeSlider)
    }
    
    /// 调整音量
    ///
    /// - Parameter slider: <#slider description#>
    @objc fileprivate func sliderValueChanged(_ slider:UISlider) {
        if let preference = Preference.shared.preference {
            preference.volume = Int(slider.value * 100)
            completed?(.volume,preference)
        }
    }
    
    /// 播放和暂停
    ///
    /// - Parameter button: <#button description#>
    @objc fileprivate func playerButtonClick(_ button:UIButton) {
        if let preference = Preference.shared.preference {
            if !button.isSelected ,let list = dataList,list.count == 0 {
                return
            }
            
            if selectedIndexPath == nil {
                tableView(listView, didSelectRowAt: IndexPath(item: 0, section: 0))
                return
            }
            
            button.isSelected = !button.isSelected
            preference.isPlay = button.isSelected
            isPlaying = button.isSelected
            
            if isPlaying {
                albumImageView.layer.resumeAnimate()
            } else {
                albumImageView.layer.pauseAnimate()
            }
            
            completed?(.play,preference)
        }
    }
    
    /// 静音
    ///
    /// - Parameter button: <#button description#>
    @objc fileprivate func muteButtonClick(_ button:UIButton) {
        if let preference = Preference.shared.preference {
            button.isSelected = !button.isSelected
            preference.isMute = button.isSelected
            completed?(.mute,preference)
        }
    }
    
    /// 是否循环播放
    ///
    /// - Parameter button: <#button description#>
    @objc fileprivate func playloopButtonClick(_ button:UIButton) {
        if let preference = Preference.shared.preference {
            button.isSelected = !button.isSelected
            preference.isRunLoop = button.isSelected
            completed?(.runLoop,preference)
        }
    }
    
    /// 进入本地曲库
    ///
    /// - Parameter button: <#button description#>
    @objc fileprivate func musiclistButtonClick(_ button:UIButton) {
        viewModel?.updateLocalList()
        
        finished?(self)
        let popView = MusicLocalListView(screen_type, complete: { (type, preference) in
            
        }) { [weak self] in
            
            self?.viewModel?.getPlayList()
            
            if let item = self?.selectedIndexPath?.item,let song = self?.dataList?[item].song {
        
                if let list = self?.viewModel?.playList {
                    for (index,model) in list.enumerated() {
                        if let checkSong = model.song,MusicBox.isSameSong(song, checkSong: checkSong) {
                            self?.selectedIndexPath = IndexPath(item: index, section: 0)
                        }
                    }
                }
            }
            
            self?.updateMusicBoxView(self?.viewModel)
        }
        popView.viewModel = MusicLocalListViewModel.createViewModel()
        
        popView.show()
        
    }
    
    /// 播放下一曲
    @objc fileprivate func playListPlayNextSong() {
        playNextSong()
    }
}
