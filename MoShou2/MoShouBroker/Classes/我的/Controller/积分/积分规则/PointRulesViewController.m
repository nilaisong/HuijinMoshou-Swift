//
//  PointRulesViewController.m
//  MoShou2
//
//  Created by Aminly on 15/12/1.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "PointRulesViewController.h"
#import "DataFactory+User.h"
#import "PointRules.h"
@interface PointRulesViewController (){
    UIScrollView *_bgScrollView;
    UIView *_headView;
    NSArray *_dataArr;
    
    
}

@end

@implementation PointRulesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //导航条
    PLNavigationBar *nav = [[PLNavigationBar alloc]initWithDelegate:self];
    nav.titleLabel.text = @"积分规则";
    [self.view addSubview:nav];
    _bgScrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kFrame_Height(self.navigationBar),kMainScreenWidth ,kMainScreenHeight)];
    [self.view addSubview:_bgScrollView];
    _dataArr = [[NSArray alloc]init];
    [self creartTableHead];
    [self getFirstPageData];

}
-(void)getFirstPageData{
    [[DataFactory sharedDataFactory]getPintsRulesDataWithCallBack:^(DataListResult *result) {
        dispatch_async(dispatch_get_main_queue(),^{

        if (result.dataArray.count >0){
            
            _dataArr = result.dataArray;
            [self creatDetailView];
            [_bgScrollView setContentSize:CGSizeMake(kMainScreenWidth, 53+(42*_dataArr.count)+65)];
            
        }});
        
    }];
    
    
}
-(void)creartTableHead{
//106 83
    _headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 53)];
    [_headView setBackgroundColor:[UIColor colorWithHexString:@"e3f5ff"]];
    UIView *viewA = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth/3, 53)];
    UIView *viewB = [[UIView alloc]initWithFrame:CGRectMake(kMainScreenWidth/3,0 , kMainScreenWidth/3, 53)];
    UIView *viewC = [[UIView alloc]initWithFrame:CGRectMake((kMainScreenWidth/3)*2,0 , kMainScreenWidth/3, 53)];
    [_headView addSubview:viewA];
    [_headView addSubview:viewB];
    [_headView addSubview:viewC];
    UILabel *titleA =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth/3, 53)];
    UILabel *titleB =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth/3, 53)];
    UILabel *titleC =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth/3, 53)];
    titleA.textAlignment = NSTextAlignmentCenter;
    titleB.textAlignment = NSTextAlignmentCenter;
    titleC.textAlignment = NSTextAlignmentCenter;
   
    [viewA addSubview:titleA];
    [viewB addSubview:titleB];
    [viewC addSubview:titleC];
    
    [titleA setText:@"操作"];
    [titleB setText:@"奖励分值"];
    [titleC setText:@"上限"];
    
    [titleA setTextColor:NAVIGATIONTITLE];
    [titleB setTextColor:NAVIGATIONTITLE];
    [titleC setTextColor:NAVIGATIONTITLE];
    
    [titleA setFont:[UIFont systemFontOfSize:15]];
    [titleB setFont:[UIFont systemFontOfSize:15]];
    [titleC setFont:[UIFont systemFontOfSize:15]];

    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, kFrame_Height(_headView)-0.5, kMainScreenWidth, 0.5)];
    [line setBackgroundColor:LINECOLOR];
    [_headView addSubview:line];
    [_bgScrollView addSubview:_headView];
}
-(void)creatDetailView{
    if (_dataArr.count>0) {
        for (int i = 0 ; i<_dataArr.count; i++) {
            PointRules *pointR =[_dataArr objectForIndex:i];
            if (pointR) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 53+i*42, kMainScreenWidth, 42)];
                [view setBackgroundColor:[UIColor whiteColor]];
                UIView *viewA = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth/3, 42)];
                UIView *viewB = [[UIView alloc]initWithFrame:CGRectMake(kMainScreenWidth/3,0 , kMainScreenWidth/3, 42)];
                UIView *viewC = [[UIView alloc]initWithFrame:CGRectMake((kMainScreenWidth/3)*2,0 , kMainScreenWidth/3, 42)];
                [view addSubview:viewA];
                [view addSubview:viewB];
                [view addSubview:viewC];
                UILabel *titleA =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth/3, 42)];
                UILabel *titleB =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth/3, 42)];
                UILabel *titleC =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth/3, 42)];
                [viewA addSubview:titleA];
                [viewB addSubview:titleB];
                [viewC addSubview:titleC];
                [titleA setText:pointR.name];
                [titleB setText:pointR.point];
                [titleC setText:pointR.descr];
                [titleA setTextColor:LABELCOLOR];
                [titleB setTextColor:LABELCOLOR];
                [titleC setTextColor:LABELCOLOR];
                [titleA setFont:[UIFont systemFontOfSize:14]];
                [titleB setFont:[UIFont systemFontOfSize:14]];
                [titleC setFont:[UIFont systemFontOfSize:14]];
                titleA.textAlignment = NSTextAlignmentCenter;
                titleB.textAlignment = NSTextAlignmentCenter;
                titleC.textAlignment = NSTextAlignmentCenter;
                titleC.numberOfLines = 0;
                titleC.adjustsFontSizeToFitWidth = YES;
                
                UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, kFrame_Height(view)-0.5, kMainScreenWidth, 0.5)];
                [line setBackgroundColor:LINECOLOR];
                [view addSubview:line];
                [_bgScrollView addSubview:view];
            }
        }
        UIView *lineA =[[UIView alloc]initWithFrame:CGRectMake(kMainScreenWidth/3, 0, 0.5, 53+(42*_dataArr.count))];
        UIView *lineB =[[UIView alloc]initWithFrame:CGRectMake(kMainScreenWidth/3*2, 0, 0.5, 53+(42*_dataArr.count))];
        [lineA setBackgroundColor:LINECOLOR];
        [lineB setBackgroundColor:LINECOLOR];

        [_bgScrollView addSubview:lineA];
        [_bgScrollView addSubview:lineB];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
