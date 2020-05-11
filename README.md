# MCCameraZ

1. 初始配置，必须调用成功后才能进行后续操作
```swift
func setupWithPreview(_ preview: MCCameraPreviewView, successBlock: @escaping () -> Void, failureBlock: @escaping () -> Void)
```

2. 设置相机预览和拍照的方向，需要把iPad倒立时要在viewWillTransition里调用，还有在初始配置后调用
```swift
func setVideoOrientation(isUpsideDown: Bool)
```

3. 在哪个灯光下拍照（日光(0)、交叉(1)、平行(2)、UV(3)、Wood(4)），拍照成功后会回调```didGenerateImage```
```swift
func capture(forLight light: Int)
```

4. 重新自动对焦，一般在重拍时调用，或自动和手动切换后调用
```swift
func refocus()
```

5. 停止相机会话，一般在完成全部拍照后调用
```swift
func stopRunning()
```

6. 开始相机会话，一般在拍完全部照片后，重拍时调用
```swift
func startRunning()
```

7. 记得要设置代理
```swift
var delegate: MCCameraDelegate?
```

8. 代理方法：相机不可用或没打开等情况会回调
```swift
func requestOpenCamera()
```

9. 代理方法：调用```capture```方法后生成图片时会回调
```swift
func didGenerateImage(image: UIImage)
```
