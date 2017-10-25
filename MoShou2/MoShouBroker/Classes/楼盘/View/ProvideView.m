//
//  ProvideView.m
//  MoShou2
//
//  Created by strongcoder on 15/12/18.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "ProvideView.h"
#import "TipsView.h"

@implementation ProvideView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(id)initWithFrame:(CGRect)frame AndProvideViewStyle:(ProvideViewStyle)provideViewStyle;
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        
    UILabel *linelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    linelabel.backgroundColor = kRGB(200, 199, 204);
    [self addSubview:linelabel];
        
    self.provideViewStyle = provideViewStyle;
    self.backgroundColor = [UIColor whiteColor];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.3*kMainScreenWidth, 44)];
    self.monelyTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, bgView.width*0.7, 44)];
    self.monelyTF.placeholder = @"0";
    self.monelyTF.keyboardType = UIKeyboardTypeDecimalPad;
//        self.monelyTF.delegate = self;
    self.monelyTF.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:self.monelyTF];
    
    UILabel *wanlabel = [[UILabel alloc]initWithFrame:CGRectMake(self.monelyTF.right, 0, bgView.width-self.monelyTF.right, 44)];
    wanlabel.text = @"万";
    wanlabel.textColor = LABELCOLOR;
    wanlabel.font = FONT(16.f);
    [bgView addSubview:wanlabel];
    
    [self addSubview:bgView];

    UILabel *shuLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.3*kMainScreenWidth, 5, 1, 35)];
    shuLineLabel.backgroundColor = LINECOLOR;
    [self addSubview:shuLineLabel];
    
    UILabel *shuLineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0.6*kMainScreenWidth, 5, 1, 35)];
    shuLineLabel1.backgroundColor = LINECOLOR;
    [self addSubview:shuLineLabel1];
        
        
    UIView *bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0.3*kMainScreenWidth, 0, 0.3*kMainScreenWidth, 44)];
    self.yearBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bgView2.width, bgView.height)];
    
    [self.yearBtn setTitle:@"20年" forState:UIControlStateNormal];
    [self.yearBtn setTitleColor:NAVIGATIONTITLE forState:UIControlStateNormal];
    [self.yearBtn setImage:[UIImage imageNamed:@"arrow_fangdaidown.png"] forState:UIControlStateNormal];
    [self.yearBtn setImage:[UIImage imageNamed:@"arrow_fangdaiup.png"] forState:UIControlStateSelected];
    [self.yearBtn.imageView setContentMode:UIViewContentModeCenter];
    [self.yearBtn.titleLabel setContentMode:UIViewContentModeCenter];
    
    [self.yearBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [self.yearBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
    [self.yearBtn addTarget:self action:@selector(yearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView2 addSubview:self.yearBtn];
    
    [self addSubview:bgView2];
    
    UIView *bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0.6*kMainScreenWidth, 0, 0.4*kMainScreenWidth, 44)];
//    bgView3.backgroundColor = [UIColor yellowColor];
    [self addSubview:bgView3];
    
    UILabel *liLvLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, bgView3.width/2, bgView3.height)];
    liLvLabel.text = @"基准利率";
    liLvLabel.font = FONT(13.f);
    liLvLabel.textAlignment = NSTextAlignmentCenter;
    liLvLabel.textColor = LABELCOLOR;
    [bgView3 addSubview:liLvLabel];
    
    self.lilvTF = [[UITextField alloc]initWithFrame:CGRectMake(liLvLabel.right, 0, bgView3.width-liLvLabel.right-10, bgView3.height)];
    self.lilvTF.keyboardType = UIKeyboardTypeDecimalPad;
//        self.lilvTF.delegate = self;
//        self.lilvTF.backgroundColor = [UIColor redColor];
        if (self.provideViewStyle == gongjiStyle) {
            self.lilvTF.placeholder = @"3.25";
            
        }else if (self.provideViewStyle == shangyeStyle){
            self.lilvTF.placeholder = @"5.15";
        }
    self.lilvTF.textColor = [UIColor blackColor];
    self.lilvTF.textAlignment = NSTextAlignmentCenter;
    [bgView3 addSubview:self.lilvTF];
        
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.lilvTF.right, 0, 10, bgView3.height)];
    label.text = @"%";
    label.textColor =LABELCOLOR;
    label.font = FONT(13.f);
    [bgView3 addSubview:label];

   
    }
    
    return self;

}


//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//   
//        if ([textField isEqual:self.monelyTF]) {
//    
//            if (range.location >= 5)
//                return NO;
//            if (![string isEqualToString:@""])
//            {
//                NSRange rang = [textField.text rangeOfString:@"."];
//                if ([string isEqualToString:@"."])
//                {
//                    if (textField.text.length == 0) return NO;
//                    if (range.location != NSNotFound) return NO;
//    
//                }else{
//    
//                    if (rang.location!= NSNotFound){
//                        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
//                    }
//                }
//            }
//            
//        }
//    
//    
//    if ([textField isEqual:self.lilvTF])
//    {
//        if (range.location >= 5)
//            return NO;
//        if (![string isEqualToString:@""]) {
//            NSRange range = [textField.text rangeOfString:@"."];
//            if ([string isEqualToString:@"."]) {
//                if (textField.text.length == 0) return NO;
//                if (range.location != NSNotFound) return NO;
//            }else {
//                if ((range.location != NSNotFound) && (range.location == textField.text.length - 3)) return NO;
//                if ([textField.text isEqualToString:@"0"] && ![string isEqualToString:@"."]) return NO;
//            }
//        }
//        
//    }
//    
//    
//    return YES;
//}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(([textField.text floatValue]>100 || [textField.text floatValue]<0 || (int)([textField.text floatValue]*100) != [textField.text floatValue]*100) && textField == self.lilvTF){
        [TipsView showTips:@"请输入正确利率" inView:self.superview];
        textField.text = @"";
    }
    if (textField == self.monelyTF && ((int)([textField.text floatValue]*100) != [textField.text floatValue]*100 || [textField.text floatValue]<0)) {
        [TipsView showTips:@"请输入正确利率" inView:self.superview];
        textField.text = @"";
        
    }
    return YES;
}

-(void)yearBtnClick:(UIButton *)sender
{
    [self.lilvTF resignFirstResponder];
    [self.monelyTF resignFirstResponder];
    
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(yearBtnClickWithSelf:)]) {
        
        [self.delegate yearBtnClickWithSelf:self];
        }

}


@end
