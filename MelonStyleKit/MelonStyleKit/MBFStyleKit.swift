//
//  MBFStyleKit.swift
//  MelonStyleKit
//
//  Created by Tomasz Popis on 09/02/16.
//  Copyright © 2016 Melon-IT. All rights reserved.
//

import Foundation

public class MBFStyleKit {
  
  private static let mbfStyleKitColorsKey = "colors"
  private static let mbfStyleKitFontsKey = "fonts"
  private static let mbfStyleKitFontNameKey = "name"
  private static let mbfStyleKitFontSizeKey = "size"
  private static let mbfStyleKitStylesKey = "styles"
  private static let mbfStyleKitTextSize = "text-size"
  private static let mbfStyleKitTextColor = "text-color"
  private static let mbfStyleKitTextAlignment = "text-alignment"
  private static let mbfStyleKitParagraphSpacing = "paragraph-spacing"
  private static let mbfStyleKitLineSpacing = "line-spacing"
  
  public var defaultStyle: NSDictionary? {
    
    return nil
  }
  
  public var defaultColor: UIColor? {
    
    return nil
  }
  
  private var styles: NSDictionary?
  
  public init() {}
  
  public init(resourceName: String) {
    self.loadStylesFromResource(resourceName)
  }
  
  public func loadStylesFromResource(resourceName: String?) {
    let resourcePath = NSBundle.mainBundle().pathForResource(resourceName, ofType: "plist")
    
    if let path = resourcePath {
      self.styles = NSDictionary(contentsOfFile: path)
    } else {
      self.styles = nil
    }
  }
  
  public func colorForKey(key: String) -> UIColor {
    
    return self.colorForKey(key, alpha: 1.0)
  }
  
  public func colorForKey(key: String, alpha: Float) -> UIColor {
    var resultColor: UIColor
    var colorValue: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    colorValue = self.decodeColor(self.styles?[MBFStyleKit.mbfStyleKitColorsKey]?[key] as? String)
    
    resultColor = UIColor(red: colorValue.red as CGFloat, green: colorValue.green, blue: colorValue.blue, alpha: colorValue.alpha)
    
    return resultColor
  }
  
  private func decodeColor(string: String?) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    var result: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    result = (red: CGFloat(0.0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(1.0))
    

    if let colorString = string {
      result.red = 2.0
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
    }
    
    return result
  }
  
  public func textAttributesForKey(key: String) -> Dictionary<String,Any> {
    
    return self.textAttributesForKey(key, textAlignment: NSTextAlignment.Natural)
  }
  
  public func textAttributesForKey(key: String, textAlignment: NSTextAlignment) -> Dictionary<String,Any> {
    var textAttributes = Dictionary<String,Any>()
    var paragraphAttributes: NSMutableParagraphStyle
    
    let color = self.colorForKey(self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[key]??[MBFStyleKit.mbfStyleKitTextColor] as! String)
    let textAlignment = self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[key]??[MBFStyleKit.mbfStyleKitTextAlignment] as! Int
    let paragraphSpacing = self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[key]??[MBFStyleKit.mbfStyleKitParagraphSpacing] as! Float
    let lineSpacing = self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[key]??[MBFStyleKit.mbfStyleKitLineSpacing] as! Float
    let textSize = self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[key]??[MBFStyleKit.mbfStyleKitTextSize] as! Float
    
    paragraphAttributes =
      self.paragraphAttributesWithSpacing(paragraphSpacing,
        textAlignment: NSTextAlignment(rawValue: textAlignment)!,
        lineBreakMode: NSLineBreakMode.ByCharWrapping,
        lineSpacing: lineSpacing)
    
    textAttributes =
      self.textAttributesWithFont("", fontSize: textSize, textColor: color, paragraphStyle: paragraphAttributes)
    
    if textAlignment != NSTextAlignment.Natural.rawValue {
      paragraphAttributes.alignment = NSTextAlignment(rawValue: textAlignment)!
    }
    
    return textAttributes
  }
  
  public func fontForKey(key: String, size: Float) -> UIFont? {
    var resultFont: UIFont?
    
    var font:(name: String, size: CGFloat)
    
    font = (name: "", size: 10.0)
    
    if let fontName = self.styles?[MBFStyleKit.mbfStyleKitFontsKey]?[key]??[MBFStyleKit.mbfStyleKitFontNameKey] as? String {
      font.name = fontName
    }
    
    if let fontSize = self.styles?[MBFStyleKit.mbfStyleKitFontsKey]?[key]??[MBFStyleKit.mbfStyleKitFontsKey] as? Float {
      font.size = CGFloat(fontSize)
    }
    
    if font.name.characters.count > 0 {
      resultFont = UIFont(name: font.name, size: font.size)
    } else {
      resultFont = UIFont.systemFontOfSize(font.size)
    }
    
    
    return resultFont
  }
  
  private func paragraphAttributesWithSpacing(paragraphSpacing: Float, textAlignment: NSTextAlignment, lineBreakMode: NSLineBreakMode, lineSpacing: Float) -> NSMutableParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle();
    
    paragraphStyle.paragraphSpacing = CGFloat(paragraphSpacing);
    paragraphStyle.alignment = textAlignment;
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.lineSpacing = CGFloat(lineSpacing);
    
    return paragraphStyle
  }
  
  private func textAttributesWithFont(fontKey: String, fontSize: Float, textColor: UIColor, paragraphStyle: NSParagraphStyle) -> Dictionary<String,Any> {
    var textAttributes = Dictionary<String,Any>()
    
    textAttributes[NSParagraphStyleAttributeName] = paragraphStyle;
    textAttributes[NSFontAttributeName] = self.fontForKey(fontKey, size: fontSize)
    textAttributes[NSForegroundColorAttributeName] = textColor
    
    return textAttributes
  }
}

