//
//  XTSaleRankingCell.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/19.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTSaleRankingCell.h"
#import "PerformanceRanking.h"
#import "SignRanking.h"
#import "LookRanking.h"
#import "UIImageView+AFNetworking.h"

@interface XTSaleRankingCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//排名序号label
@property (weak, nonatomic) IBOutlet UILabel *rankingNumberLabel;
//经纪人名字
@property (weak, nonatomic) IBOutlet UILabel *brokerNameLabel;
//机构名字
@property (weak, nonatomic) IBOutlet UILabel *agencyNameLabel;
///业绩
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
//前三排名图片
@property (weak, nonatomic) IBOutlet UIImageView *sortImageView;

@property (weak, nonatomic)UIView *blackLineView;

@end

@implementation XTSaleRankingCell

+ (instancetype)saleRankingCellWithTableView:(UITableView *)tableView{
    NSString* className = NSStringFromClass([self class]);
    
    XTSaleRankingCell * cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        UINib * nib = [UINib nibWithNibName:className bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:className];
        cell = [tableView dequeueReusableCellWithIdentifier:className];
        
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    _headImageView.clipsToBounds = YES;
    _headImageView.layer.cornerRadius = 15.0f;
    [self blackLineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setRankingModel:(id)rankingModel{
    _rankingModel = rankingModel;
    
    //业绩
    if ([rankingModel isKindOfClass:[PerformanceRanking class]]) {
        PerformanceRanking* performance = (PerformanceRanking*)rankingModel;
        _agencyNameLabel.text = performance.shopName;
        _brokerNameLabel.text = performance.userName;
        NSString* string = [NSString stringWithFormat:@"￥%.0f元",performance.assistantManualVal];
        if (performance.assistantManualVal == 0) {
            string = @"￥0元";
        }
        _rankingNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)performance.rownum];
        _incomeLabel.attributedText = [self attributeWithStringYuan:string];
        if (performance.headPic.length > 0) {
            [_headImageView setImageWithURL:[NSURL URLWithString:[performance.headPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"me-small"]];
        }
        [self setSortIndex:performance.rownum];
    }else if ([rankingModel isKindOfClass:[SignRanking class]]) {
        SignRanking* performance = (SignRanking*)rankingModel;
        _agencyNameLabel.text = performance.shopName;
        _brokerNameLabel.text = performance.userName;
        _rankingNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)performance.rownum];
        NSString* string =[NSString stringWithFormat:@"%ld套",(long)performance.signNum];
        _incomeLabel.attributedText = [self attributeWithStringTao:string];
        if (performance.headPic.length > 0) {
            [_headImageView setImageWithURL:[NSURL URLWithString:[performance.headPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"me-small"]];
        }
        [self setSortIndex:performance.rownum];
    }else if ([rankingModel isKindOfClass:[LookRanking class]]) {
        LookRanking* performance = (LookRanking*)rankingModel;
        _agencyNameLabel.text = performance.shopName;
        _brokerNameLabel.text = performance.userName;
        _rankingNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)performance.rownum];
        NSString* string = [NSString stringWithFormat:@"%ld",(long)performance.guideNum];
        _incomeLabel.attributedText = [self attributeWithStringShu:[self getTheCorrectNum:string]];
        if (performance.headPic.length > 0) {
            [_headImageView setImageWithURL:[NSURL URLWithString:[performance.headPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]  placeholderImage:[UIImage imageNamed:@"me-small"]];
        }
        [self setSortIndex:performance.rownum];
    }
    if (_brokerNameLabel.text.length > 5) {
        NSString* name = [_brokerNameLabel.text substringToIndex:5];
        
        _brokerNameLabel.text = [NSString stringWithFormat:@"%@...",name];
    }
}

- (NSMutableAttributedString*)attributeWithStringYuan:(NSString*)string{
       NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:20]
     
                          range:NSMakeRange(1, string.length - 2)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f]
     
                          range:NSMakeRange(1, string.length - 2)];
    
    return AttributedStr;
}
- (NSMutableAttributedString*)attributeWithStringTao:(NSString*)string{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:20]
     
                          range:NSMakeRange(0, string.length - 1)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f]
     
                          range:NSMakeRange(0, string.length - 1)];
    
    return AttributedStr;
}

- (NSMutableAttributedString*)attributeWithStringShu:(NSString*)string{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:20]
     
                          range:NSMakeRange(0, string.length)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f]
     
                          range:NSMakeRange(0, string.length)];
    
    return AttributedStr;
}

- (void)setSortIndex:(NSInteger)index{
    _sortImageView.hidden = NO;
    switch (index) {
        case 1:
        {
            [_sortImageView setImage:[UIImage imageNamed:@"sort1"]];
        }
            break;
        case 2:
        {
            [_sortImageView setImage:[UIImage imageNamed:@"sort2"]];
        }
            break;
        case 3:
        {
            [_sortImageView setImage:[UIImage imageNamed:@"sort3"]];
        }
            break;
            
        default:
        {
            _sortImageView.hidden = YES;
        }
            break;
    }
}

-(NSString*) getTheCorrectNum:(NSString*)tempString

{
    
    
    
    if([tempString hasPrefix:@"0"] && tempString.length > 1)
        
    {
        
        tempString = [tempString substringFromIndex:1];
        
        NSLog(@"压缩之后的tempString:%@",tempString);
    }
    
    
    return tempString;
    
}

- (UIView *)blackLineView{
    if (!_blackLineView) {
       UIView* LineView = [[UIView alloc]initWithFrame:CGRectMake(0, 51.5, kMainScreenWidth, 0.5)];
        [self.contentView addSubview:LineView];
        _blackLineView = LineView;
        _blackLineView.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
    }
    return _blackLineView;
}

@end
