#Using MBFStyleKit

To create an instance of the StyleKit:
```swift
let styleKit = MStyleKit()
```

To load styles from resources:
```swift
styleKit.loadStylesFromResource("file-name")
```

To retrieve style for specified key:
```swift
let style = styleKit.textAttributesForKey("style-key"))
```

To change text alignment defined in style:
```swift
let style = styleKit.textAttributesForKey("style-key", textAlignment: NSTextAlignment.Center)
```

To combine style with text:
```swift
let text: String
//..
let style = styleKit.textAttributesForKey("style-key"))
let attributedText = NSAttributedString(string: text, attributes: style)
```

#**MBFStyleKitKeyDecoderProtocol**
For example, if you have a separate set of styles for iPhone and iPad and you still want to use the same name for particular style the MBFStyleKitKeyDecoderProtocol is a good place to translate name of style for appropriate platform.

Here is a simple example of how you can implement the `styleIdentifierForKey` method:
```swift
  public func styleIdentifierForKey(key: String) -> String {
    var result: String
    
    result = key
    
    if MBFBaseManager.isIPad == true {
      result += "-iPad"
    }
    
    return result
  }
  ```
  
In that case do not forget to assign object which implements the MBFStyleKitKeyDecoderProtocol to instance of StyleKit.
You should do that like this:
```swift
let decoderDelegate: MBFStyleKitKeyDecoderProtocol
//...
self.styleKit.styleKeyDecoderDelegate = decoderDelegate
```
