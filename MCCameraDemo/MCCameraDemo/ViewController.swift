//
//  ViewController.swift
//  MCCameraDemo
//
//  Created by Al on 2020/5/11.
//  Copyright © 2020 meicet. All rights reserved.
//

import UIKit
import MCCamera

class ViewController: UIViewController {

    var secret = "a7deff60f237c153a6034a0e19c9aecc19a2e94d1d70901f9d22f4fdc4737c4b"
    var kmToken = "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxODYyMTUyNjcyNiIsInRlbmFudElkIjoxLCJ1c2VySWQiOjI0MzEsIm5hbWUiOiLmnY7mmJ_mmI4iLCJzdG9yZUlkIjo3MDQ3LCJwb3N0Q29kZSI6IjE0OTAxIiwib3JnSWQiOjcwNDcsImNoYW5uZWwiOjMsInVzZXJUeXBlIjoiOTAxMDEiLCJleHAiOjE1Njc3NDc3MTh9.VSiZBTsA8GBKC_J0Z2RyV0L5e9_crLdYgtRq2KPUJKALBWqrwj718y9g9qVePrOk4_CuZ5lH34oqmko_o0PulqqjlNg_W3yjM4cuWkJimXZ6ObuzwRQFUfgTinW5MLUXh7rN3zI30JPIb-k-nRiSRf5NZ0R3zze4-wHjm79pMzE"
    var devNumber = "MC680-61A279A18F04"
    var kmOssServer = "http://km-diagns.oss-cn-hangzhou.aliyuncs.com/"
    var custId = "1109"
    var shootid = "7bf758bb-32ec-4eb3-974e-07a597f28c11"
    var analysisApi = "https://api.km-union.com/CUST-API/cust/getCustDiagnsDetailForMeicet"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 把导航栏设置为不透明
        navigationController?.navigationBar.isTranslucent = false
        
        // 先初始化SDK，只有成功后才能进行之后的操作
        MCApi.setup(deviceNumber: "", secret: "", sucessBlock: {
            
        }, failureBlock: { (errCode, errMsg) in
            print("errCode: \(errCode), errMsg: \(errMsg)")
        })
    }

    @IBAction func clickShootBtn(_ sender: Any) {
        // 这个参数就是根据不同客户进行不同定义, 下面列出的key必须有，unionid就是你们系统中的客户id
        let params = ["name": "Al", "phone": "18511111111", "sex": "0", "year": "1991", "month": "11", "day": "08", "age": "27", "extra": "deviceId=\(devNumber)&custId=\(custId)", "unionid": custId]
        MCApi.setupBeforeShoot(userParams: params, sucessBlock: {
            let cameraVC = CameraVC()
            self.navigationController?.pushViewController(cameraVC, animated: true)
        }, failureBlock: { (errCode, errMsg) in
            print("errCode: \(errCode), errMsg: \(errMsg)")
        })
    }
    
}

