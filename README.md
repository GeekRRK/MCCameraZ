# MCCameraZ

```swift
func setupWithMCDeviceSpec(_ specification: Int, previewLayer: AVCaptureVideoPreviewLayer, successBlock: @escaping () -> Void, failureBlock: @escaping () -> Void)
```

```swift
func setVideoOrientation(isUpsideDown: Bool)
```

```swift
func capture(forLight light: Int)
```

```swift
func refocus()
```

```swift
func stopRunning()
```

```swift
func startRunning()
```

```swift
var delegate: MCCameraDelegate?
```

```swift
func requestOpenCamera()
```

```swift
func didGenerateImage(image: UIImage)
```
