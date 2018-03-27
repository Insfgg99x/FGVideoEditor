![](/img/title.png)

[![Version](https://img.shields.io/cocoapods/v/FGHUD.svg?style=flat)](http://cocoadocs.org/docsets/FGHUD)
[![License](https://img.shields.io/cocoapods/l/FGHUD.svg?style=flat)](http://cocoadocs.org/docsets/FGHUD)
[![Platform](https://img.shields.io/cocoapods/p/FGHUD.svg?style=flat)](http://cocoadocs.org/docsets/FGHUD)
![Language](https://img.shields.io/badge/Language-%20Swift%204.0%20-blue.svg)

----------------------------------------
### FGHUD

- [x] HUD
- [x] Toast
- [x] Rotation support

### Feathures

![](/img/1.png)
![](/img/2.png)
![](/img/3.png)
![](/img/4.png)
![](/img/5.png)
![](/img/6.png)
![](/img/7.png)

![](/img/demo.gif)

****See Vedio Here****
[Vedio](https://pan.baidu.com/s/1mb7OGRJsU0nDDhGTanW9cg)

### Usage

#### In UIViewController or subclass, UIView or subclass, you can use:

```swift
showHUD()
showHUD(.loading("Loading..."))
showHUD(.success("Success"))
showHUD(.error("Operation Error"))
showHUD(.warning("watch Out!"))
showHUD(.content("Hi, FGHUD"))
showHUD(.toast("Hi, FGHUD"))
```

### Hide a HUD

```swift
hideHUD()
```
****HUD with type success,error,warning,toast will auto dismiss itself****

### Install
```
pod 'FGHUD', '~> 2.4'
```
and import 
```swift
  import FGHUD
```

### Style

```swift
public enum HUDType {
    //show a hud with template
    case loading(String?)
    //show success
    case success(String?)
    //show error
    case error(String?)
    //show warn
    case warning(String?)
    //show given content
    case content(String?)
    //auto dismiss after given time(FGHUDToastDuration)
    case toast(String?)
}
```

### Required

- [x] Xocde 9
- [x] Swift 4.x
