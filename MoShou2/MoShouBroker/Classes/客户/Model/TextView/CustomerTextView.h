//
//  CustomerTextView.h
//  MoShouBroker
//
//  Created by wangzz on 15/10/20.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerTextView : UITextView
/**
 *  The text to be displayed when the text view is empty. The default value is `nil`.
 */
@property (copy, nonatomic) NSString *placeHolder;

/**
 *  The color of the place holder text. The default value is `[UIColor lightGrayColor]`.
 */
@property (strong, nonatomic) UIColor *placeHolderTextColor;
@end
