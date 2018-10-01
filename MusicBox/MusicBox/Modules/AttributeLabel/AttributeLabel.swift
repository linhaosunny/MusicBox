//
//  AttributeLabel.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/3/27.
//  Copyright © 2018年 Bok Man. All rights reserved.
//

import UIKit

class AttributeLabel: UIView {

    // MARK: 属性
    weak var delegate:AttributeLabelProtocol?
    
    // MARK: 懒加载
    fileprivate lazy var textView:UITextView = {
        let view = UITextView()
        view.delegate = self
        view.isEditable = false
        view.isScrollEnabled = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()

    // MARK: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAttributeLabel()
        layoutConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 私有方法
    fileprivate func setupAttributeLabel() {
        addSubview(textView)
    }
    
    fileprivate func layoutConstraint() {
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges).inset(UIEdgeInsets.zero)
        }
    }
    
    // MARK: 公用方法
    func setContent(_ content:String,withAttributes attrs:[NSAttributedString.Key:Any],withActionAttributes attrs_s:[NSAttributedString.Key:Any] ,withActionTextRange range:NSRange) {
        let attStr = NSMutableAttributedString(string: content)
        
        attStr.addAttributes(attrs, range: NSMakeRange(0, range.location))
        attStr.addAttributes(attrs_s, range: range)
        let len = content.count - (range.location + range.length)
        if len > 0 {
            attStr.addAttributes(attrs, range: NSMakeRange(range.location + range.length, len))
        }
        attStr.addAttribute(NSAttributedString.Key.link, value: "click://", range: range)
        
        var attrs_link:[NSAttributedString.Key:Any] = [NSAttributedString.Key:Any]()
        
        for (key,value) in attrs_s {
            attrs_link.updateValue(value, forKey: key)
        }
        
        self.textView.attributedText = attStr
        self.textView.linkTextAttributes = attrs_link
    }
    
    
}

extension AttributeLabel:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if let scheme = URL.scheme, scheme == "click" {
            let attStr = textView.attributedText.attributedSubstring(from: characterRange)
            delegate?.attributeLabel(self, clickActionString: attStr)
        }
        
        return false
    }
}

protocol AttributeLabelProtocol:NSObjectProtocol {
    func attributeLabel(_ label:AttributeLabel,clickActionString string:NSAttributedString)
}
