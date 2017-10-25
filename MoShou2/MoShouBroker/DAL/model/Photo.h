//
//  Photo.h
//  MoShou2
//
//  Created by strongcoder on 16/5/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject


@property(nonatomic,copy) NSString* albumId;//
@property(nonatomic,copy) NSString* estateId;//
@property(nonatomic,copy) NSString* name;//
@property(nonatomic,copy) NSString* type;//
@property(nonatomic,copy) NSString* creator;//
@property(nonatomic,copy) NSString* createTime;//
@property(nonatomic,copy) NSString* updater;//
@property(nonatomic,copy) NSString* updateTime;//
@property(nonatomic,copy) NSString* delFlag;//
@property(nonatomic,copy) NSString* photoName;//


@property(nonatomic,copy) NSString* thmUrl;//缩略图
@property(nonatomic,copy) NSString* imgUrl;//大图




@end



//"id" : 90,
//"estateId" : 21,
//"name" : "效果图",
//"url" : "test/2016/03/02/16/56d6aa75b864b.jpeg",
//"type" : "1",
//"creator" : 1,
//"createTime" : "2016-03-02 16:55:26",
//"updater" : 1,
//"updateTime" : "2016-03-05 11:51:41",
//"delFlag" : "0",
//"photoName" : "效果图"
