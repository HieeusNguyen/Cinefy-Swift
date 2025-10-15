# Cinefy
## BMPlayer
- Do thư viện này đã quá cũ nên nhiều chức năng không còn hoạt động trên iOS 13.0
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
## FSPagerView
- Để sửa cornerRadius cho ảnh thì cũng phải sửa trong source code của thư viện
- Sửa như nào thì không nhớ nữa 🙂
