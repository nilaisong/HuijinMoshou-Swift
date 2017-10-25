//
//  XTSearchTextField.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/25.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTSearchTextField.h"
#import "NSString+Extension.h"
@implementation XTSearchTextField

#if 1

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView* leftView = [[UIView alloc]init];
        leftView.frame = CGRectMake(0, 0, 28, 29);
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search-icon"]];
        imageView.frame = CGRectMake(10, (leftView.frame.size.height - 13) / 2, 13, 13);
        [leftView addSubview:imageView];
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8;
        
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        self.placeholder = self.placeHolderString;
        [self setValue:[UIColor colorWithRed:0.85f green:0.85f blue:0.86f alpha:1.00f] forKeyPath:@"_placeholderLabel.textColor"];
        [self setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        
        self.returnKeyType = UIReturnKeySearch;
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.font = [UIFont systemFontOfSize:15];
        
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
}

- (NSString *)placeHolderString{
    if (!_placeHolderString || _placeHolderString.length <= 0) {
        _placeHolderString = @"请输入楼盘名称/客户名/手机号搜索";
    }
    return _placeHolderString;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    return CGRectMake(28, 0, bounds.size.width, bounds.size.height);
}
#endif
@end
