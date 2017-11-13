//
//  MSTabBar.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MSTabBar.h"
#import "MSTabBarItemModel.h"
#import "MSTabBarItemButton.h"

@interface MSTabBar()
{
    MSTabBarItemButton* _selectedButton;
}

//背景图片
//@property (nonatomic,weak)UIImageView* backImageView;

@property (nonatomic,weak)UIView* lineView;

@end

@implementation MSTabBar


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    }
    return self;
}

-(void)setTabBarIetmsArray:(NSArray *)tabBarIetmsArray{
    _tabBarIetmsArray = tabBarIetmsArray;
    CGFloat itemW = self.frame.size.width / _tabBarIetmsArray.count;
    CGFloat itemH = self.frame.size.height;
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    
//    self.backImageView.frame = CGRectMake(0, -15, [UIScreen mainScreen].bounds.size.width, 63);
    
    for (int i = 0; i < tabBarIetmsArray.count; i++) {
        MSTabBarItemButton* button = nil;
        
        MSTabBarItemModel* itemModel = tabBarIetmsArray[i];
        
        UIImage* normalImage = [UIImage imageNamed:itemModel.normalImageName];
        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage* selectedImage = [UIImage imageNamed:itemModel.selectedImageName];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
//        if (i == 2) {
//            itemH = itemW = 42;
//            
//            button = (MSTabBarItemButton*)[[UIButton alloc]init];
//            [button setBackgroundImage:normalImage forState:UIControlStateNormal];
//            [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
//            [button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
//            button.frame = CGRectMake(0, 0, 42, 42);
//            button.center = CGPointMake(self.center.x, self.center.y - 15 + (self.frame.size.height - 42)/2);
//        }else{
            itemW = self.frame.size.width / _tabBarIetmsArray.count;
            itemH = self.frame.size.height;
            button = [[MSTabBarItemButton alloc]init];
            itemX = itemW * i;
            button.frame = CGRectMake(itemX, itemY, itemW, itemH);
            [button setImage:normalImage forState:UIControlStateNormal];
            [button setImage:selectedImage forState:UIControlStateSelected];
            [button setTitle:itemModel.title forState:UIControlStateNormal];
//        }
        

        button.tag = i;
        [button setTitleColor:[UIColor colorWithRed:0.68f green:0.68f blue:0.68f alpha:1.00f] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.11f green:0.62f blue:0.92f alpha:1.00f] forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
            _selectedButton = button;
        }
        [button addTarget:self action:@selector(btnClick:forEvent:) forControlEvents:UIControlEventTouchUpInside];
       
        
        [self addSubview:button];
    }
    
    
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    CGFloat tabX = 0;
    CGFloat tabH = 49;
    CGFloat tabY = [UIScreen mainScreen].bounds.size.height - tabH;
    CGFloat tabW = [UIScreen mainScreen].bounds.size.width;
   
    self.frame = CGRectMake(tabX, tabY, tabW, tabH);
    
    [self lineView];
}

-(void)btnClick:(MSTabBarItemButton*)btn forEvent:(UIEvent *)enent{
    
    UITouch *touch = [[enent allTouches] anyObject];
    if (touch.tapCount== 2) {
//    双击事件
    }
    
    if ([_delegate respondsToSelector:@selector(didSelectedItem:atIndex:WithTouchNum:)]) {
        [_delegate didSelectedItem:btn atIndex:btn.tag WithTouchNum:touch.tapCount];
    }
    
       if (btn.tag == 2)return;
    
    if (!_selectedButton) {
        _selectedButton = btn;
    }
    _selectedButton.selected = NO;
    btn.selected = NO;
    _selectedButton = btn;
    _selectedButton.selected = YES;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView* lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
        lineV.backgroundColor = [UIColor colorWithHexString:@"d9d9db"];
        [self addSubview:lineV];
        _lineView = lineV;
    }
    return _lineView;
}

//背景图片
//-(UIImageView *)backImageView{
//    if (!_backImageView) {
//        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"椭圆-8"]];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        [self addSubview:imageView];
//        _backImageView = imageView;
//    }
//    return _backImageView;
//}

- (void)setSelectedIndex:(NSInteger)index{
    for (MSTabBarItemButton* button in self.subviews) {
        if (button.tag == index && [button isKindOfClass:[MSTabBarItemButton class]]) {
            [self btnClick:button forEvent:nil];
        }
    }
}
@end
