//
//  MoShouTargetType.swift
//  MoShou2
//
//  Created by NiLaisong on 2017/12/1.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation
import Moya

let kBaseUrl:String = LocalFileSystem.sharedManager().baseURL

protocol MoShouTargetType:TargetType
{
    
}

extension MoShouTargetType
{
    var baseURL: URL {
        
        return URL(string: kBaseUrl)!
    }
}
