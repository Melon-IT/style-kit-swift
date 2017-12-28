//
//  MBFStyleKit.swift
//  MelonStyleKit
//
//  Created by Tomasz Popis on 09/02/16.
//  Copyright © 2016 Melon. All rights reserved.
//

import Foundation

public protocol MBFStyleKitKeyDecoderProtocol: class {
  func styleIdentifierForKey(_ key: String) -> String
}

open class MBFStyleKit {
  
  private static let mbfStyleKitColorsKey = "colors"
  private static let mbfStyleKitFontsKey = "fonts"
  private static let mbfStyleKitStylesKey = "styles"
  private static let mbfStyleKitTextFontKey = "font-name"
  private static let mbfStyleKitTextSizeKey = "font-size"
  private static let mbfStyleKitTextColorKey = "font-color"
  private static let mbfStyleKitTextAlignmentKey = "text-alignment"
  private static let mbfStyleKitParagraphSpacingKey = "paragraph-spacing"
  private static let mbfStyleKitLineSpacingKey = "line-spacing"
  
  open weak var styleKeyDecoderDelegate: MBFStyleKitKeyDecoderProtocol?
  
  open var defaultStyle: NSDictionary? {
    
    return nil
  }
  
  open var defaultColor: UIColor? {
    
    return nil
  }
  
  private var styles: Dictionary<String,AnyObject>?
  
  public init() {}
  
  public init(resourceName: String) {
    self.prepareFromBundle(resourceName)
  }
  
  open func prepareFromBundle(_ resourceName: String?) {
    let resourcePath =
      Bundle.main.path(forResource: resourceName,
                       ofType: "plist")
    
    if let path = resourcePath {
      self.styles = NSDictionary(contentsOfFile: path) as? Dictionary<String,AnyObject>
    }
  }
  
  open func colorForKey(_ key: String) -> UIColor {
    
    return self.colorForKey(key, alpha: 1.0)
  }
  
  open func colorForKey(_ key: String, alpha: Float) -> UIColor {
    var resultColor: UIColor = UIColor.white
    var colorValue: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    if var styleKey = self.styleKeyDecoderDelegate?.styleIdentifierForKey(key) {
      if self.existTextAttributesForKey(styleKey) == false {
        styleKey = key
      }
      
      if let resources = self.styles,
        let colors = resources[MBFStyleKit.mbfStyleKitColorsKey],
        let colorKey = colors[styleKey] as? String {
        colorValue = self.decodeColorFromString(colorKey)
        
        resultColor = UIColor(red: colorValue.red,
                              green: colorValue.green,
                              blue: colorValue.blue,
                              alpha: colorValue.alpha)
      }
    }
    
    return resultColor
  }
  
  fileprivate func decodeColorFromString(_ colorString: String) ->
    (red: CGFloat,green: CGFloat, blue: CGFloat, alpha: CGFloat) {
      
      var result: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
      result = (red: CGFloat(0.0),
                green: CGFloat(0),
                blue: CGFloat(0),
                alpha: CGFloat(1.0))
      
      let components = colorString.components(separatedBy: " ")
      
      if components.count == 4 {
        if let red = Float(components[0]) {
          result.red = CGFloat(red/255.0)
        }
        
        if let green = Float(components[1]) {
          result.green = CGFloat(green/255.0)
        }
        
        if let blue = Float(components[2]) {
          result.blue = CGFloat(blue/255.0)
        }
        
        if let alpha = Float(components[3]) {
          result.alpha = CGFloat(alpha)
        }
      }
      
      return result
  }
  
  open func existTextAttributesForKey(_ key: String) -> Bool {
    
    return self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[key] is Dictionary<String, AnyObject>
  }
  
  open func textAttributesForKey(_ key: String) -> [NSAttributedStringKey : Any] {
    
    return self.textAttributesForKey(key, textAlignment: NSTextAlignment.natural)
  }
  
  open func textAttributesForKey(_ key: String,
                                 textAlignment: NSTextAlignment) -> [NSAttributedStringKey : Any] {
    
    var textAttributes = Dictionary<NSAttributedStringKey,Any>()
    let paragraphAttributes = NSMutableParagraphStyle()
    
    if var styleKey = self.styleKeyDecoderDelegate?.styleIdentifierForKey(key) {
      if self.existTextAttributesForKey(styleKey) == false {
        styleKey = key
      }
      
      let font: UIFont?
      let fontColor: UIColor?
      
      if let style = self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[styleKey] as? Dictionary<String, AnyObject>,
        let colorKey = style[MBFStyleKit.mbfStyleKitTextColorKey] as? String,
        let fontSize = style[MBFStyleKit.mbfStyleKitTextSizeKey] as? Float,
        let fontKey = style[MBFStyleKit.mbfStyleKitTextFontKey] as? String,
        let alignment = style[MBFStyleKit.mbfStyleKitTextAlignmentKey] as? Int,
        let paragraphSpacing = style[MBFStyleKit.mbfStyleKitParagraphSpacingKey] as? Float,
        let lineSpacing = style[MBFStyleKit.mbfStyleKitLineSpacingKey] as? Float {
        
        fontColor = self.colorForKey(colorKey)
        font = self.fontForKey(fontKey, size: fontSize)
        
        paragraphAttributes.paragraphSpacing = CGFloat(paragraphSpacing);
        paragraphAttributes.alignment = NSTextAlignment(rawValue: alignment)!;
        paragraphAttributes.lineBreakMode = NSLineBreakMode.byWordWrapping;
        paragraphAttributes.lineSpacing = CGFloat(lineSpacing);
        
        textAttributes[NSAttributedStringKey.paragraphStyle] = paragraphAttributes
        textAttributes[NSAttributedStringKey.font] = font
        textAttributes[NSAttributedStringKey.foregroundColor] = fontColor
        
        if textAlignment != NSTextAlignment.natural {
          paragraphAttributes.alignment = textAlignment
        }
      }
    }
    
    return textAttributes
  }
  
  open func fontForKey(_ key: String, size: Float) -> UIFont? {
    var resultFont: UIFont?
    var font:(name: String, size: CGFloat)
    
    font = (name: "", size: CGFloat(size))
    
    if var styleKey = self.styleKeyDecoderDelegate?.styleIdentifierForKey(key) {
      if self.existTextAttributesForKey(styleKey) == false {
        styleKey = key
      }
      
      if let fontName = self.styles?[MBFStyleKit.mbfStyleKitFontsKey]?[styleKey] as? String {
        font.name = fontName
      }
      
      if font.name.count > 0 {
        resultFont = UIFont(name: font.name, size: font.size)
      } else {
        resultFont = UIFont.systemFont(ofSize: font.size)
      }
    }
    
    return resultFont
  }
}


