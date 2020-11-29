//
//  Helper.swift
//  DNSPageView
//
//  Created by Daniels on 2018/2/24.
//  Copyright © 2018 Daniels. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit



public struct DNSExtension<ExtendedType> {
    internal let type: ExtendedType
    internal init(_ type: ExtendedType) {
        self.type = type
    }
}


public protocol DNSExtended {

}

extension DNSExtended {
    public var dns: DNSExtension<Self> {
        get { DNSExtension(self) }
    }
    public static var dns: DNSExtension<Self>.Type {
        get { DNSExtension<Self>.self }
    }
}

extension UIColor: DNSExtended {}
public extension DNSExtension where ExtendedType: UIColor {
    
    @available(iOS 13.0, *)
    static func dynamic(_ light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { traitCollection -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return light
            } else {
                return dark
            }
        }
    }
}

extension UIView: DNSExtended {}
public extension DNSExtension where ExtendedType: UIView {
    static func isRightToLeftLayoutDirection(_ view: UIView? = nil) -> Bool {
        let context: UIView = view ?? UIView.appearance()
        if UIView.userInterfaceLayoutDirection(for: context.semanticContentAttribute) == .rightToLeft {
            return true
        } else {
            return false
        }
    }
}




typealias ColorRGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

extension UIColor {
    
    convenience init(_ rgba: ColorRGBA) {
        self.init(red: rgba.red / 255.0, green: rgba.green / 255.0, blue: rgba.blue / 255.0, alpha: rgba.alpha)
    }
    
    
    func getRGBA() -> ColorRGBA {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red * 255, green * 255, blue * 255, alpha)
    }
}


