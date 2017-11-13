//
//  EncodingView.m
//  MoShouBroker
//
//  Created by strongcoder on 15/10/22.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "EncodingView.h"
#import "ZXMultiFormatReader.h"
#import "ZXMultiFormatWriter.h"
#import "ZXingObjC.h"
#import "ZXQRCodeErrorCorrectionLevel.h"

@interface EncodingView ()

@property (nonatomic,copy)NSString *encodString;
@property (nonatomic,copy)NSString *customerName;
@property (nonatomic,copy)NSString *phone;

@end

@implementation EncodingView

-(id)initWithEncodingString:(NSString *)string withCustomerName:(NSString*)custName withPhone:(NSString*)phone;
{
    
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    if (self)
    {
        self.encodString = string;
        self.customerName = custName;
        self.phone = phone;
        [self loadUI];
        
    }
      return self;
    
}

-(void)loadUI
{
    self.backgroundColor = [UIColor clearColor];
//    self.alpha = 0.2;
    UIView *theBgView = [[UIView alloc] initWithFrame:self.frame];
    theBgView.backgroundColor = [UIColor blackColor];
    theBgView.alpha = 0.2;
    [self addSubview:theBgView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(125.0/750*self.width, 417.0/1330*self.height, 500.0/750*self.width, 564.0/750*self.width)];
    bgView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];
    
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    
    
    ZXEncodeHints* hints = [ZXEncodeHints hints];
    hints.margin = [NSNumber numberWithInt:0];//控制白色边框的大小 add by wangzz 20160125
    hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelL];//容错性设成最低，二维码里添加图片
    hints.encoding =  NSUTF8StringEncoding;// 加上这两句，可以用中文了
    
    
//    ZXBitMatrix* result = [writer encode:self.encodString
//                                  format:kBarcodeFormatQRCode
//                                   width:1000
//                                  height:1000
//                                   error:&error];
    ZXBitMatrix* result = [writer encode:self.encodString format:kBarcodeFormatQRCode width:500 height:500 hints:hints error:&error];
    
    
    
    if (result) {
        
        //         CGImageRef image = [[ZXImage imageWithMatrix:result onColor:[UIColor redColor].CGColor offColor:[UIColor yellowColor].CGColor] cgimage];
        //
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        UIImage *codeImage = [UIImage imageWithCGImage:image];
        //想给中间加图片  就用这个logoiamge加进去
//        UIImage *logoImage = [UIImage imageNamed:@"icon.jpg"];
        
        //        UIImage *hechengiamge = [self addImage:codeImage toImage:logoImage];
        
//        UIImage *hechengiamge = [self addSubImage:codeImage sub:logoImage];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20.0/564*bgView.height, bgView.width, 60.0/564*bgView.height)];
        titleLabel.text = @"带看二维码";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = FONT(17.0);
        titleLabel.textColor = NAVIGATIONTITLE;
        titleLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:titleLabel];
        
        UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+titleLabel.top-0.5, bgView.width, 0.5)];
        lineL.backgroundColor = LINECOLOR;
        [bgView addSubview:lineL];
        
        
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(90.0/500*bgView.width, lineL.bottom+30.0/564*bgView.height, 320.0/500*bgView.width, 320.0/500*bgView.width)];
        
        [view setImage:codeImage];
        [bgView addSubview:view];
        
        UILabel *customerL = [[UILabel alloc] initWithFrame:CGRectMake(0, view.bottom+40.0/564*bgView.height, bgView.width, 40.0/564*bgView.height)];
        BOOL hasChinese = NO;
        for (int i = 0; i < [self.customerName length]; i++) {
            int a = [self.customerName characterAtIndex:i];
            if(a > 0x4e00 && a < 0x9fff){
                NSLog(@"汉字");
                hasChinese = YES;
                break;
            }
        }
        NSString *custStr = nil;
        if (hasChinese) {
            if (self.customerName.length <= 3) {
                custStr = [NSString stringWithFormat:@"%@ (%@) 报备有效",self.customerName,self.phone];
            }else
            {
                custStr = [NSString stringWithFormat:@"%@... (%@) 报备有效",[self.customerName substringToIndex:3],self.phone];
            }
        }else
        {
            if (self.customerName.length <= 6) {
                custStr = [NSString stringWithFormat:@"%@ (%@) 报备有效",self.customerName,self.phone];
            }else
            {
                custStr = [NSString stringWithFormat:@"%@... (%@) 报备有效",[self.customerName substringToIndex:6],self.phone];
            }
        }
        customerL.text = custStr;
        customerL.textColor = NAVIGATIONTITLE;
        customerL.textAlignment = NSTextAlignmentCenter;
        customerL.font = FONT(12.5);
        customerL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:customerL];
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    } else {
        NSString *errorMessage = [error localizedDescription];
        
        AlertShow(errorMessage);
        
    }


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMissAction)];
    
    [self addGestureRecognizer:tap];
    
}

-(UIImage *)addSubImage:(UIImage *)img sub:(UIImage *) subImage
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    int subWidth = subImage.size.width;
    int subHeight = subImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextDrawImage(context, CGRectMake( (w-subWidth)/2, (h - subHeight)/2, subWidth, subHeight), [subImage CGImage]);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
    //  CGContextDrawImage(contextRef, CGRectMake(100, 50, 200, 80), [smallImg CGImage]);
}

-(void)disMissAction
{

    
    [self removeFromSuperview];


}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
