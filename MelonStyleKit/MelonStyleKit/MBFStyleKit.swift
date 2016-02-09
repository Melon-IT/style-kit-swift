//
//  MBFStyleKit.swift
//  MelonStyleKit
//
//  Created by Tomasz Popis on 09/02/16.
//  Copyright © 2016 Melon-IT. All rights reserved.
//

import Foundation

public enum MBFStyleKitColorType: Int {
  case MBFStyleKitColorTypeDefault
  
  public init() {
    self = MBFStyleKitColorTypeDefault
  }
}

public enum MBFStyleKitFontType: Int {
  case MBFStyleKitFontTypeDefault
  
  public init() {
    self = .MBFStyleKitFontTypeDefault
  }
  
  var name: String {
    let fontNames = [
      "FontName-Regular"
    ]
    
    return fontNames[rawValue]
  }
}

public enum MBFStyleKitTextType: Int {
  case MBFStyleKitTextTypeDefault
  
  public init() {
    self = .MBFStyleKitTextTypeDefault
  }
}

public class MBFStyleKit {
  
  public var defaultColor: UIColor {
    
    return MBFStyleKit.colorForType(MBFStyleKitColorType())
  }
  
  public static func colorForType(type: MBFStyleKitColorType) -> UIColor {
    
    return self .colorForType(type, alpha: 1.0)
  }
  
  public static func colorForType(colorType: MBFStyleKitColorType, alpha: Float) -> UIColor {
    var resultColor: UIColor
    
    switch colorType {
      
    case .MBFStyleKitColorTypeDefault:
      resultColor = UIColor.blackColor()
      
    }
    
    return resultColor
  }
  
  public static func textAttributesForType(styleType: MBFStyleKitTextType) -> Dictionary<String,Any> {
    
    return MBFStyleKit.textAttributesForType(styleType, textAlignment: NSTextAlignment.Natural)
  }
  
  public static func textAttributesForType(styleType: MBFStyleKitTextType, textAlignment: NSTextAlignment) -> Dictionary<String,Any> {
    var textAttributes = Dictionary<String,Any>()
    var paragraphAttributes: NSMutableParagraphStyle
    
    switch styleType {
    case .MBFStyleKitTextTypeDefault:
      paragraphAttributes =
        MBFStyleKit.paragraphAttributesForSpacing(1,
          textAlignment: NSTextAlignment.Left,
          lineBreakMode: NSLineBreakMode.ByCharWrapping,
          lineSpacing: 1.0)
      
      textAttributes =
        MBFStyleKit.textAttributesForFontType(MBFStyleKitFontType.MBFStyleKitFontTypeDefault,
          fontSize: 10.0,
          textColor: MBFStyleKit.colorForType(MBFStyleKitColorType.MBFStyleKitColorTypeDefault),
          paragraphStyle: paragraphAttributes)
    }
    
    if textAlignment != NSTextAlignment.Natural {
      paragraphAttributes.alignment = textAlignment
    }
    
    return textAttributes
  }
  
  private static func fontForType(fontType: MBFStyleKitFontType, size: Float) -> UIFont? {
    var resultFont: UIFont?
    
    resultFont = UIFont.init(name: fontType.name, size: CGFloat(size))
    
    return resultFont
  }
  
  private static func paragraphAttributesForSpacing(paragraphSpacing: Float, textAlignment: NSTextAlignment, lineBreakMode: NSLineBreakMode, lineSpacing: Float) -> NSMutableParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle();
    
    paragraphStyle.paragraphSpacing = CGFloat(paragraphSpacing);
    paragraphStyle.alignment = textAlignment;
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.lineSpacing = CGFloat(lineSpacing);
    
    return paragraphStyle
  }
  
  private static func textAttributesForFontType(fontType: MBFStyleKitFontType,fontSize: Float, textColor: UIColor, paragraphStyle: NSParagraphStyle) -> Dictionary<String,Any> {
    var textAttributes = Dictionary<String,Any>()
    
    textAttributes[NSParagraphStyleAttributeName] = paragraphStyle;
    textAttributes[NSFontAttributeName] = MBFStyleKit.fontForType(fontType, size: fontSize)
    textAttributes[NSForegroundColorAttributeName] = textColor
    
    return textAttributes
  }
}

