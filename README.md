# MCCameraZ

## 工程示例
下载此工程后打开，先从美测申请相关认证信息，然后配置一下Demo代码里的相关信息，真机上运行就能看到示例，SDK调用代码都在ViewController和CameraVC里

## SDK的编译环境和目标架构
* Xcode11.4.1
* Swift5
* iOS10+
* arm64, x86_64

## 安装
从Demo中复制MCCamera.framework出来拖到自己的工程里

## SDK详解
### 业务简介
iPad通过蓝牙控制硬件灯光设备，在5种不同灯光（日光、交叉、平行、UV、伍德）环境下，用iPad自带的相机分别拍摄不同的人脸照片，上传拍摄的照片到美测服务器进行分析，分析结束后美测服务器把结果传到第三方（集成使用美测SDK的公司）服务器上  

iOS蓝牙相机SDK只提供控件硬件灯光设备的接口、拍摄照片的接口、上传图片到美测服务器的接口；第三方使用这些接口自己实现UI及交互，第三方负责提供接收分析结果的接口并存储结果，后续下载图片和展示图片数据等业务需第三方自己实现  

### SDK概览
MCCamera包含1个网络接口类，2个功能类和2个相关代理：  
* 验证接口：MCApi  
* 蓝牙功能：MCBLE（相关代理：MCBLEDelegate）  
* 相机功能：MCCamera（相关代理：MCCameraDelegate）  

### MCAPI
1. 先设置美测和OEM的服务器接口地址
```swift
// 美测服务器接口地址设置
MCApi.server = "http://xx.xxx.xx:8089/api/"
MCApi.uploadserver = "http://xx.xxx.xx:25000/api/compute"
```
```swift
// OEM服务器接口地址和token（如果不使用UI层SDK可以不用设置）
MCApi.oemOssServer = "http://xxx.oss-cn-hangzhou.aliyuncs.com/"
MCApi.oemToken = xxx
MCApi.analysisListApi = "http://xxx.xxx.xxx/CUST-API/cust/listDiagnsByPage";
MCApi.analysisApi = "http://xxx.xxx.xxx/CUST-API/cust/getCustDiagnsDetailForMeicet"
```
        
2. 验证设备码和使用者的身份，此方法必须调用成功后才能进行后续操作
```swift
class func setup(deviceNumber: String, secret: String,  sucessBlock: @escaping () -> Void, failureBlock: @escaping (_ errCode: String, _ errMsg: String) -> Void)
```
3. 验证拍照参数，使用拍照功能前必须调用此方法，*userParams*必须有这些参数：`["name": "Al", "phone": "18511111111", "sex": "0", "year": "1991", "month": "11", "day": "08", "age": "27", "extra": "第三方自定义", "unionid": "第三方用户唯一id"]`
```swift
class func setupBeforeShoot(userParams: [String: String],  sucessBlock: @escaping () -> Void, failureBlock: @escaping (_ errCode: String, _ errMsg: String) -> Void)
```
4. 上传图片功能，*datas*是图片Data格式的数组，`MCCameraDelegate.didGenerateImage`生成的图片用`jpegData(compressionQuality: 0.7)`转换成Data，图片顺序为自动拍摄的顺序：[日光、交叉、平行、UV、伍德]；*fraction*是上传图片的进度，图片上传100%不代表此接口调用结束，上传100%后美测服务器会分析照片，这个过程没有进度，所以需要等待服务器返回后在*successBlock*中处理，*shootid*是分析结果的唯一ID
```swift
class func upload(datas: [Data], progressBlock: @escaping (_ fraction: Double ) -> Void, successBlock: @escaping (_ shootid: String) -> Void, failureBlock: @escaping (_ errCode: String, _ errMsg: String) -> Void)
```

### MCBLE
1. 使用蓝牙前先准备相关资源
```swift
func setup()
```
2. 开始搜索附近设备
```swift
func startScan()
```
3. 亮第几个灯[0…4], *value*是灯光亮度[0…255]；熄灯直接调用`lightupAt(0, value: 0)`；默认亮度分别是：daylight: 73, cross: 90, parallel: 100, uv: 158, wood: 153
```swift
func lightupAt(_ index: Int, value: Int)
```

### MCCamera
1. 初始配置，必须调用成功后才能进行后续操作，MCCameraPreviewView要在相机视图里创建并添加上
```swift
func setupWithPreview(_ preview: MCCameraPreviewView, successBlock: @escaping () -> Void, failureBlock: @escaping () -> Void)
```

2. 设置相机预览和拍照的方向，需要把iPad倒立时要在viewWillTransition里调用，还有在初始配置后调用，屏幕翻转，*isUpsideDown*为*true*为颠倒竖屏，*false*为正常竖屏
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

### MCBLEDelegate
1. 没有打开蓝牙回调方法
```swift
func requestOpenBLE()
```
2. 连接蓝牙成功回调方法
```swift
func didConnect()
```
3. 连接蓝牙失败回调方法
```swift
func didDisconnect()
```

### MCCameraDelegate
1. 相机权限被拒回调方法
```swift
func requestOpenCamera()
```
2. 拍照成功回调方法
```swift
func didGenerateImage(image: UIImage)
```
