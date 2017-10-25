//
//  CustomerEvaluationTableViewCell.m
//  MoShou2
//
//  Created by wangzz on 2016/10/21.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CustomerEvaluationTableViewCell.h"

@implementation CustomerEvaluationTableViewCell

- (id)initWithCustomerEvaluation:(CustomerEvaluation*)data AndIndexPath:(NSIndexPath*)indexPath
{
    self = [super init];
    if (self) {
        [self layoutUIData:data];
    }
    return self;
}

- (void)layoutUIData:(CustomerEvaluation*)data
{
    NSDictionary *attributes = @{NSFontAttributeName:FONT(14)};
    CGSize size = [@"购买意向:" sizeWithAttributes:attributes];
    UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 2, size.height)];
    lineL.backgroundColor = BLUEBTBCOLOR;
    [self.contentView addSubview:lineL];
    
    UILabel *expectL = [[UILabel alloc] initWithFrame:CGRectMake(lineL.right+10, lineL.top, size.width, size.height)];
    expectL.textColor = LABELCOLOR;
    expectL.text = @"购买意向:";
    expectL.font = FONT(14);
    [self.contentView addSubview:expectL];
    UILabel *expectContentL = [[UILabel alloc] initWithFrame:CGRectMake(expectL.right+10, lineL.top, size.width, size.height)];
    expectContentL.textColor = NAVIGATIONTITLE;
    expectContentL.text = data.evaluation;
    expectContentL.font = FONT(14);
    [self.contentView addSubview:expectContentL];
    
    _evaluationDesBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 15 - 60, lineL.top, 60, lineL.height)];
    [_evaluationDesBtn setTitle:@"评级说明" forState:UIControlStateNormal];
    _evaluationDesBtn.titleLabel.font = FONT(10);
    [_evaluationDesBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    _evaluationDesBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_evaluationDesBtn.layer setMasksToBounds:YES];
    [_evaluationDesBtn.layer setCornerRadius:4];
    [_evaluationDesBtn.layer setBorderColor:BLUEBTBCOLOR.CGColor];
    [_evaluationDesBtn.layer setBorderWidth:0.5];
    [self.contentView addSubview:_evaluationDesBtn];
    if ([data.evaluation isEqualToString:@"无"]) {
        _evaluationDesBtn.hidden = YES;
    }
    
    CGFloat height = expectL.bottom;
    UILabel *expectPL = [[UILabel alloc] initWithFrame:CGRectMake(lineL.left, lineL.bottom+15, size.width, size.height)];
    expectPL.textColor = LABELCOLOR;
    expectPL.text = @"意向偏好:";
    expectPL.font = FONT(14);
    [self.contentView addSubview:expectPL];
    if ([data.intentionalPreference isEqualToString:@"无"]) {
        UILabel *intentionalL = [[UILabel alloc] initWithFrame:CGRectMake(expectPL.right+10, expectPL.top, size.width, size.height)];
        intentionalL.textColor = NAVIGATIONTITLE;
        intentionalL.text = data.intentionalPreference;
        intentionalL.font = FONT(14);
        [self.contentView addSubview:intentionalL];
        height = expectPL.bottom;
    }else
    {
        NSArray *tempArr = [data.intentionalPreference componentsSeparatedByString:@","];
        if (tempArr.count > 0) {
            for (int i=0; i<tempArr.count; i++) {
                NSInteger num = i%5;
                UILabel *tempL = [[UILabel alloc] initWithFrame:CGRectMake(15+(kMainScreenWidth-30-12*4)/5*num+12*num, expectPL.bottom+15+i/5*(30+15), (kMainScreenWidth-30-12*4)/5, 30)];
                
                tempL.text = [tempArr objectForIndex:i];
                tempL.font = FONT(12);
                tempL.textColor = LABELCOLOR;
                tempL.textAlignment = NSTextAlignmentCenter;
                [tempL.layer setMasksToBounds:YES];
                [tempL.layer setCornerRadius:4];
                [tempL.layer setBorderColor:LINECOLOR.CGColor];
                [tempL.layer setBorderWidth:0.5];
                [self.contentView addSubview:tempL];
                height = tempL.bottom;
            }
        }
    }
    
    if (![self isBlankString:data.guideState]) {
        UILabel *adviceL = [[UILabel alloc] initWithFrame:CGRectMake(lineL.left, height+15, size.width, size.height)];
        adviceL.textColor = LABELCOLOR;
        adviceL.text = @"带看情况:";
        adviceL.font = FONT(14);
        [self.contentView addSubview:adviceL];
        CGSize contentSize = [self textSize:data.guideState withConstraintWidth:kMainScreenWidth - 15 - 10 - adviceL.right];
        UILabel *adviceInformationL = [[UILabel alloc] initWithFrame:CGRectMake(adviceL.right+10, adviceL.top, kMainScreenWidth - 15 - 10 - adviceL.right, contentSize.height)];
        adviceInformationL.textColor = NAVIGATIONTITLE;
        adviceInformationL.text = data.guideState;
        adviceInformationL.font = FONT(14);
        adviceInformationL.numberOfLines = 0;
        [adviceInformationL setLineBreakMode:NSLineBreakByWordWrapping];
        [self.contentView addSubview:adviceInformationL];
        
        height = adviceInformationL.bottom;
    }
    
    
    if (![self isBlankString:data.adviceInformation]) {
        UILabel *adviceL = [[UILabel alloc] initWithFrame:CGRectMake(lineL.left, height+15, size.width, size.height)];
        adviceL.textColor = LABELCOLOR;
        adviceL.text = @"建议信息:";
        adviceL.font = FONT(14);
        [self.contentView addSubview:adviceL];
        CGSize contentSize = [self textSize:data.adviceInformation withConstraintWidth:kMainScreenWidth - 15 - 10 - adviceL.right];
        UILabel *adviceInformationL = [[UILabel alloc] initWithFrame:CGRectMake(adviceL.right+10, adviceL.top, kMainScreenWidth - 15 - 10 - adviceL.right, contentSize.height)];
        adviceInformationL.textColor = NAVIGATIONTITLE;
        adviceInformationL.text = data.adviceInformation;
        adviceInformationL.font = FONT(14);
        adviceInformationL.numberOfLines = 0;
        [adviceInformationL setLineBreakMode:NSLineBreakByWordWrapping];
        [self.contentView addSubview:adviceInformationL];
        
        
        height = adviceInformationL.bottom;
    }
    UILabel *lineL2 = [[UILabel alloc] initWithFrame:CGRectMake(15, height+15, kMainScreenWidth-15, 0.5)];
    lineL2.backgroundColor = LINECOLOR;
    [self.contentView addSubview:lineL2];
    
    UILabel *confirmL = [[UILabel alloc] initWithFrame:CGRectMake(lineL.left, lineL2.bottom+15, size.width, size.height)];
    confirmL.textColor = LABELCOLOR;
    confirmL.text = @"评 级 人 :";
    confirmL.font = FONT(14);
    [self.contentView addSubview:confirmL];
    UILabel *userNameL = [[UILabel alloc] initWithFrame:CGRectMake(confirmL.right+10, confirmL.top, kMainScreenWidth - confirmL.right - 100, size.height)];
    userNameL.textColor = NAVIGATIONTITLE;
    userNameL.text = data.userName;
    userNameL.font = FONT(14);
    [self.contentView addSubview:userNameL];
    
    _chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 15 - 80, userNameL.top-5, 80, size.height+10)];
    [_chatBtn setImage:[UIImage imageNamed:@"icon_chat_online"] forState:UIControlStateNormal];
    [_chatBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [_chatBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_chatBtn setTitle:@"在线沟通" forState:UIControlStateNormal];
    [_chatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _chatBtn.titleLabel.font = FONT(10);
    [_chatBtn setBackgroundColor:BLUEBTBCOLOR];
    [_chatBtn.layer setMasksToBounds:YES];
    [_chatBtn.layer setCornerRadius:4];
    [self.contentView addSubview:_chatBtn];
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(lineL.left, confirmL.bottom+15, size.width, size.height)];
    timeL.textColor = LABELCOLOR;
    if (iOS9) {
        timeL.text = @"时      间 :";
    }else
    {
        timeL.text = @"时     间 :";
    }
    timeL.font = FONT(14);
    [self.contentView addSubview:timeL];
    UILabel *dateTimeL = [[UILabel alloc] initWithFrame:CGRectMake(timeL.right+10, timeL.top, kMainScreenWidth - 30 , size.height)];
    dateTimeL.textColor = NAVIGATIONTITLE;
    dateTimeL.text = data.time;
    dateTimeL.font = FONT(14);
    [self.contentView addSubview:dateTimeL];
    
}

//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize result;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        CGFloat width = contraintWidth;
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:@
         {
         NSFontAttributeName: font
         }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        result = size;
        result.width = ceilf(result.width);
        result.height = ceilf(result.height);
    }
    else
    {
        result = [text sizeWithFont: font constrainedToSize: constraint];
    }
    return result;
}

- (BOOL) isBlankString:(NSString*)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
