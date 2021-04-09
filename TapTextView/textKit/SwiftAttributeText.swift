//
//  SwiftAttributeText.swift
//  CathAssist
//
//  Created by yaojinhai on 2020/5/10.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import Foundation
import UIKit


extension String {
    var attributed: NSMutableAttributedString {
        NSMutableAttributedString(string: self)
    }
    
    func withAttribute(nameKey: AttributeNameKey) -> NSMutableAttributedString {
        attributed.withAttributes(nameKey: [nameKey]);
    }
    func withAttributes(nameKey:[AttributeNameKey]) -> NSMutableAttributedString {
        attributed.withAttributes(nameKey: nameKey)
    }
    func attribute(_ style: ((()->AttibutedJson))) -> NSAttributedString {
        attributed.attribute(style)
    }
}



extension UIImage {
    func attribute(bounds: CGRect) -> NSMutableAttributedString {
        let imageText = NSTextAttachment();
        imageText.image = self
        imageText.bounds = bounds;
        return NSMutableAttributedString(attachment: imageText)
    }
}

extension NSAttributedString {
    
    func withAttributes(nameKey:[AttributeNameKey]) -> NSMutableAttributedString {
        let mutable = mutableCopy() as! NSMutableAttributedString;
        for item in nameKey {
            mutable.addAttributes([item.keyName:item.value], range: .init(location: 0, length: length));
        }
        return mutable;
    }
    
    func withAttribute(nameKey: AttributeNameKey) -> NSMutableAttributedString {
        withAttributes(nameKey: [nameKey])
    }
    
    func withFont(font: UIFont) -> NSMutableAttributedString {
        withAttribute(nameKey: .font(font))
    }
    func attribute(_ style: ((()->AttibutedJson))) -> NSAttributedString {
        let value = style()
        var temp = self
        if let kern = value.kern {
            temp = temp.withAttribute(nameKey: .kern(kern))
        }
        if let color = value.textColor {
            temp = temp.withAttribute(nameKey: .textColor(color))
        }
        
        if let block = value.paragraph {
            let style = NSMutableParagraphStyle()
            style.alignment = .justified
            block(style)
            temp = temp.withAttribute(nameKey: .paragraph(style))
        }
        
        if let font = value.font {
            temp = temp.withAttribute(nameKey: .font(font))
        }
        return temp
        
    }
    
}



enum AttributeNameKey {
    case font(UIFont)
    case textColor(UIColor)
    case kern(NSNumber)
    case paragraph(NSMutableParagraphStyle)
    
    var keyName: NSAttributedString.Key {
        
        let name: NSAttributedString.Key
        
        switch self {
            case .textColor:
                name = .foregroundColor
            case .font:
                name = .font
            case .kern:
                name = .kern
            case .paragraph:
                name = .paragraphStyle
        }
        return name;
    }
    
    var value: Any {
        switch self {
            case .font(let font):
                return font;
            case .textColor(let color):
                return color;
            case .kern(let value):
                return value
            case .paragraph(let style):
            return style
                
        }
    }
}


extension NSAttributedString {
    static func + (left: NSAttributedString,right: NSAttributedString) -> NSAttributedString {
        let compone = left.mutableCopy() as! NSMutableAttributedString;
        compone.append(right);
        return compone;
    }
}

struct AttibutedJson {
    let font: UIFont?
    let textColor: UIColor?
    let kern: NSNumber?
    let paragraph: ((_ style: NSMutableParagraphStyle) -> Void)?
    
    init(_ font: UIFont? = nil, textColor: UIColor? = nil, kern: NSNumber? = nil, paragraph: ((_ style: NSMutableParagraphStyle)-> Void)? = nil) {
        self.font = font
        self.textColor = textColor;
        self.paragraph = paragraph
        self.kern = kern
    }
    
}

extension String {
    func subStringRange(locaion: Int,length: Int) -> String{
        let sIndex = index(startIndex, offsetBy: locaion);
        let eIndex = index(startIndex, offsetBy: locaion + length);
        let sub = self[sIndex..<eIndex];
        return String(sub);
    }
    func subStringRange(range: NSRange) -> String {
        subStringRange(locaion: range.location, length: range.length)
    }
}
