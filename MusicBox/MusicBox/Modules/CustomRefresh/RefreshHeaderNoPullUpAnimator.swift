//
//  RefreshHeaderAnimator.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/6/22.
//  Copyright © 2018年 Bok Man. All rights reserved.
//

import UIKit
//import ESPullToRefresh

class RefreshHeaderNoPullUpAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {
    
    let imageWidth:CGFloat = 60.0.cgFloat
    
    public var view: UIView {
        return self
    }
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var duration: TimeInterval = 0.3
    public var trigger: CGFloat = 56.0
    public var executeIncremental: CGFloat = 56.0
    public var state: ESRefreshViewState = .pullToRefresh
    
    private let indicatorView: AnimatorIndactorView = {
        let indicatorView = AnimatorIndactorView.init("refresh_green")
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        addSubview(indicatorView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // do nothing
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        switch state {
         case .pullToRefresh:
            break
        case .releaseToRefresh :
            break
        default:

            break
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(imageWidth)
        }
    }
    
}

