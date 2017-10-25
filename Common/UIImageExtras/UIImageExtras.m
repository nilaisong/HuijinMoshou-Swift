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

#import <objc/runtime.h>
//#import "SuperView.h"
#import "UIImageExtras.h"
#import "Functions.h"
#define GLKMathDegreesToRadians(degrees) degrees * (M_PI / 180)

NSString* selectedTheme()
{
    NSString* themePath;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* theme = [userDefaults objectForKey:@"currentTheme"];
    if (theme) 
    {
        themePath = [theme objectForKey:@"themePath"];
    }
    else {
        themePath = [NSBundle mainBundle].resourcePath;
    }
    return themePath;
}


@implementation UIImage (OpenFlowExtras)

- (UIImage *)rescaleImageToSize:(CGSize)size {
	CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
	UIGraphicsBeginImageContext(rect.size);
	[self drawInRect:rect];  // scales image to rect
	UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resImage;
}

- (UIImage *)cropImageToRect:(CGRect)cropRect {
	// Begin the drawing (again)
	UIGraphicsBeginImageContext(cropRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
	CGContextTranslateCTM(ctx, 0.0, cropRect.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	// Draw view into context
	CGRect drawRect = CGRectMake(-cropRect.origin.x, cropRect.origin.y - (self.size.height - cropRect.size.height) , self.size.width, self.size.height);
	CGContextDrawImage(ctx, drawRect, self.CGImage);
	
	// Create the new UIImage from the context
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the drawing
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox {
	// Make the shortest side be equivalent to the cropping box.
	CGFloat newHeight, newWidth;
	if (self.size.width < self.size.height) {
		newWidth = croppingBox.width;
		newHeight = (self.size.height / self.size.width) * croppingBox.width;
	} else {
		newHeight = croppingBox.height;
		newWidth = (self.size.width / self.size.height) *croppingBox.height;
	}
	
	return CGSizeMake(newWidth, newHeight);
}

- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize {
	UIImage *scaledImage = [self rescaleImageToSize:[self calculateNewSizeForCroppingBox:cropSize]];
	return [scaledImage cropImageToRect:CGRectMake((scaledImage.size.width-cropSize.width)/2, (scaledImage.size.height-cropSize.height)/2, cropSize.width, cropSize.height)];
}

//拼接图片
+ (UIImage *)hContactTwoImages:(UIImage *)firstImg secondImage:(UIImage*)secondImage
{
    CGSize contactSize = CGSizeMake(firstImg.size.width+secondImage.size.width, firstImg.size.height>secondImage.size.height?firstImg.size.height:secondImage.size.height); 
    CGSize secondImageSize = secondImage.size;
    //CGSizeMake(secondImage.size.width*(firstImg.size.height/secondImage.size.height), firstImg.size.height);
    UIGraphicsBeginImageContext(contactSize);
    [firstImg drawInRect:CGRectMake(0, 0, firstImg.size.width, firstImg.size.height)];
    [secondImage drawInRect:CGRectMake(firstImg.size.width, 0, secondImageSize.width, secondImageSize.height)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

+ (UIImage *)vContactTwoImages:(UIImage *)firstImg secondImage:(UIImage*)secondImage{
    CGSize contactSize = CGSizeMake(firstImg.size.width>secondImage.size.width?firstImg.size.width:secondImage.size.width,firstImg.size.height+secondImage.size.height); 
    CGSize secondImageSize = secondImage.size;
    //CGSizeMake(secondImage.size.width*(firstImg.size.height/secondImage.size.height), firstImg.size.height);
    UIGraphicsBeginImageContext(contactSize);
    [firstImg drawInRect:CGRectMake(0, 0, firstImg.size.width, firstImg.size.height)];
    [secondImage drawInRect:CGRectMake(0, firstImg.size.height, secondImageSize.width, secondImageSize.height)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

//合并图片
+ (UIImage *)combineTowImages:(UIImage *)firstImage secondImage:(UIImage *)secondImage
{
    UIGraphicsBeginImageContext(firstImage.size);
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    [secondImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}


//截取图片
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
	CGImageRef sourceImageRef = [image CGImage];
	CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
	UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
	return newImage;
}
//缩放图片
+ (UIImage*)imageFromImage:(UIImage*)image newSize:(CGSize)newSize;
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (UIImage*)imageFromImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize
{
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp ||sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, GLKMathDegreesToRadians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation ==UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, GLKMathDegreesToRadians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown){
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, GLKMathDegreesToRadians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth,targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

+ (UIImage*)imageFromImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp ||sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, GLKMathDegreesToRadians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation ==UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, GLKMathDegreesToRadians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown){
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, GLKMathDegreesToRadians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x,thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
} 
//
+ (UIImage*)captureView:(UIView*)view{	
    
	CGRect rect = view.frame;  
	
	UIGraphicsBeginImageContext(rect.size);  
	
	CGContextRef context = UIGraphicsGetCurrentContext();  
	
	[view.layer renderInContext:context];  
	
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();  
	
	UIGraphicsEndImageContext();  
	
	return img;
    
}

+ (void)saveScreenshotToPhotosAlbumForView:(UIView*)view{	
    
	UIImageWriteToSavedPhotosAlbum([UIImage captureView:view], nil, nil, nil);
}

+ (UIImage *)addImageReflection:(CGFloat)reflectionFraction Obaque:(float)obaque ForImage:(UIImage*)originImage{
    
	int reflectionHeight = originImage.size.height * reflectionFraction;
	
    // create a 2 bit CGImage containing a gradient that will be used for masking the 
    // main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
    // function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
	CGImageRef gradientMaskImage = NULL;
	
    // gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // create the bitmap context
    CGContextRef gradientBitmapContext = CGBitmapContextCreate(nil, 1, reflectionHeight,
                                                               8, 0, colorSpace, kCGImageAlphaNone);
    
    // define the start and end grayscale values (with the alpha, even though
    // our bitmap context doesn't support alpha the gradient requires it)
    CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
    
    // create the CGGradient and then release the gray color space
    CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGColorSpaceRelease(colorSpace);
    
    // create the start and end points for the gradient vector (straight down)
    CGPoint gradientStartPoint = CGPointMake(0, reflectionHeight);
    CGPoint gradientEndPoint = CGPointZero;
    
    // draw the gradient into the gray bitmap context
    CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
                                gradientEndPoint, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(grayScaleGradient);
	
	// add a black fill with 50% opacity
	CGContextSetGrayFillColor(gradientBitmapContext, 0.0, (1.0 - obaque));
	CGContextFillRect(gradientBitmapContext, CGRectMake(0, 0, 1, reflectionHeight));
    
    // convert the context into a CGImageRef and release the context
    gradientMaskImage = CGBitmapContextCreateImage(gradientBitmapContext);
    CGContextRelease(gradientBitmapContext);
	
    // create an image by masking the bitmap of the mainView content with the gradient view
    // then release the  pre-masked content bitmap and the gradient bitmap
    CGImageRef reflectionImage = CGImageCreateWithMask(originImage.CGImage, gradientMaskImage);
    CGImageRelease(gradientMaskImage);
	
	CGSize size = CGSizeMake(originImage.size.width * originImage.scale, (originImage.size.height + reflectionHeight) * originImage.scale);
	
	UIGraphicsBeginImageContext(size);
    [originImage drawInRect:CGRectMake(0., 0., originImage.size.width * originImage.scale, originImage.size.height * originImage.scale)];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawImage(context, CGRectMake(0., originImage.size.height * originImage.scale, originImage.size.width * originImage.scale, reflectionHeight * originImage.scale), reflectionImage);
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    CGImageRelease(reflectionImage);
	
	return [UIImage imageWithCGImage:result.CGImage scale:originImage.scale orientation:(UIImageOrientationUp)];
}
//
#pragma -mark Detailed Implementation

+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)directory{
    
    return [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",name,ext]];
}

+ (UIImage*) imageOfName1x:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)directory{
    
    NSString* path = [self pathForResource:name ofType:ext inDirectory:directory];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

+ (UIImage*) imageOfName2x:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)directory{
    
    NSString* path = [self pathForResource:[name stringByAppendingString:@"@2x"] ofType:ext inDirectory:directory];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
//    UIImage* scaledImage = [UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:image.imageOrientation];
//    return scaledImage;
    return image;
}

+ (UIImage *)imageOfName:(NSString*)name ofType:(NSString*)ext{
    UIImage* image=nil;

    if ([UIScreen mainScreen].scale == 2.0) {
        
        image = [self imageOfName2x:name ofType:ext inDirectory:SELECTEDTHEME];
        
        if (image == nil) {
            image = [self imageOfName1x:name ofType:ext inDirectory:SELECTEDTHEME];
        }
    }
    
    if ([UIScreen mainScreen].scale == 1.0) {
        
        image = [self imageOfName1x:name ofType:ext inDirectory:SELECTEDTHEME];
        
        if (image == nil) {
            image = [self imageOfName2x:name ofType:ext inDirectory:SELECTEDTHEME];
        }
    }
    
    if (image==nil) {
         image= [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@",name,ext]];
    }
    return image;
}

+ (UIImage *)imageOfName:(NSString*)name
{
    UIImage* image = nil;
    if (name.length>0) 
    {
        NSArray* array = [name componentsSeparatedByString:@"."];
        if (array.count==2) {
            NSString* iamgeName = [array objectAtIndex:0];

            NSString* imageExt = [array objectAtIndex:1];
            image = [UIImage imageOfName:iamgeName ofType:imageExt];
        }
        else{
            //NSLog(@"1.image name:%@",name);
            image = [UIImage imageOfName:name ofType:@"png"];
        }
    }


    return image;
}



#pragma DrawLine  ljs 

/*
 *  @author LJS
 *  @time   2014-02-21 10:36:52
 *  @method 画直线
 *
 *  @param imageSize 线的区域大小
 *  @param lineColor 线的颜色
 *  @param lineWith  线的宽度
 *
 *  @return 线的图片
 *  @example  [UIImage lineImageWithSize:CGSizeMake(100, 1) andColor:[UIColor redColor] andLineWith:1.0f]
 */
+ (UIImage *) lineImageWithSize:(CGSize)imageSize
                       andColor:(UIColor *)lineColor
                    andLineWith:(CGFloat)lineWith
{
    
    UIGraphicsBeginImageContext(imageSize);
    const CGFloat *colors = CGColorGetComponents(lineColor.CGColor);
    //设置背景颜色
    //    CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(),1,1,1,1);
    //	CGContextFillRect(UIGraphicsGetCurrentContext(), CGContextGetClipBoundingBox(UIGraphicsGetCurrentContext()));
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //边缘样式
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWith);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),colors[0], colors[1], colors[2], colors[3]);//颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    if (imageSize.width > imageSize.height) {//判断是横线还是竖线
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lineWith/2.0, imageSize.height/2.0);  //起点坐标
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), imageSize.width-lineWith/2.0, imageSize.height/2.0);   //终点坐标
    }else{
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), imageSize.width/2.0, lineWith/2.0);  //起点坐标
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), imageSize.width/2.0, imageSize.height-lineWith/2.0);   //终点坐标
    }
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    UIImage *line = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return line;
}

/*
 *  @author LJS
 *  @time   2014-02-24 10:41:03
 *  @method 画圆
 *
 *  @param imageSize  圆的大小
 *  @param roundColor 圆的颜色
 *
 *  @return 圆的图片
 */
+ (UIImage *) drawRoundImageWithSize:(CGSize)imageSize
                       andColor:(UIColor *)roundColor
{
    UIGraphicsBeginImageContext(imageSize);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), roundColor.CGColor);//填充颜色
    CGContextAddArc(UIGraphicsGetCurrentContext(), imageSize.width/2,imageSize.height/2 , MIN(imageSize.height, imageSize.width)/2, 0, 2 * M_PI, 0); //添加一个圆
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFill);//绘制填充
    UIImage *round = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return round;
}


@end