//
//  SearchTableView.m
//  MoShouBroker
//
//  Created by caotianyuan on 15/7/23.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "SearchTableView.h"
#import "FMDBSource+Broker.h"
#import "GSTagView.h"

@interface SearchTableView()<UITableViewDataSource,UITableViewDelegate,GSTagViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation SearchTableView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self createTableView];
    }
    return self;
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_tableView];
    
   }


-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [_tableView reloadData];
    
}
-(void)setIsHotRecommendBuildingName:(BOOL)isHotRecommendBuildingName
{
   
    _isHotRecommendBuildingName = isHotRecommendBuildingName;
   
    [_tableView reloadData];

    
}




-(void)reloadTableView
{
    [_tableView reloadData];
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isHotRecommendBuildingName) {
        
        return 1;
    }else{
        return _dataArray.count;

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_isHotRecommendBuildingName && self.dataArray.count>0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        [cell.contentView addSubview:bgView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth, 31)];
        titleLabel.text = @"热销楼盘";
        titleLabel.font = FONT(12.f);
        titleLabel.textColor = UIColorFromRGB(0x888888);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:titleLabel];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 31, kMainScreenWidth-10, 1)];
        lineLabel.backgroundColor = UIColorFromRGB(0xeaeaea);
        [bgView addSubview:lineLabel];
        
        GSTagView *tagView =[[GSTagView alloc]initWithFrame:CGRectMake(0, lineLabel.bottom+5, kMainScreenWidth, kMainScreenHeight)];
        tagView.backgroundColor = [UIColor whiteColor];
        tagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
        tagView.horizontalSpace = 10;
        tagView.verticalSpace = 10;
        tagView.tagViewStyle = ShaiXuanTagViewStyle;
        tagView.dataSource = self.dataArray;
        tagView.delegate = self;
        
        [bgView addSubview:tagView];
        
        return cell;
        
     }else{
        
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.textLabel.text =_dataArray[indexPath.row];
        cell.textLabel.font = FONT(16.f);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_dataArray.count>0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
        
    }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isHotRecommendBuildingName) {
        return kMainScreenHeight;
 
    }else{
        return 50;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isHotRecommendBuildingName) {
        
        if ([self.delegate respondsToSelector:@selector(didSelectWith:andKeyword:)])
        {
            [self.delegate didSelectWith:self andKeyword:_dataArray[indexPath.row]];
        }else if ([self.delegate respondsToSelector:@selector(didSelectWith:andKeyword:index:)])
        {
            [self.delegate didSelectWith:self andKeyword:_dataArray[indexPath.row] index:indexPath.row];
        }
        
//        if (self)
//        {
//            [self removeFromSuperview];
//            
//        }
        
    }else{
        
        if ([self.delegate respondsToSelector:@selector(didCanCelSelect)]) {
            [self.delegate didCanCelSelect];
        }
        
//        if (self)
//        {
//            [self removeFromSuperview];
//            
//        }
        
    }
    
   }



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(didCanCelSelect)]) {
        [self.delegate didCanCelSelect];
    }
    
}




#pragma mark - GStagViewDelegate

- (void)didSelectAtIndex:(int)index;
{
    
    NSLog(@"index = %d",index);
    if ([self.delegate respondsToSelector:@selector(didSelectWith:andKeyword:)])
    {
        [self.delegate didSelectWith:self andKeyword:_dataArray[index]];
    }
    if ([self.delegate respondsToSelector:@selector(didSelectWith:andKeyword:index:)])
    {
        [self.delegate didSelectWith:self andKeyword:_dataArray[index] index:index];
    }

    if (self && ![self.delegate respondsToSelector:@selector(didSelectWith:andKeyword:index:)])
    {
        [self removeFromSuperview];
        
    }

    
    
}
@end
