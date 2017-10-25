//
//  UIImageHelper.m
//  CocoaHelpers
//
//  Created by Shaun Harrison on 12/19/08.
//  Copyright 2008 enormego. All rights reserved.
//

#import "UIImageHelper.h"
#import <CoreGraphics/CoreGraphics.h>


@implementation UIImage (Helper)

+ (UIImage*)imageWithContentsOfURL:(NSURL*)url {
	NSError* error;
	NSData* data = [NSData dataWithContentsOfURL:url options:0 error:&error];
	if(error || !data) {
		return nil;
	} else {
		return [UIImage imageWithData:data];
	}
}

- (UIImage*)scaleToSize:(CGSize)size1 {
	CGSize size;
	if (self.size.width<self.size.height) {
		size = CGSizeMake(self.size.width, self.size.width);
	} else {
		size = CGSizeMake(self.size.height, self.size.height);
	}
	
	UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0, self.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
//	CGContextAddRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
//	CGContextClip(context);
	
	CGRect rect;
	if (self.size.width<self.size.height) {
		float height = (size.width*self.size.height)/self.size.width;
		rect = CGRectMake(0, 0, size.width, height);
	} else {
		float width = (size.height*self.size.width)/self.size.height;
		rect = CGRectMake((self.size.height-self.size.width)/2.0f, 0, width, size.height);
	}
	CGContextDrawImage(context, rect, self.CGImage);
	
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

- (UIImage *)scaleFacebookHead
{
	CGSize size;
	if (self.size.width<self.size.height) {
		size = CGSizeMake(self.size.width, self.size.width);
	} else {
		size = CGSizeMake(self.size.height, self.size.height);
	}
	
	UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0f, self.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	//	CGContextAddRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
	//	CGContextClip(context);
	
	CGRect rect;
	if (self.size.width<self.size.height) {
		float height = (size.width*self.size.height)/self.size.width;
		rect = CGRectMake(0, 0, size.width, height);
	} else {
		float width = (size.height*self.size.width)/self.size.height;
		rect = CGRectMake((self.size.height-self.size.width)/2.0f, 0, width, size.height);
	}
	CGContextDrawImage(context, rect, self.CGImage);
	
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

- (UIImage*)scaleAndCropToSize:(CGSize)size {
	if(size.height > size.width) {
		if(self.size.height > self.size.width) {
			if((self.size.width  / self.size.height) >= (size.width / size.height)) {
				return [self scaleHeightAndCropWidthToSize:size];
			} else {
				return [self scaleWidthAndCropHeightToSize:size];
			}
		} else {
			return [self scaleHeightAndCropWidthToSize:size];
		}    
	} else {
		if(self.size.width > self.size.height) {
			if((self.size.height / self.size.width) >= (size.height / size.width)) {
				return [self scaleWidthAndCropHeightToSize:size];
			} else {
				return [self scaleHeightAndCropWidthToSize:size];
			}
		} else {
			return [self scaleWidthAndCropHeightToSize:size];
		}    
	}
}

- (UIImage*)scaleHeightAndCropWidthToSize:(CGSize)size {
	float newWidth = (self.size.width * size.height) / self.size.height;
	return [self scaleToSize:size withOffset:CGPointMake((newWidth - size.width) / 2, 0.0f)];
}

- (UIImage*)scaleWidthAndCropHeightToSize:(CGSize)size {
	float newHeight = (self.size.height * size.width) / self.size.width;
	return [self scaleToSize:size withOffset:CGPointMake(0, (newHeight - size.height) / 2)];
}

- (UIImage*)scaleToSize:(CGSize)size withOffset:(CGPoint)offset {
	UIImage* scaledImage = [self scaleToSize:CGSizeMake(size.width + (offset.x * -2), size.height + (offset.y * -2))];
	
	UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGRect croppedRect;
	croppedRect.size = size;
	croppedRect.origin = CGPointZero;
	
	CGContextClipToRect(context, croppedRect);
	
	CGRect drawRect;
	drawRect.origin = offset;
	drawRect.size = scaledImage.size;
	
	CGContextDrawImage(context, drawRect, scaledImage.CGImage);
	
	
	UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return croppedImage;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)size
{
	UIImage *sourceImage = self;
	UIImage *newImage = nil;        
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = size.width;
	CGFloat targetHeight = size.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, size) == NO) 
	{
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor > heightFactor) 
			scaleFactor = widthFactor; // scale to fit height
        else
			scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
        if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
		}
        else 
			if (widthFactor < heightFactor)
			{
				thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
	}       
	
	UIGraphicsBeginImageContext(size); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil) 
        //NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}


@end