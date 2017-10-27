//
//  AccountService_APIEnum.swift
//  MoShou2
//  提供用户相关的登录、注册、修改密码和个人信息等业务接口类型
//  Created by NiLaisong on 2017/10/23.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation

//原始值可以是字符串，字符，或者任何整型值或浮点型值。每个原始值在它的枚举声明中必须是唯一的
//其他类型可以被枚举继承
enum AccountServiceType {
    case login(mobile: String,passWord: String)//登录
    case userInfo//获取用户信息
    case logout//退出
    case updateAvatar(UIImage)//更新头像，参数标签在从枚举取值的时候没用，但调用的时候有用
    case submitFeedback(content:String,imgArray:[UIImage])//意见反馈
}
//通过集成协议扩展枚举类型
extension AccountServiceType:TargetType
{
    var method: Method {
        switch self {
        case .login(_, _):
            return .post
        case .userInfo:
            return .post
        case .logout:
            return .post
        case .updateAvatar(_):
             return .post
        case .submitFeedback(_, _):
             return .post
        }
       
    }
    //根据自身枚举类型设置对应数据接口path属性
    var path: String {
        switch self {
        case .login(_, _):
            return "/dologin"
        case .userInfo:
            return "/userinfo"
        case .logout:
            return "/logout"
        case .updateAvatar(_):
            return "/api/user/updateHeadpic"
        case .submitFeedback(_, _):
            return "/api/opinion/saveOpinion"
        }
    }
    //根据自身枚举类型设置对应数据接口任务功能和请求参数
    var task: Task {
        switch self
        {
        case .login(let mobile, let passWord)://使用let从枚举里取出相关值
            Tool.removeCache("user_token")//清除token
            return .postParameters(["principal": mobile, "password": passWord,"validepassword":"1"])
        case .userInfo:
            return .requestPlain
        case .logout:
            return .requestPlain
        case .updateAvatar(let avatar):
            if let imageData = UIImageJPEGRepresentation(avatar, 0.1)
            {
                let imageName = uniquePicName(typeName:"jpg")
                let provider = MoyaMultipartFormData.FormDataProvider.data(imageData)
                let multipartImages = MoyaMultipartFormData.init(provider:provider , name: "img", fileName: imageName, mimeType: "image/jpeg/png")
                return .uploadMultipart([multipartImages])
            }
            else
            {
                return .requestPlain
            }
        case .submitFeedback(let content,let imgArray):
            var formDataArray:[MoyaMultipartFormData] = []
            
            for index in 0..<imgArray.count //1..<
            {
                if let imageData = UIImageJPEGRepresentation(imgArray[index], 0.1)
                {
                    let strNum = "\(index)"
                    let imageName = uniquePicName(strNum,typeName:"jpg")
                    let provider = MoyaMultipartFormData.FormDataProvider.data(imageData)
                    let multipartImage = MoyaMultipartFormData.init(provider:provider , name: "img\(index)", fileName: imageName, mimeType: "image/jpeg/png")
                    formDataArray.append(multipartImage)
                }
            }
            //字符串转换到Data-字符串对象提供转换为data的方法
            if let contentData = content.data(using: String.Encoding.utf8)
            {
                let provider = MoyaMultipartFormData.FormDataProvider.data(contentData)
                let multipartContent = MoyaMultipartFormData.init(provider:provider , name: "msg")
                formDataArray.append(multipartContent)
            }
            return .uploadMultipart(formDataArray)
        }
    }
}
