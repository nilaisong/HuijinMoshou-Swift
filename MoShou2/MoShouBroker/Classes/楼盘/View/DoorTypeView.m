//
//  DoorTypeView.m
//  MoShouBroker
//
//  Created by strongcoder on 15/7/16.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "DoorTypeView.h"
#import "MyImageView.h"
@implementation DoorTypeView

-(id)initWithRoomlayout:(RoomLayout *)roomLauout;

{
    CGFloat doorTypeViewWith = (kMainScreenWidth-40)/3;

    self = [super initWithFrame:CGRectMake(0, 0, doorTypeViewWith, 200)];
    if (self)
    {
        self.roomLayoutMo = roomLauout;

        MyImageView *doorImageView = [[MyImageView alloc]initWithFrame:CGRectMake(0, 0, doorTypeViewWith, doorTypeViewWith)];
//        doorImageView.layer.cornerRadius = 3.f;
//        doorImageView.layer.masksToBounds = YES;
        [doorImageView setImageWithUrlString:self.roomLayoutMo.imgUrl placeholderImage:[UIImage imageNamed:@"首页-资讯默认图.png"]];
        doorImageView.contentMode = UIViewContentModeScaleAspectFill;
        doorImageView.clipsToBounds = YES;
        doorImageView.layer.borderColor = UIColorFromRGB(0xefeff4).CGColor;
        doorImageView.layer.borderWidth = 1.f;
        
        DLog(@"self.roomLayoutMo.thumUrl===%@",self.roomLayoutMo.thumUrl);
        DLog(@"self.roomLayoutMo.imgUrl===%@",self.roomLayoutMo.thumUrl);

        [self addSubview:doorImageView];

        
        for (int i = 0; i < 3; i ++)
        {
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15+doorImageView.bottom+i*(18), doorImageView.width, 15)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = FONT(12);
            
            switch (i) {
                case 0:
                {
                    label.text =[NSString stringWithFormat:@"%@  %@",self.roomLayoutMo.name,self.roomLayoutMo.type];
                    label.textColor = UIColorFromRGB(0x717171);
                }
                    break;
                    case 1:
                {
                    NSString *houseTypeString = [NSString stringWithFormat:@"%@室%@厅%@卫%@",self.roomLayoutMo.bedroomNum,self.roomLayoutMo.livingroomNum,self.roomLayoutMo.toiletNum,self.roomLayoutMo.saleArea];

                    label.text = houseTypeString;
                    label.textColor = UIColorFromRGB(0x717171);
                }
                    break;
                    case 2:
                {
                    label.text = [NSString stringWithFormat:@"%@",self.roomLayoutMo.totalPrice];
                    label.textColor =ORIGCOLOR;
                    label.font = [UIFont boldSystemFontOfSize:13.f];
                    label.tag = 4000;
                }
                    break;
                default:
                    break;
            }
            
            [self addSubview:label];
        }
        
        UILabel *lastLabel = (UILabel *)[self viewWithTag:4000];
        
        self.height =lastLabel.bottom;
        
             self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doorViewAction)];
        
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}


-(id)initHorizontalStyleWithRoomlayout:(RoomLayout *)roomLauout;

{
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 87.5)];
    if (self)
    {
        self.roomLayoutMo = roomLauout;
        //        self.layer.cornerRadius = 5;
        //        [self.layer setBorderColor:UIColorFromRGB(0xfdd5d6).CGColor];
        //        [self.layer setBorderWidth:0.5f];
        //        self.layer.masksToBounds = YES;
        //
        //
        //        UIView *redBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kFrame_Width(self), 25)];
        //        redBgView.backgroundColor = UIColorFromRGB(0xfdd5d6);
        //        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:redBgView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5.f, 5.f)];
        //        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //        maskLayer.frame =  redBgView.bounds;
        //        maskLayer.path = maskPath.CGPath;
        //        redBgView.layer.mask = maskLayer;
        //        [self addSubview:redBgView];
        //
        //
        //        UILabel *titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(14, 5, self.frame.size.width-14, 20)];
        //        titleLabel.text = self.roomLayoutMo.name;
        //        titleLabel.font = [UIFont systemFontOfSize:15.f];
        //        titleLabel.textColor = UIColorFromRGB(0xf75857);
        //        titleLabel.textAlignment = NSTextAlignmentLeft;
        //        [redBgView addSubview:titleLabel];
        //
        //        UILabel *doorTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, kFrame_YHeight(redBgView), kFrame_Width(self)/2-14, 35)];
        //        doorTypeLabel.text =[NSString stringWithFormat:@"户型: %@",self.roomLayoutMo.type];
        //        doorTypeLabel.textAlignment = NSTextAlignmentLeft;
        //        doorTypeLabel.textColor = UIColorFromRGB(0x717171);
        //        doorTypeLabel.font = [UIFont systemFontOfSize:12.f];
        //        [self addSubview:doorTypeLabel];
        //
        //        UILabel *salesAreaLabel = [[UILabel alloc]initWithFrame:CGRectMake(kFrame_Width(self)/2, kFrame_YHeight(redBgView), kFrame_Width(self)/2-14-30, 35)];
        //        salesAreaLabel.font = [UIFont systemFontOfSize:12.f];
        //        salesAreaLabel.textAlignment = NSTextAlignmentLeft;
        //        salesAreaLabel.textColor = UIColorFromRGB(0x717171);
        //        salesAreaLabel.text = [NSString stringWithFormat:@"销售面积: %@",self.roomLayoutMo.saleArea];
        //        [self addSubview:salesAreaLabel];
        //
        ////        icon-jiantou-2   16*28   8*14
        //
        //
        //        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kFrame_Width(self)-8-9, kFrame_YHeight(redBgView)+((35-14)/2), 8, 14)];
        //        arrowImageView.image = [UIImage imageNamed:@"icon-jiantou-2"];
        //
        //        [self addSubview:arrowImageView];
        //
        
        MyImageView *doorImageView = [[MyImageView alloc]initWithFrame:CGRectMake(14, 10, 90, 135/2)];
        doorImageView.layer.cornerRadius = 3.f;
        doorImageView.layer.masksToBounds = YES;
        [doorImageView setImageWithUrlString:self.roomLayoutMo.thumUrl placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
        [self addSubview:doorImageView];
        
        
        for (int i = 0; i < 3; i ++)
        {
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kFrame_XWidth(doorImageView)+20, 10+i*(135/2/3), kMainScreenWidth-14-20-kFrame_Width(doorImageView), 135/2/3)];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = FONT(14);
            
            switch (i) {
                case 0:
                {
                    label.text = self.roomLayoutMo.name;
                    label.textColor = UIColorFromRGB(0x717171);
                }
                    break;
                case 1:
                {
                    label.text = self.roomLayoutMo.type;
                    label.textColor = UIColorFromRGB(0x717171);
                }
                    break;
                case 2:
                {
                    label.text = [NSString stringWithFormat:@"销售面积: %@",self.roomLayoutMo.saleArea];
                    label.textColor = UIColorFromRGB(0x717171);
                }
                    break;
                default:
                    break;
            }
            [self addSubview:label];
            
        }
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 87, kMainScreenWidth-28, 0.5)];
        lineLabel.backgroundColor =kRGB(208, 208, 211);
        
        [self addSubview:lineLabel];
        
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doorViewAction)];
        
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}











-(void)doorViewAction
{

    if ([self.delegate respondsToSelector:@selector(doorTypeViewTapACtion:)])
    {
        [self.delegate doorTypeViewTapACtion:self];
    }
    
}



@end
