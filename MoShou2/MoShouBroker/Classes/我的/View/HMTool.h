//
//  HMTool.h
//  MoShouQueke
//
//  Created by Aminly on 15/10/30.
//  Copyright © 2015年  5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMTool : NSObject
+(id)creareLineWithFrame:(CGRect)frame andColor:(UIColor*)color;
+(UILabel *)setDetailLabelWithText:(NSString *)text andFontSize:(float)fontSize cellHeight:(float)height;
+(UITableViewCell *)getArrowCellWithFrame:(CGRect)fram;
+(CGSize )getTextSizeWithText:(NSString *)text andFontSize:(float)size;
+(UIView *)getLineWithFrame:(CGRect)frame andColor:(UIColor*)color;
+(NSString *)removeSpaceStringWithString:(NSString *)string;
+(UIButton *)createBtnWithFrame:(CGRect)frame andNormalImage:(UIImage *)normalImage andSelectedImage:(UIImage*)selectedImage;
//+(UIButton *)createBtnWithFrame:(CGRect)frame andNormalColor:(UIColor *)normalColor andSelectedColor:(UIColor*)selectedColor;
@end
