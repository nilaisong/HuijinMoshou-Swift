//
//  HMActionSheet.m
//  Enterprise
//
//  Created by Aminly on 15/10/15.
//  Copyright © 2015年 NiLaisong. All rights reserved.
//

#import "HMActionSheet.h"
//#import "MyLabelView.h"
#import "HMTool.h"
#import "UILabel+StringFrame.h"
@implementation HMActionSheet
-(id)initWithDelegate:(id)delegate{
    self = [super init];
    
    if (self)
    {
        self.delegate =delegate;
        [self initLayout];
        
    }

       return self;

}
-(id)initWithDelegate:(id)delegate andTitle:(NSString *)title andContent:(NSString *)content{
    self = [super init];
    
    if (self)
    {
        self.delegate =delegate;
        [self initLayoutWithTitle:title andContent:content];
        
    }
    
    return self;


}
-(void)initLayoutWithTitle:(NSString *)title andContent:(NSString *)content{
    self.hasContent = YES;
    self.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.bounds.size.height)];
    [self.maskView setBackgroundColor:[UIColor blackColor]];
    self.maskView.alpha = 0.2;
    self.maskView.userInteractionEnabled = YES;
    [self addSubview:self.maskView];
    
    UITapGestureRecognizer *masktap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
    masktap.delegate = self;
    masktap. cancelsTouchesInView = NO;
    [self.maskView addGestureRecognizer:masktap];
    self.actionSheetView = [[UIView alloc]initWithFrame:CGRectMake(10, kMainScreenHeight+(58*3+16), kMainScreenWidth-20, 58*3+16)];
    [self addSubview:self.actionSheetView];
    UIView *btnView = [[UIView alloc]init];
    [btnView setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1]];
    btnView.layer.cornerRadius = 11;
    btnView.layer.masksToBounds = YES;
    [self.actionSheetView addSubview:btnView];

    
    UILabel *titlelb =[[UILabel alloc]init];
    [titlelb setText:title];
    [titlelb setTextColor:[UIColor blackColor]];
    [titlelb setFont:[UIFont systemFontOfSize:17]];
    CGSize titeS =[HMTool getTextSizeWithText:titlelb.text andFontSize:17];
    [titlelb setFrame:CGRectMake(kFrame_Width(self.actionSheetView)/2-titeS.width/2, 27, titeS.width, titeS.height)];
    [btnView addSubview:titlelb];
    
    UILabel *contentLb =[[UILabel alloc]init];
    [contentLb setText:content];
    [contentLb setTextColor:TFPLEASEHOLDERCOLOR];
    [contentLb setFont:[UIFont systemFontOfSize:14]];

    [contentLb autoWithFrame:CGRectMake(16, kFrame_YHeight(titlelb)+16, kFrame_Width(self.actionSheetView)-32,124-kFrame_YHeight(titlelb)) andFontSize:14];
    [btnView addSubview:contentLb];
    
   
    [btnView setFrame:CGRectMake(0, 0, kMainScreenWidth-20,58+kFrame_Height(contentLb)+kFrame_Height(titlelb)+2*16+27)];
    
    self.firstBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kFrame_YHeight(contentLb)+16, kMainScreenWidth-20, 58)];
    [self.firstBtn setTitle:@"仅删除组" forState:UIControlStateNormal];
    [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle-下"] forState:UIControlStateNormal];
    [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle-下按下"] forState:UIControlStateHighlighted];
    [self.firstBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    self.firstBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btnView addSubview:self.firstBtn];
    
    UIView *line = [HMTool getLineWithFrame:CGRectMake(0, kFrame_YHeight(contentLb)+16,  kFrame_Width(self.actionSheetView), 0.5) andColor:LINECOLOR];
    [btnView addSubview:line];
    
    [self.firstBtn addTarget:self action:@selector(firstBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    
//    self.seconBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, kFrame_YHeight(self.firstBtn), kMainScreenWidth-20, 58)];
//    [self.seconBtn setTitle:@"仅删除组" forState:UIControlStateNormal];
//    [self.seconBtn setBackgroundColor:[UIColor whiteColor]];
//    self.seconBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    
//    [self.seconBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
//    [btnView addSubview:self.seconBtn];
//    
//    [self.seconBtn addTarget:self action:@selector(seconBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIView *line2 =[HMTool creareLineWithFrame:CGRectMake(0, kFrame_Y(self.seconBtn)-1, kMainScreenWidth-20, 0.5) andColor:LINECOLOR];
//    
//    [self.actionSheetView addSubview:line2];
    
    self.cancelBtn =[[UIButton alloc]init];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"whitebtn"] forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"rectangle按下"] forState:UIControlStateHighlighted];
//    self.cancelBtn.layer.cornerRadius = 8;
//    self.cancelBtn.layer.masksToBounds = YES;
    [ self.cancelBtn setFrame:CGRectMake(0, kFrame_YHeight(btnView)+8 , kMainScreenWidth-20,58)];
    [self.cancelBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionSheetView   addSubview: self.cancelBtn];
    [self.actionSheetView setFrame:CGRectMake(10, kMainScreenHeight+(58*3+16+kFrame_Height(titlelb)+kFrame_Height(contentLb)+16*2), kMainScreenWidth-20, 58*2+16+kFrame_Height(titlelb)+kFrame_Height(contentLb)+16*2+27)];

    [self show];




}
-(void)initLayout{
    self.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.bounds.size.height)];
    [self.maskView setBackgroundColor:[UIColor blackColor]];
    self.maskView.alpha = 0.2;
//     [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:0.4]];
    self.maskView.userInteractionEnabled = YES;
    [self addSubview:self.maskView];
    
    UITapGestureRecognizer *masktap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
    masktap.delegate = self;
    masktap. cancelsTouchesInView = NO;
    [self.maskView addGestureRecognizer:masktap];
    self.actionSheetView = [[UIView alloc]initWithFrame:CGRectMake(10, kMainScreenHeight+(58*3+16), kMainScreenWidth-20, 58*3+16)];
    [self addSubview:self.actionSheetView];
    
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth-20, 58*2)];
//    btnView.alpha = 0.97;
    [self.actionSheetView addSubview:btnView];
    
    
    self.firstBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth-20, 58)];
    [self.firstBtn setTitle:@"拍照" forState:UIControlStateNormal];
    self.firstBtn.titleLabel.font = [UIFont systemFontOfSize:38/2];
    [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle-上"] forState:UIControlStateNormal];
    [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle-上-按下"] forState:UIControlStateHighlighted];
    [self.firstBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
//    self.firstBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btnView addSubview:self.firstBtn];
    [self.firstBtn addTarget:self action:@selector(firstBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];


    
    self.seconBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 58, kMainScreenWidth-20, 58)];
    [self.seconBtn setTitle:@"从手机相册选择" forState:UIControlStateNormal];
    [self.seconBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle-下"] forState:UIControlStateNormal];
    [self.seconBtn setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle-下按下"] forState:UIControlStateHighlighted];
    self.seconBtn.titleLabel.font = [UIFont systemFontOfSize:38/2];
    [self.seconBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [btnView addSubview:self.seconBtn];
    [self.seconBtn addTarget:self action:@selector(seconBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    UIView *line =[HMTool creareLineWithFrame:CGRectMake(0, 58, kMainScreenWidth-20, 0.5) andColor:LINECOLOR];
    [self.actionSheetView addSubview:line];
    self.cancelBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, kFrame_YHeight(btnView)+8 , kMainScreenWidth-20,58)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"whitebtn"] forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"rectangle按下"] forState:UIControlStateHighlighted];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionSheetView   addSubview: self.cancelBtn];
    [self show];



}
-(void)seconBtnClickAction:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(seconBtnClickAction)])
    {
        [self.delegate seconBtnClickAction];
    }


}


-(void)firstBtnClickAction:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(firstBtnClickAction)])
    {
        [self.delegate firstBtnClickAction];
    }

}
-(void)moveUp{
    if (self.hasContent) {
        self.actionSheetView.center = CGPointMake(kMainScreenWidth/2, kMainScreenHeight+kFrame_Height(self.actionSheetView)/2);
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGPoint center = self.actionSheetView.center;
            center.y -= self.actionSheetView.frame.size.height;
            
            self.actionSheetView.center = center;
            
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.01 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            } completion:^(BOOL finished) {
                
                self.actionSheetView.center = CGPointMake(kMainScreenWidth/2, kMainScreenHeight-kFrame_Height(self.actionSheetView)/2);
            }];
            
            
        }];

    }else{
        self.actionSheetView.center = CGPointMake(kMainScreenWidth/2, kMainScreenHeight+kFrame_Height(self.actionSheetView)/2);
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGPoint center = self.actionSheetView.center;
            center.y -= self.actionSheetView.frame.size.height;
            
            self.actionSheetView.center = center;
            
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.01 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            } completion:^(BOOL finished) {
                
                self.actionSheetView.center = CGPointMake(kMainScreenWidth/2, kMainScreenHeight-kFrame_Height(self.actionSheetView)/2);
            }];
            
            
        }];

    
    }
}
-(void)moveDown{
    
    CABasicAnimation *anima=[CABasicAnimation animation];
    anima.keyPath=@"position";
    anima.fromValue=[NSValue valueWithCGPoint:CGPointMake(kMainScreenWidth/2 ,self.bounds.size.height/4*3+(self.bounds.size.height/4)/2)];
    anima.toValue=[NSValue valueWithCGPoint:CGPointMake(kMainScreenWidth/2  ,self.bounds.size.height+(self.bounds.size.height/4)/2)];
    anima.removedOnCompletion=NO;
    anima.delegate = self;
    anima.fillMode=kCAFillModeForwards;
    [self.actionSheetView.layer addAnimation:anima forKey:nil];
    
}

-(void)show{
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(){
                         [self moveUp];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
    
}

-(void)cancelBtnClickedAction:(UIButton *)cancel{
    
    [self disappear];
    
}
-(void)disappear{
    
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(){
                         
                         [self moveDown];
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
