//
//  XTQrCodeView.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/30.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTQrCodeView.h"

@interface XTQrCodeView()

@property (nonatomic,weak)UIImageView* imageView;

@property (nonatomic,weak)UIImageView* iconImageView;

@end

@implementation XTQrCodeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self imageView];

    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    self.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.20f];
    _imageView.image = [self generateQRCode:self.code width:[UIScreen mainScreen].bounds.size.width height:[UIScreen mainScreen].bounds.size.width];
}

- (void)layoutSubviews{
    _imageView.center  = self.center;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.7, [UIScreen mainScreen].bounds.size.width * 0.7);
        imageView.center = self.center;
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(0, 0, kMainScreenWidth * 0.2, kMainScreenWidth * 0.2);
        imageView.center = _imageView.center;
        _iconImageView = imageView;
    }
    return _iconImageView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}


- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    // 生成二维码图片
    CIImage *qrcodeImage;
    NSData *data = [_code dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}
@end
