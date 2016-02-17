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
  private static let mbfStyleKitStylesKey = "styles"
  private static let mbfStyleKitTextFontKey = "font-name"
  private static let mbfStyleKitTextSizeKey = "font-size"
  private static let mbfStyleKitTextColorKey = "font-color"
  private static let mbfStyleKitTextAlignmentKey = "text-alignment"
  private static let mbfStyleKitParagraphSpacingKey = "paragraph-spacing"
  private static let mbfStyleKitLineSpacingKey = "line-spacing"
  
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
  
  public func textAttributesForKey(key: String) -> Dictionary<String,AnyObject> {
    
    return self.textAttributesForKey(key, textAlignment: NSTextAlignment.Natural)
  }
  
  public func textAttributesForKey(key: String, textAlignment: NSTextAlignment) -> Dictionary<String,AnyObject> {
    var textAttributes = Dictionary<String,AnyObject>()
    let paragraphAttributes = NSMutableParagraphStyle()
    
    let fontColor = self.colorForKey(self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[key]??[MBFStyleKit.mbfStyleKitTextColorKey] as! String)
    let fontSize = self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[key]??[MBFStyleKit.mbfStyleKitTextSizeKey] as! Float
    let font = self.fontForKey(self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[key]??[MBFStyleKit.mbfStyleKitTextFontKey] as! String, size: fontSize)
    
    let textAlignment = self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[key]??[MBFStyleKit.mbfStyleKitTextAlignmentKey] as! Int
    let paragraphSpacing = self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[key]??[MBFStyleKit.mbfStyleKitParagraphSpacingKey] as! Float
    let lineSpacing = self.styles?[MBFStyleKit.mbfStyleKitStylesKey]?[key]??[MBFStyleKit.mbfStyleKitLineSpacingKey] as! Float
    
    paragraphAttributes.paragraphSpacing = CGFloat(paragraphSpacing);
    paragraphAttributes.alignment = NSTextAlignment(rawValue: textAlignment)!;
    paragraphAttributes.lineBreakMode = NSLineBreakMode.ByWordWrapping;
    paragraphAttributes.lineSpacing = CGFloat(lineSpacing);

    textAttributes[NSParagraphStyleAttributeName] = paragraphAttributes;
    textAttributes[NSFontAttributeName] = font
    textAttributes[NSForegroundColorAttributeName] = fontColor
    
    if textAlignment != NSTextAlignment.Natural.rawValue {
      paragraphAttributes.alignment = NSTextAlignment(rawValue: textAlignment)!
    }
    
    return textAttributes
  }
  
  public func fontForKey(key: String, size: Float) -> UIFont? {
    var resultFont: UIFont?
    
    var font:(name: String, size: CGFloat)
    
    font = (name: "", size: CGFloat(size))
    
    if let fontName = self.styles?[MBFStyleKit.mbfStyleKitFontsKey]?[key] as? String {
      font.name = fontName
    }

    
    if font.name.characters.count > 0 {
      resultFont = UIFont(name: font.name, size: font.size)
    } else {
      resultFont = UIFont.systemFontOfSize(font.size)
    }
    
    return resultFont
  }
}

