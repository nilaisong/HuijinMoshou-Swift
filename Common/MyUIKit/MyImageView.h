//
//  MyImageView.h
//  异步下载并显示缩略图
//
//  Created by Laison on 12-4-12.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

@interface MyImageView : UIImageView
{
    
}

//保存到默认路径
-(void)setImageWithUrlString:(NSString *)url;
-(void)setImageWithUrlString:(NSString *)url placeholderImage:(UIImage *)placeholder;

-(void)addShadow;
-(void)addRoundCornerWithBoderColor:(UIColor*)borderColor andContentModel:(NSString*)contentModel;
- (void)addRoundCorner;

@end

