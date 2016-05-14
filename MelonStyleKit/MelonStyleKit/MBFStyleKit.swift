//
//  MBFStyleKit.swift
//  MelonStyleKit
//
//  Created by Tomasz Popis on 09/02/16.
//  Copyright © 2016 Melon-IT. All rights reserved.
//

import Foundation

public protocol MBFStyleKitKeyDecoderProtocol: class {
  func styleIdentifierForKey(key: String) -> String
}

public class MBFStyleKit {
  
  private static let mbfStyleKitColorsKey = "colors"
  private static let mbfStyleKitFontsKey = "fonts"
  private static let mbfStyleKitStylesKey = "styles"
  private static let mbfStyleKitTextFontKey = "font-name"
  private static let mbfStyleKitTextSizeKey = "font-size"
  private static let mbfStyleKitTextColorKey = "font-color"
  private static let mbfStyleKitTextAlignmentKey = "text-alignment"
  private static let mbfStyleKitParagraphSpacingKey = "paragraph-spacing"
  private static let mbfStyleKitLineSpacingKey = "line-spacing"
  
  public weak var styleKeyDecoderDelegate: MBFStyleKitKeyDecoderProtocol?
  
  public var defaultStyle: NSDictionary? {
    
    return nil
  }
  
  public var defaultColor: UIColor? {
    
    return nil
  }
  
  private var styles: Dictionary<String,AnyObject>?
  
  public init() {}
  
  public init(resourceName: String) {
    self.loadStylesFromResource(resourceName)
  }
  
  public func loadStylesFromResource(resourceName: String?) {
    let resourcePath =
      NSBundle.mainBundle().pathForResource(resourceName,
                                            ofType: "plist")
    
    if let path = resourcePath {
      self.styles = NSDictionary(contentsOfFile: path) as? Dictionary<String,AnyObject>
    }
  }
  
  public func colorForKey(key: String) -> UIColor {
    
    return self.colorForKey(key, alpha: 1.0)
  }
  
  public func colorForKey(key: String, alpha: Float) -> UIColor {
    var resultColor: UIColor = UIColor.whiteColor()
    var colorValue: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    if var styleKey = self.styleKeyDecoderDelegate?.styleIdentifierForKey(key) {
      if self.existTextAttributesForKey(styleKey) == false {
        styleKey = key
      }
      
      if let resources = self.styles,
        let colors = resources[MBFStyleKit.mbfStyleKitColorsKey],
        let colorKey = colors[styleKey] as? String {
        colorValue = self.decodeColor(colorKey)
        
        resultColor = UIColor(red: colorValue.red,
                              green: colorValue.green,
                              blue: colorValue.blue,
                              alpha: colorValue.alpha)
      }
    }
    
    return resultColor
  }
  
  private func decodeColor(colorString: String) ->
    (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
      
      var result: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
      result = (red: CGFloat(0.0),
                green: CGFloat(0),
                blue: CGFloat(0),
                alpha: CGFloat(1.0))
      
      let components = colorString.componentsSeparatedByString(" ")
      
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
  
  public func existTextAttributesForKey(key: String) -> Bool {
    
    return self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[key] is Dictionary<String, AnyObject>
  }
  
  public func textAttributesForKey(key: String) -> Dictionary<String,AnyObject> {
    
    return self.textAttributesForKey(key, textAlignment: NSTextAlignment.Natural)
  }
  
  public func textAttributesForKey(key: String,
                                   textAlignment: NSTextAlignment) -> Dictionary<String,AnyObject> {
    
    var textAttributes = Dictionary<String,AnyObject>()
    let paragraphAttributes = NSMutableParagraphStyle()
    
    if var styleKey = self.styleKeyDecoderDelegate?.styleIdentifierForKey(key) {
      if self.existTextAttributesForKey(styleKey) == false {
        styleKey = key
      }
      
      let font: UIFont?
      let fontColor: UIColor?
      
      if let resources = self.styles,
        let styles = resources[MBFStyleKit.mbfStyleKitStylesKey],
        let style = styles[styleKey],
        let styleItem = style,
        let colorKey = styleItem[MBFStyleKit.mbfStyleKitTextColorKey] as? String,
        let fontSize = styleItem[MBFStyleKit.mbfStyleKitTextSizeKey] as? Float,
        let fontKey = styleItem[MBFStyleKit.mbfStyleKitTextFontKey] as? String,
        let alignment = styleItem[MBFStyleKit.mbfStyleKitTextAlignmentKey] as? Int,
        let paragraphSpacing = styleItem[MBFStyleKit.mbfStyleKitParagraphSpacingKey] as? Float,
        let lineSpacing = styleItem[MBFStyleKit.mbfStyleKitLineSpacingKey] as? Float {
        
        fontColor = self.colorForKey(colorKey)
        font = self.fontForKey(fontKey, size: fontSize)
        
        paragraphAttributes.paragraphSpacing = CGFloat(paragraphSpacing);
        paragraphAttributes.alignment = NSTextAlignment(rawValue: alignment)!;
        paragraphAttributes.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        paragraphAttributes.lineSpacing = CGFloat(lineSpacing);
        
        textAttributes[NSParagraphStyleAttributeName] = paragraphAttributes;
        textAttributes[NSFontAttributeName] = font
        textAttributes[NSForegroundColorAttributeName] = fontColor
        
        if textAlignment != NSTextAlignment.Natural {
          paragraphAttributes.alignment = textAlignment
        }
      }
    }
    
    return textAttributes
  }
  
  public func fontForKey(key: String, size: Float) -> UIFont? {
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
      
      if font.name.characters.count > 0 {
        resultFont = UIFont(name: font.name, size: font.size)
      } else {
        resultFont = UIFont.systemFontOfSize(font.size)
      }
    }
    
    return resultFont
  }
}

