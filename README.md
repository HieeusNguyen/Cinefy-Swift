# Cinefy

## Hướng dẫn build dự án
- B1: Sau khi clone dự án về, cần phải mở terminal và trỏ đến thư mục Cinefy (thư mục chứa Podfile)
- B2: Thực hiện lệnh `pod install` để tải các library của dự án
- B3: Chạy chương trình

## Các thư viện trong dự án cần sửa
### BMPlayer
- Do thư viện này đã quá cũ nên nhiều chức năng không còn hoạt động trên iOS 16.0
- Trong dự án này, đã sửa chức năng FullScreen trong source code của thư viện
```swift
@objc fileprivate func fullScreenButtonPressed() {
    controlView.updateUI(!self.isFullScreen)
    
    if #available(iOS 16.0, *) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        if isFullScreen {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        } else {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
        }
    } else {
        if isFullScreen {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
    }
}
```
### FSPagerView
- Để sửa cornerRadius cho ảnh thì cũng phải sửa trong source code của thư viện

### ESTabBarController-swift
- Trong thư viện này, muốn tuỳ chỉnh chiều cao của TabBar thì phải sửa source code của thư viện như sau:
```swift
public var tabBarHeight: CGFloat?{
        didSet{
            guard tabBarHeight ?? 0 > 0 else{
                return
            }
            setNeedsLayout()
        }
    }
```
```swift
open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let defaultSize = super.sizeThatFits(size)
        if let tabBarHeight, tabBarHeight > 0{
            return CGSize(width: defaultSize.width, height: tabBarHeight)
        }
        return defaultSize
    }
```
