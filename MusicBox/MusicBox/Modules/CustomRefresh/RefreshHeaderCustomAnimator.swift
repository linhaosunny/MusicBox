//
//  RefreshHeaderAnimator.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/5/24.
//  Copyright © 2018年 Bok Man. All rights reserved.
//

import UIKit
//import ESPullToRefresh

public class RefreshHeaderCustomAnimator: UIView ,ESRefreshProtocol, ESRefreshAnimatorProtocol {

    public let RefreshDescription: String = "下拉刷新"
    public let RefreshingDescription: String     = "刷新中..."
    
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var view: UIView { return self }
    public var duration: TimeInterval = 0.3
    public var trigger: CGFloat = 56.0
    public var executeIncremental: CGFloat = 56.0
    public var state: ESRefreshViewState = .pullToRefresh
    
    private let imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "yunzai_pull_animation_1")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(white: 160.0 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(120.0.cgFloat)
            make.height.equalTo(120.0.cgFloat)
            make.top.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageView.snp.centerY)
            make.left.equalTo(self.snp.centerX)
        }
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        imageView.center = self.center
        titleLabel.text = RefreshingDescription
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            
            let y = self.bounds.size.height - 120.0.cgFloat
            self.imageView.snp.updateConstraints { (make) in
                make.top.equalTo(y)
                make.height.equalTo(120.0.cgFloat)
                make.right.equalTo(self.snp.centerX)
            }
            
        }, completion: { (finished) in
            var images = [UIImage]()
            for idx in 1 ... 9 {
                if let aImage = UIImage(named: "yunzai_shake_animation_\(idx)") {
                    images.append(aImage)
                }
            }
            self.imageView.animationDuration = 0.5
            self.imageView.animationRepeatCount = 0
            self.imageView.animationImages = images
            self.imageView.startAnimating()
        })
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        
        imageView.stopAnimating()
        imageView.image = UIImage.init(named: "yunzai_pull_animation_1")
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.refresh(view: view, progressDidChange: 0.0)
        }, completion: { [weak self] (finished) in
            self?.titleLabel.text = ""
        })
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        let p = max(0.0, min(1.0, progress))

        
        titleLabel.text = RefreshDescription
        let y = self.bounds.size.height - 120.cgFloat * p
        imageView.snp.updateConstraints { (make) in
            make.top.equalTo(y)
            make.height.equalTo(CGFloat(120.0.cgFloat * p))
            make.right.equalTo(self.snp.centerX)
        }
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .pullToRefresh:
            var images = [UIImage]()
            for idx in 1 ... 5 {
                if let aImage = UIImage(named: "yunzai_pull_animation_\((5 - idx + 1))") {
                    images.append(aImage)
                }
            }
            imageView.animationDuration = 0.2
            imageView.animationRepeatCount = 1
            imageView.animationImages = images
            imageView.image = UIImage.init(named: "yunzai_pull_animation_1")
            imageView.startAnimating()
            break
        case .releaseToRefresh:
            var images = [UIImage]()
            for idx in 1 ... 5 {
                if let aImage = UIImage(named: "yunzai_pull_animation_\(idx)") {
                    images.append(aImage)
                }
            }
            imageView.animationDuration = 0.2
            imageView.animationRepeatCount = 1
            imageView.animationImages = images
            imageView.image = UIImage.init(named: "yunzai_pull_animation_5")
            imageView.startAnimating()
            
            
            break
        default:
            break
        }
    }

   
}
