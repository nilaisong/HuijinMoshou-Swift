/**
 * Copyright (c) 2009 Alex Fajkowski, Apparent Logic LLC
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

//Documet目录

#define SELECTEDTHEME selectedTheme()

#import <UIKit/UIKit.h>

/**
 * Convenience methods to help with resizing images retrieved from the 
 * ObjectiveFlickr library.
 */
@interface UIImage (Extras)

- (UIImage *)rescaleImageToSize:(CGSize)size;
- (UIImage *)cropImageToRect:(CGRect)cropRect;
- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox;
- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize;

+ (UIImage *)hContactTwoImages:(UIImage *)firstImg secondImage:(UIImage*)secondImage; //水平方向拼接图片
+ (UIImage *)vContactTwoImages:(UIImage *)firstImg secondImage:(UIImage*)secondImage; //垂直方向拼接图片

+ (UIImage *)combineTowImages:(UIImage *)firstImage secondImage:(UIImage *)secondImage; //合并图片

+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect; //裁剪部分图片
+ (UIImage*)imageFromImage:(UIImage*)image newSize:(CGSize)newSize;

+ (UIImage*)imageFromImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;
+ (UIImage*)imageFromImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
//2012-06-20
+ (UIImage*)captureView:(UIView*)view;
+ (void)saveScreenshotToPhotosAlbumForView:(UIView*)view;
+ (UIImage *)addImageReflection:(CGFloat)reflectionFraction Obaque:(float)obaque ForImage:(UIImage*)originImage;
//应用换肤的时候需要用到的方法,added 2012-06-20
+ (UIImage *)imageOfName:(NSString*)name;
//ljs 画线的方法
+ (UIImage *) lineImageWithSize:(CGSize)imageSize
                       andColor:(UIColor *)lineColor
                    andLineWith:(CGFloat)lineWith;
//ljs 画圆的方法
+ (UIImage *) drawRoundImageWithSize:(CGSize)imageSize
                           andColor:(UIColor *)roundColor;

@end

NSString* selectedTheme();
NSString* pathOfTheme();