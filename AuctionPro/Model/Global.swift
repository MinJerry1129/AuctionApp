//
//  Global.swift
//  dancontrol
//
//  Created by Ertuğrul Üngör on 15.12.2017.
//  Copyright © 2017 Dancontrol. All rights reserved.
//

class Global {
    static let baseUrl = "http://the-work-kw.com/auction/ios/"
    static let imageUrl = "http://the-work-kw.com/auction/"
    //static let baseUrl = "http://83.88.194.138/DanControlBackendAPI/"
    static func validateImg(signString:String?,max:Int) -> Int {
        var temp = 0
        if signString != "" && signString != nil {
            temp = Int(signString!)!
        }
        if temp < 0 || temp > max {
            temp = 0
        }
        return temp
    }
}
