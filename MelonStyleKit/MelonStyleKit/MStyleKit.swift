//
//  MBFStyleKit.swift
//  MelonStyleKit
//
//  Created by Tomasz Popis on 09/02/16.
//  Copyright © 2016 Melon. All rights reserved.
//

import UIKit

typealias RGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

public protocol MStyleKitDeviceKeyDelegate: class {
  func styleIdentifier(for key: String) -> String
}

public class MStyleKit {
  
  //MARK: Keys
  private static let colorsKey = "colors"
  private static let fontsKey = "fonts"
  private static let stylesKey = "styles"
  
  private static let fontKey = "font-name"
  private static let textSizeKey = "font-size"
  private static let textColorKey = "font-color"
  private static let textAlignmentKey = "text-alignment"
  private static let paragraphSpacingKey = "paragraph-spacing"
  private static let lineSpacingKey = "line-spacing"
  
  //MARK: Delegate
  /**
   The Delegate that determine prefix for styles specific to the concrete device type.
   */
  public weak var keyDelegate: MStyleKitDeviceKeyDelegate?
  
  //MARK: Default style
  private var defaultColor: UIColor = UIColor.black
  //private var defaultStyle: [String: AnyObject]?
  
  //MARK: Collection
  /**
   Styles definitions from the .plist file.
   */
  private var collection: [String: AnyObject]?
  
  //MARK: Initializing
  /**
   Creates the StyleKit object with resources from a bundle.
   
   - parameters:
   - name: Name of the .plist file.
   - bundle: Name of the bundle where the .plist file is located.
   */
  public init(resource name: String,
              from bundle:Bundle) {
    
    self.prepare(resource: name, from: bundle)
  }
  /**
   Creates the StyleKit object with resources from the main bundle.
   
   - parameters:
   - name: Name of the .plist file.
   */
  public convenience init(resource name: String) {
    self.init(resource: name, from: Bundle.main)
  }
  
  //MARK: Reading attributes
  /**
   Make collection of attributes for the `NSAttributedString`.
   
   - parameters:
   - key: Identifier for particular style in collection.
   - alignment: Optional value that if it exist it override text alignment property.
   */
  public func attributes(for key: String,
                         alignment: NSTextAlignment = .natural) -> [NSAttributedString.Key : Any] {
    
    var textAttributes = [NSAttributedString.Key: Any]()
    let paragraphAttributes = NSMutableParagraphStyle()
    
    if var styleKey = self.keyDelegate?.styleIdentifier(for: key) {
      
      if self.existAttributes(for: styleKey) == false {
        styleKey = key
      }
      
      let font: UIFont?
      let fontColor: UIColor?
      
      if let style = self.collection?[MStyleKit.stylesKey]?[styleKey] as? [String: AnyObject],
         let colorKey = style[MStyleKit.textColorKey] as? String,
         let fontSize = style[MStyleKit.textSizeKey] as? Float,
         let fontKey = style[MStyleKit.fontKey] as? String,
         let textAlignment = style[MStyleKit.textAlignmentKey] as? Int,
         let paragraphSpacing = style[MStyleKit.paragraphSpacingKey] as? Float,
         let lineSpacing = style[MStyleKit.lineSpacingKey] as? Float {
        
        fontColor = self.color(for: colorKey)
        font = self.font(for: fontKey, size: fontSize)
        
        paragraphAttributes.paragraphSpacing = CGFloat(paragraphSpacing);
        paragraphAttributes.alignment = NSTextAlignment(rawValue: textAlignment)!;
        paragraphAttributes.lineBreakMode = NSLineBreakMode.byWordWrapping;
        paragraphAttributes.lineSpacing = CGFloat(lineSpacing);
        
        textAttributes[NSAttributedString.Key.paragraphStyle] = paragraphAttributes
        textAttributes[NSAttributedString.Key.font] = font
        textAttributes[NSAttributedString.Key.foregroundColor] = fontColor
        
        if alignment != NSTextAlignment.natural {
          paragraphAttributes.alignment = alignment
        }
      }
    }
    
    return textAttributes
  }
  
  //MARK: Reading file
  private func prepare(resource name: String?,
                       from bundle: Bundle = Bundle.main) {
    
    if let path = bundle.path(forResource: name, ofType: "plist"),
       let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
      
      self.collection =
        try! PropertyListSerialization.propertyList(from: data,
                                                    options: PropertyListSerialization.ReadOptions.mutableContainers,
                                                    format: nil) as! [String: AnyObject]
    }
  }
  
  //MARK: Retrieving information from resources
  private func existAttributes(for key: String) -> Bool {
    
    return self.collection?[MStyleKit.stylesKey]?[key] is [String: AnyObject]
  }
  
  public func color(for key: String,
                    withAlpha: Float = 1.0) -> UIColor {
    
    var result = self.defaultColor
    
    var color: RGBA
    
    if var styleKey = self.keyDelegate?.styleIdentifier(for: key) {
      
      if self.existAttributes(for: styleKey) == false {
        styleKey = key
      }
      
      if let styles = self.collection,
         let colors = styles[MStyleKit.colorsKey],
         let colorKey = colors[styleKey] as? String {
        
        color = self.decodeColor(from: colorKey)
        
        result = UIColor(red: color.red,
                         green: color.green,
                         blue: color.blue,
                         alpha: color.alpha)
      }
    }
    
    return result
  }
  
  private func font(for key: String,
                    size: Float) -> UIFont {
    
    var result: UIFont = UIFont.systemFont(ofSize: CGFloat(size))
    
    if var styleKey = self.keyDelegate?.styleIdentifier(for: key) {
      if self.existAttributes(for: styleKey) == false {
        styleKey = key
      }
      
      if let fontName = self.collection?[MStyleKit.fontsKey]?[styleKey] as? String,
         let font =  UIFont(name: fontName, size: CGFloat(size)) {
        
        result = font
      }
    }
    
    return result
  }
  
  private func decodeColor(from string: String) -> RGBA {
    
    var result = RGBA(0,0,0,0)
    
    let components = string.components(separatedBy: " ")
    
    if components.count == 4 {
      result.red = CGFloat((Float(components[0]) ?? 0)/255)
      result.green = CGFloat((Float(components[1]) ?? 0)/255)
      result.blue = CGFloat((Float(components[2]) ?? 0)/255)
      result.alpha = CGFloat((Float(components[3]) ?? 1))
    }
    
    return result
  }
}
