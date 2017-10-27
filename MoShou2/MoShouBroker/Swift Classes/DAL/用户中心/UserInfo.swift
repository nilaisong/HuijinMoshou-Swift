//
//  UserInfo.swift
//  MoShou2
//
//  Created by NiLaisong on 2017/10/26.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation

class UserInfo:NSObject,HandyJSON
{
    required override init()
    {
        super.init()
        
        //如果用户相关信息不存在就需要从文件存储里找找
        if let _userId = Tool.getCache("newUserId") as? String
        {
            userId = _userId
        }
        if let _userName = Tool.getCache("userName") as? String
        {
            userName = _userName
        }
        if let _gender = Tool.getCache("gender") as? String
        {
            gender = _gender
        }
        if let _mobile = Tool.getCache("mobile") as? String
        {
            mobile = _mobile
        }
        if let _employeeNo = Tool.getCache("employeeNo") as? String
        {
            employeeNo = _employeeNo
        }
        if let _avatar = Tool.getCache("avatar") as? String
        {
            avatar = _avatar
        }
        if let _storeNum = Tool.getCache("storeNum") as? String
        {
            storeNum = _storeNum
        }
        if let _points = Tool.getCache("points") as? String
        {
            points = _points
        }
        if let  _isSignIn = Tool.getCache("isSignIn") as? NSNumber
        {
            isSignIn = _isSignIn.boolValue
        }
        if let _maxRecommendCount = Tool.getCache("maxRecommendCount") as? String
        {
            maxRecommendCount = _maxRecommendCount
        }
        if let  _mobileVisable = Tool.getCache("mobileVisable") as? NSNumber
        {
            mobileVisable = _mobileVisable.boolValue;
        }
        if let _offlineMsgCount = Tool.getCache("offlineMsgCount") as? String
        {
            offlineMsgCount = _offlineMsgCount
        }
        if let isTrystCarEnable = Tool.getCache("trystCarEnable") as? NSNumber
        {
            trystCarEnable = isTrystCarEnable.boolValue
        }
        if let _cityId = Tool.getCache("cityId") as? String
        {
            cityId = _cityId
        }
        if let _cityName = Tool.getCache("cityName") as? String
        {
            cityName = _cityName
        }
        if let _shareRange = Tool.getCache("shareRange") as? String
        {
            shareRange = _shareRange
        }
 
    }
    //把通过mapping方法人为映射取到值的私有字段赋值给添加了观察期的对应字段，
    //因为添这些加了观察器的字段不能通过mapping方法人为映射取到值，但他们又需要实时把最新值存储到文件
    func initialize()
    {
        userId = id
        userName = nickname
        storeNum = storeNumber
        avatar = headPic
        cityId = areaId
        cityName = areaName
        mobileVisable = _mobileVisable
        points = _points
        shareRange = _shareRange
        trystCarEnable = _trystCarEnable
        isSignIn = isSign
        maxRecommendCount = _maxRecommendCount
    }
    //杀死进程重启后（在线状态）需要用到但又无法及时获取到信息的字段，需要文件存储以便重启后有值用，
    //其他需要在个人信息用到的字段则会在调用接口时重新获取而不必存下来
    private var id:String = ""
    var userId:String = ""//用户编号，可用作极光推送的别名alias
    {//需要在mapping方法里认为指定映射的字段，不能再添加观察器或作为计算属性，否则映射赋值失败
        didSet{
             Tool.setCache("newUserId",value:userId)
        }
    }
    private var nickname:String = ""
    var userName:String = ""//用户名
    {
        didSet{
            Tool.setCache("userName",value:userName)
        }
    }
    var storeId:String = ""//门店编号  唯一码
    private var storeNumber:String = ""
    var storeNum:String = ""//门店编号  唯一码
    {
        didSet{
            Tool.setCache("storeNum",value:storeNum)
        }
    }
    var storeName:String = ""//店面名称
    var gender:String = ""//性别
    {//不需要在mapping方法里人为指定映射的字段，可以作为计算属性或添加属性观察期，能自动映射赋值成功
        didSet{
            Tool.setCache("gender",value:gender)
        }
    }
    var mobile:String = ""//手机号
    {
        didSet{
            Tool.setCache("mobile",value:mobile)
        }
    }
    var employeeNo:String = ""//员工编号
    {
        didSet{
            Tool.setCache("employeeNo",value:employeeNo)
        }
    }
    var orgnizationName:String = ""//机构名称
    private var headPic:String = ""
    var avatar:String = ""//头像
    {
        didSet{
            Tool.setCache("avatar",value:self.avatar)
            if let account = Tool.getCache("user_account") as? String
            {
                Tool.setCache(account,value:self.avatar)
            }
        }
    }
    private var areaId:String = ""
    var cityId:String = ""//门店所在城市  后台返回  绑定过门店才有
    {
        didSet{
            Tool.setCache("cityId",value:cityId)
        }
    }
    private var areaName:String = ""
    var cityName:String = ""//门店所在城市  后台返回  绑定过门店才有
    {
        didSet{
             Tool.setCache("cityName",value:cityName)
        }
    }
    var limitEmployeeNo:Bool = false//员工编号是否为必填项，0非必填  1为必填
    
    private var _mobileVisable:Bool = false
    //客户手机号是否全部显示 （0全部显示，1部分显示）
    var mobileVisable:Bool = false
    {
        didSet{
            let _mobileVisable  =  NSNumber.init(value: mobileVisable)
            Tool.setCache("trystCarEnable",value:_mobileVisable)
        }
    }
    private var _points:String = ""
    var points:String = ""//积分
    {
        didSet{
             Tool.setCache("points",value:points)
        }
    }
    //是否有待审批的换店审请(新后台)
    var isExchangeShop:Int = 0//0代表可以换店，1代表不能换店
    var offlineMsgCount:String = ""//环信聊天离线消息个数
    {
        didSet{
            Tool.setCache("offlineMsgCount",value:offlineMsgCount)
        }
    }
    private var _shareRange:String = ""
    var shareRange:String = ""//分享功能限制
    {
        didSet{
            Tool.setCache("shareRange",value:shareRange)
        }
    }
    
    var changeShopVerifyStatus:Int = 0
    
    private var _trystCarEnable:Bool = false
    var trystCarEnable:Bool = false//是否展示约车信息，0为未开通，1为开通
    {
        didSet{
            let trystCarEnableNumber  =  NSNumber.init(value: trystCarEnable)
            Tool.setCache("trystCarEnable",value:trystCarEnableNumber)
        }
    }
    
    private var isSign:Bool = false
    var isSignIn:Bool = false//当天是否签到
    {
        didSet{
            let _isSignIn  =  NSNumber.init(value: isSignIn)
            Tool.setCache("isSignIn",value:_isSignIn)
        }
    }
    //是否让确客看到   1:看到 0:看不到
    var confirmShowTrack:Bool = false
    //客户来源开关  0为不需填写，1为必须填写
    var  customerSource:String = ""
    
    private var  _maxRecommendCount:String = ""
    var  maxRecommendCount:String = ""//最大报备数
    {
        didSet{
            Tool.setCache("maxRecommendCount",value:maxRecommendCount)
        }
    }
    //获取当前城市的客服电话
    var customerServiceTel:String = ""
    //经纪人收货地址id，如果id为0此经纪人未添加收货地址
    var addressId:String = ""

    var hxUserName:String = ""//环信登录账号
    var hxNickName:String = ""//环信昵称
    var hxPassword:String = ""//环信登录密码
    
    func mapping(mapper: HelpingMapper)
    {
        // 指定 userId 字段用 "id" 去解析
//        mapper.specify(property: &userId, name: "id")
//        mapper.specify(property: &userName, name: "nickname")
//        mapper.specify(property: &avatar, name: "headPic")
        
        mapper.specify(property: &storeId, name: "org.id")
        mapper.specify(property: &storeNumber, name: "org.uniquecode")
        mapper.specify(property: &storeName, name: "org.name")
        
        mapper.specify(property: &areaId, name: "org.areaId")
        mapper.specify(property: &areaName, name: "org.areaName")
        
        mapper.specify(property: &orgnizationName, name: "org.additional.orgnization.name")
        mapper.specify(property: &_mobileVisable, name: "org.additional.mobileVisable")
        
        mapper.specify(property: &_points, name: "additional.points")
        mapper.specify(property: &isSign, name: "additional.sign.isSign")
        mapper.specify(property: &changeShopVerifyStatus, name: "additional.isChangeShopApplication")
        mapper.specify(property: &confirmShowTrack, name: "additional.confirmShowTrack")
        mapper.specify(property: &customerSource, name: "additional.customerSource")
        
        mapper.specify(property: &_trystCarEnable, name: "additional.trystCarEnable")
        mapper.specify(property: &_shareRange, name: "additional.shareRange")
        
        mapper.specify(property: &customerServiceTel, name: "additional.customerServiceTel.tel")
        mapper.specify(property: &addressId, name: "additional.addressId")
        mapper.specify(property: &_maxRecommendCount, name: "additional.maxRecommendCount")

        mapper.specify(property: &hxUserName, name: "easemobUsers.username")
        mapper.specify(property: &hxNickName, name: "easemobUsers.password")
        mapper.specify(property: &hxPassword, name: "easemobUsers.nickname")
    }
}
