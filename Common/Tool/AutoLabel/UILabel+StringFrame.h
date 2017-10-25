//
//  UILabel+StringFrame.h
//  MoShouBroker
//
//  Created by strongcoder on 15/7/20.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (StringFrame)

@property(nonatomic,assign)CGSize size;

- (CGSize)boundingRectWithSize:(CGSize)size;
/**
 *  自动换行字体默认为14
 *
 *  @param frame
 */
-(void)autoLayoutWithFrame:(CGRect)frame;
/**
 *  自动换行根据自己的需求添加字号 (文字居中在自己设置的frame)
 *
 *  @param frame 折行的页面frame
 *  @param size  折行的字体
 */
-(void)autoLayoutWithFrame:(CGRect)frame andFontSize:(float)size;
/**
 *  自动换行根据自己的需求添加字号 (文字从自己设置的坐标处开始)
 *
 *  @param frame 折行的页面frame
 *  @param size  折行的字体
 */
-(void)autoWithFrame:(CGRect)frame andFontSize:(float)size;

-(void)notAutoLayoutWithFrame:(CGRect)frame andFontSize:(float)size;
-(id)initWithPoint:(CGPoint)point andText:(NSString *)text andFontSize:(CGFloat)size;



#pragma mark - For UILabel



/**
 文本 对齐 字体

 @param frame <#frame description#>
 @param text <#text description#>
 @param textAlignment <#textAlignment description#>
 @param fontSize <#fontSize description#>
 @return <#return value description#>
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                    textAlignment:(NSTextAlignment)textAlignment
                         fontSize:(CGFloat)fontSize;



/**
 文本 对齐 字体 字体颜色

 @param frame <#frame description#>
 @param text <#text description#>
 @param textAlignment <#textAlignment description#>
 @param fontSize <#fontSize description#>
 @param textColor <#textColor description#>
 @return <#return value description#>
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                    textAlignment:(NSTextAlignment)textAlignment
                         fontSize:(CGFloat)fontSize
                        textColor:(UIColor *)textColor;


/**
 文本 对齐 字体 字体颜色 背景颜色

 @param frame <#frame description#>
 @param text <#text description#>
 @param textAlignment <#textAlignment description#>
 @param fontSize <#fontSize description#>
 @param textColor <#textColor description#>
 @param bgColor <#bgColor description#>
 @return <#return value description#>
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                    textAlignment:(NSTextAlignment)textAlignment
                         fontSize:(CGFloat)fontSize
                        textColor:(UIColor *)textColor
                          bgColor:(UIColor *)bgColor;



/**
 文本 对齐 字体 字体颜色 圆角

 @param frame <#frame description#>
 @param text <#text description#>
 @param textAlignment <#textAlignment description#>
 @param fontSize <#fontSize description#>
 @param textColor <#textColor description#>
 @param bgColor <#bgColor description#>
 @param cornerRadius <#cornerRadius description#>
 @return <#return value description#>
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                    textAlignment:(NSTextAlignment)textAlignment
                         fontSize:(CGFloat)fontSize
                        textColor:(UIColor *)textColor
                          bgColor:(UIColor *)bgColor
                     cornerRadius:(CGFloat)cornerRadius;




/**
 删除线label

 @param frame <#frame description#>
 @param text <#text description#>
 @param textAlignment <#textAlignment description#>
 @param fontSize <#fontSize description#>
 @return <#return value description#>
 */
+ (UILabel *)createDeleteLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                    textAlignment:(NSTextAlignment)textAlignment
                        textColor:(UIColor *)textColor
                         fontSize:(CGFloat)fontSize;




@end
