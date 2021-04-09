//
//  TapTextKitView.swift
//  TapTextView
//
//  Created by yaojinhai on 2021/4/9.
//

import UIKit

class TapTextKitView: UITextView ,NSLayoutManagerDelegate{
    
    private var linkTextArray: [TapLinkText]!
        
    
    private var breakLineRange: [NSRange]!
    
    private var tapLinkRange: [NSRange]!
    
    private var textValue: String {
        text ?? attributedText?.string ?? ""
    }

    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        layoutManager.delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        canCancelContentTouches = false 
        delaysContentTouches = false
        isEditable = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func layoutManager(_ layoutManager: NSLayoutManager, shouldBreakLineByWordBeforeCharacterAt charIndex: Int) -> Bool {
        breakLineRange?.contains { (item) -> Bool in
            item.location < charIndex && item.upperBound > charIndex
        } == false
    }
    
    private func reloadTextLayout() {
        guard let textAttibute = (attributedText ?? text?.attributed)?.mutableCopy() as? NSMutableAttributedString else{
            return
        } 
        let pattern = linkTextArray?.reduce("", { (result, item) -> String in
            if let txt = item.linkText {
                return txt + "|" + result
            }
            return result
        })
        guard let patternValue = pattern  else {
            return
        }
        
        let reg = try? NSRegularExpression(pattern: patternValue, options: .useUnicodeWordBoundaries)
        
        tapLinkRange = [NSRange]()
        
        if let list = reg?.matches(in: textValue, options: .withoutAnchoringBounds, range: .init(location: 0, length: textValue.count)) {
           
            for item in list {
                if let dict = parserReuslt(item: item,fromValue: textValue) {
                    textAttibute.addAttributes(dict, range: item.range)
                }
                tapLinkRange.append(item.range)
            }
        }
        attributedText = textAttibute
        
    }
    
    private func parserReuslt(item: NSTextCheckingResult,fromValue: String) -> [NSAttributedString.Key: Any]? {
        let range = item.range;
        let text = fromValue.subStringRange(range: range)
        let model = linkTextArray.first { (item) -> Bool in
            item.linkText == text;
        }
        if model?.isSupportBreakLine == false {
            addForbiddenBreakLine(range: range)
        }
        return model?.attibute
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let point = touches.first?.location(in: self) else{
            return
        }
        let newPoint = CGPoint(x: point.x - textContainerInset.left, y: point.y - textContainerInset.top)
        let index = layoutManager.characterIndex(for: newPoint, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        guard let range = tapLinkRange?.first(where: { (item) -> Bool in
            item.contains(index)
        }) else {
            return
        }
        let rangeRect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
        if !rangeRect.contains(newPoint) {
            return
        }
        let text = textValue.subStringRange(range: range)
        let model = linkTextArray.first { (item) -> Bool in
            item.linkText == text
        }
        model?.isDidTap = true
        model?.tapAction?(range)
        reloadTextAttibuteLink()
    }
    
}

extension TapTextKitView {
    
    func addLinkTextItem(item: TapLinkText) {
        if linkTextArray == nil {
            linkTextArray = [TapLinkText]()
        }
        linkTextArray.append(item)
    }
    func addLinkTextItems(items: [TapLinkText]) {
        for subItem in items {
            addLinkTextItem(item: subItem)
        }
    }
    
    func addForbiddenBreakLine(range: NSRange) {
        if breakLineRange == nil {
            breakLineRange = [NSRange]()
        }
        breakLineRange.append(range)
    }
    
    func reloadTextAttibuteLink() {
        reloadTextLayout()
    }
}

class TapLinkText: NSObject {
    var linkText: String?
    var tapAction: ((_ range: NSRange) -> Void)?
    var isSupportBreakLine = true
    var defultAttibute: [NSAttributedString.Key: Any]?
    var didTapAttibute: [NSAttributedString.Key: Any]?
    
    var isDidTap = false
    var attibute: [NSAttributedString.Key: Any]? {
        isDidTap ? didTapAttibute : defultAttibute
    }
}
