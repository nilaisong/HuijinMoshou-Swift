//
//  NetworkStatus.swift
//  MoShou2
//
//  Created by NiLaisong on 2017/11/17.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation

class NetworkStatus:NSObject
{
    static let  shareInstance = NetworkStatus.init()
    
    var reachability: Reachability!
    
    override init() {

        do
        {
            try reachability =  Reachability.init()
            // 网络可用或切换网络类型时执行
            reachability.whenReachable = { reach in
                // 判断网络状态及类型
                if reach.connection == .wifi {
                    print("网络类型：Wifi")
                } else if reach.connection == .cellular {
                    print("网络类型：移动网络可用")
                } else {
                    print("网络类型：无网络连接可用")
                }
            }
            // 网络不可用时执行
            reachability.whenUnreachable = { reach in
//                // 判断网络状态及类型
//                if reach.connection == .wifi {
//                    print("网络类型：Wifi")
//                } else if reach.connection == .cellular {
//                    print("网络类型：移动网络")
//                } else
//                {
                    print("网络类型：无网络连接")
//                }
            }
            
            do {
                // 开始监听
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
        catch
        {
            print("Unable to create reachability")
        }
    }
    
    var isConnected:Bool {
        if let reach = reachability
        {
            if reach.connection != .none{
                print("网络连接：可用")
                return true
            } else {
                print("网络连接：不可用")
                return false
            }
        }
        else
        {
            return false
        }
    }
    
    
}
