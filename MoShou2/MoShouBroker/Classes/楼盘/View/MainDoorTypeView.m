//
//  MainDoorTypeView.m
//  MoShou2
//
//  Created by strongcoder on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//


#import "MainDoorTypeView.h"
#import "DoorTypeView.h"
#import "MainDoorViewController.h"
#import "HouseTypeViewController.h"
@interface MainDoorTypeView ()<UIScrollViewDelegate,DoorTypeViewTapActionDelegate>
{
    
    Building *_building;
    UIScrollView *_scrollView;

    
    
}
@end

@implementation MainDoorTypeView

-(id)initBuilding:(Building *)building;
{
    self = [super initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 480/2)];
    if (self) {
        
        _building = building;
        
        [self loadUI];
        
    }
    
    
    return self;
}



-(void)loadUI
{
    
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, kMainScreenWidth-32, 20)];
    titlelabel.text =[NSString stringWithFormat:@"全部户型(%zd)",_building.roomLayoutArray.count];
    titlelabel.textAlignment = NSTextAlignmentLeft;
    titlelabel.textColor = UIColorFromRGB(0x888888);
    titlelabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self addSubview:titlelabel];

    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-20-7, 15, 7, 14)];
    arrowImageView.image = [UIImage imageNamed:@"点击三角"];
    [self addSubview:arrowImageView];

#warning 测试数据
    
    CGFloat doorTypeViewWith = (kMainScreenWidth-40)/3;
    
    
    if (_building.roomLayoutArray.count >0)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, arrowImageView.bottom+15, kMainScreenWidth-10, self.height-arrowImageView.bottom)];
        _scrollView.delegate =self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_building.roomLayoutArray.count*(doorTypeViewWith+10), doorTypeViewWith);
        _scrollView.contentOffset = CGPointMake(0, 0);
        [self addSubview:_scrollView];
        
        
            for (NSInteger i  = 0; i < _building.roomLayoutArray.count; i ++)
            {
                RoomLayout *roomMo = _building.roomLayoutArray[i];
                DoorTypeView *doorView = [[DoorTypeView alloc]initWithRoomlayout:roomMo];
                
                doorView.frame = CGRectMake(i*(doorTypeViewWith+10), 0, doorTypeViewWith, doorTypeViewWith);
                doorView.buildingId = _building.buildingId;
                doorView.delegate = self;
                doorView.currentIndex = i;
                [_scrollView addSubview:doorView];
            }
        
    }else  //没有主力户型数据
    {
    
        UILabel *noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, arrowImageView.bottom, kMainScreenWidth, 60)];
        noDataLabel.text = @"房源小哥正在努力收集中......";
        noDataLabel.textColor = stringColor;
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        noDataLabel.font = FONT(20.f);
        
        [self addSubview:noDataLabel];
        
        [self setHeight:noDataLabel.bottom];
        
    }
    
    
    

    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    DLog(@"%f",scrollView.contentOffset.x);
    
}

-(void)doorTypeViewTapACtion:(DoorTypeView *)view;
{
    
    DLog(@"跳转到户型详情页面");
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;


    HouseTypeViewController *VC = [[HouseTypeViewController alloc]init];
    VC.currentIndex = view.currentIndex;
    VC.building = _building;
    VC.vcType = kAllBuilding;
    [nav pushViewController:VC animated:YES];
    
    
    
}

//-(void)checkMoreBtn:(UIButton *)sender
//{
//    
//    MainDoorViewController *VC = [[MainDoorViewController alloc]init];
//    VC.roomlayoutArr = _building.roomLayoutArray;
//    VC.building = _building;
//    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
//    
//    [nav pushViewController:VC animated:YES];
//    
//    
//    
//}
//



@end
