//
//  HouseAlbumViewController.m
//  MoShouBroker
//
//  Created by admin on 15/6/25.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "HouseAlbumViewController.h"
#import "LQScrollBtnView.h"
#import "YRControlButton.h"
#import "YRImageView.h"
#import "YRPageControl.h"
#import "LQToolView.h"
#import "Building.h"
#import "AlbumData.h"
#import "ShowBigImageViewController.h"
#import "ShareModel.h"
#import "UIView+YR.h"
#import "ShareActionSheet.h"


@interface HouseAlbumViewController ()<UIScrollViewDelegate,YRPageControlDelegate,LQToolViewDelegate>

@property (nonatomic,strong) NSMutableArray  *titleArr;
@property (nonatomic,strong) NSMutableArray  *contentArr;
@property (nonatomic,strong) NSMutableArray  *imageArr;
@property (nonatomic,strong) NSMutableArray  *imageStringArr;
@property (nonatomic,strong) YRControlButton *controBtn;
@property (nonatomic,strong) UIScrollView    *mainScrollView;
@property (nonatomic,assign) NSInteger       totoalCount;
@property (nonatomic,strong) UILabel         *numLabel;
@property (nonatomic,strong) YRPageControl   *pageContol;
@property (nonatomic,strong) LQToolView      *    tooView;
@property (nonatomic,strong) ShareActionSheet       *shareView;

@end

@implementation HouseAlbumViewController


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text =self.building.name;
    
    if (self.building.albumArray.count > 0)
    {
        _contentArr     = [NSMutableArray array];
        _titleArr       = [NSMutableArray array];
        _imageArr       = [NSMutableArray array];
        _imageStringArr = [NSMutableArray array];

        if (self.building.albumArray.count > 0)
        {
            for (AlbumData *albumDate  in self.building.albumArray)
            {
                [_contentArr appendObject:albumDate.images];
                [_titleArr appendObject:albumDate.albumName];
                
            }
        }
        [self addNavItem];  //分享按钮
        [self addControlButton]; //下方效果图   房型图 等等
        [self addScrollView];
        [self addPageControl];
 
    }else
    {
        [self tempView];
        
//        AlertShow(@"楼盘相册数据为空!");
        
        
    }
}

-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (_controBtn.superview) {
        _controBtn.frame = CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 50);
    }
    if (_mainScrollView.superview) {
        _mainScrollView.frame = CGRectMake(0,64, self.view.bounds.size.width, self.view.bounds.size.height-64-50);
    }
    if (_numLabel.superview) {
        _numLabel.frame =CGRectMake(0, self.view.bounds.size.height-50-30-30, self.view.bounds.size.width - 10, 20);
    }
    if (_pageContol.superview) {
        _pageContol.frame =CGRectMake( 0, 64+50, self.view.bounds.size.width, 30);
    }
//    if (_shareView.superview) {
//        _shareView.frame = self.view.bounds;
//        [_shareView adjustFrameForHotSpotChange ];
//    }
    if (_tooView.superview) {
        _tooView.frame = self.view.bounds;
        [_tooView adjustFrameForHotSpotChange];
    }
}

-(void)tempView{
    [self.mainScrollView setHidden:YES];
    UIImageView *tempImage =[[UIImageView alloc]init];
    [tempImage setImage:[UIImage imageNamed:@"iconfont-wenjian"]];
    [tempImage setFrame:CGRectMake(kMainScreenWidth/2-98/2, 64+44+(kMainScreenWidth-64-44-30)/2, 98, 111)];
    [self.view addSubview:tempImage];
    
    UILabel *tip = [[UILabel alloc]init];
    //    NSMutableAttributedString *tipText = [[NSMutableAttributedString alloc]initWithString:@"没有数据"];
    //    [tipText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8, 11)];
    CGSize ss = [@"没有数据" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [tip setFont:[UIFont systemFontOfSize:13]];
    [tip setFrame:CGRectMake(0, kFrame_YHeight(tempImage)+20, ss.width, ss.height)];
    [tip setCenterX:kMainScreenWidth/2];
    [tip setTextColor:LINECOLOR];
    [tip setText:@"没有数据"];
    [self.view addSubview:tip];
}



-(void)addNavItem
{
    UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toolBtn.frame = CGRectMake(kMainScreenWidth-44, 20, 44, 44);
    [toolBtn setImage:[UIImage imageNamed:@"building-down.png"] forState:UIControlStateNormal];
    [toolBtn setImage:[UIImage imageNamed:@"building-down.png"] forState:UIControlStateHighlighted];
    [toolBtn addTarget:self action:@selector(saveImageClick) forControlEvents:UIControlEventTouchUpInside];

    [self.navigationBar addSubview:toolBtn];
}

-(void)saveImageClick
{
    NSInteger index = _mainScrollView.contentOffset.x/kMainScreenWidth;

    YRImageView *imageView = _imageArr[index];
   
      UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
//    _tooView = [[LQToolView alloc]initWithDelegate:self andFrame:self.view.bounds];
//    
//    [self.view addSubview:_tooView];
    
}

- (void)addControlButton
{
    if (!_controBtn) {
        _controBtn = [[YRControlButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-50, kMainScreenWidth, 50)];
        [self.view addSubview:_controBtn];
    }
    [_controBtn initButtonWithTitles:_titleArr icon:nil iconSelected:nil isShowSeparator:YES isShortSelector:NO setButtonBackground:[UIColor whiteColor] setButtonSelectedBackground:[UIColor whiteColor] defaultIndex:0];
    
    __weak typeof(self) wself = self;
    _controBtn.block = ^(NSInteger index){
        NSInteger totaoIndex = 0;
        if (index!=0) {
            for (NSInteger i = index - 1; i >=0 ; i --) {
                totaoIndex +=[_contentArr[i] count];
            }
        }
        CGFloat x = kMainScreenWidth*totaoIndex;
        CGRect rect = CGRectMake(x, 0, kMainScreenWidth, self.view.bounds.size.height-64-50);
        [wself.mainScrollView scrollRectToVisible:rect animated:YES];
//        wself.numLabel.text = [NSString stringWithFormat:@"%@1/%lu",wself.titleArr[index],(unsigned long)[wself.contentArr[index] count]];
        wself.pageContol.currentPage = totaoIndex + 1;
    };

}

- (void)addScrollView {
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.delegate = self;
    _mainScrollView.backgroundColor =UIColorFromRGB(0x3a434d);
    _mainScrollView.frame = CGRectMake(0,64, kMainScreenWidth, self.view.bounds.size.height-64-50);
//    _mainScrollView.bounces = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.scrollsToTop = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    [_mainScrollView setScrollsToTop:NO];
    
    [self.view addSubview:_mainScrollView];
    
    [self addScrollViewContent];
    
    
}
- (void)addPageControl {
//    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-50-30-30, kMainScreenWidth - 10, 20)];
//    _numLabel.textColor = [UIColor whiteColor];
//    _numLabel.textAlignment = NSTextAlignmentRight;
//    _numLabel.font = FONT(17);
    //注释掉下方的效果图1/2类是效果文本条
//    _numLabel.text = [NSString stringWithFormat:@"%@1/%lu",_titleArr[0],(unsigned long)[_contentArr[0] count]];
    
    CGFloat topBlackBgHeight = (kMainScreenHeight-64-50-kMainScreenWidth*0.75)/2-13;

    //上方的当前页/所有页面的View
    
    
    UILabel *bgLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10, 64+topBlackBgHeight+kMainScreenWidth*0.75, 45, 45)];
    
//    bgLabel.backgroundColor = [UIColor blackColor];
//    bgLabel.alpha = 0.3;
//    bgLabel.layer.cornerRadius = bgLabel.width/2;
//    bgLabel.layer.masksToBounds = YES;
    [self.view addSubview:bgLabel];
    
    _pageContol = [[YRPageControl alloc] initWithFrame:CGRectMake( kMainScreenWidth-40, 64+topBlackBgHeight+kMainScreenWidth*0.75-35, 30, 30) totalCount:_totoalCount];
    //注释掉可禁用左右按钮的调用
//    _pageContol.delegate = self;
    
    [self.view addSubview:_numLabel];
    [self.view addSubview:_pageContol];
}

- (void)addScrollViewContent {
    for (NSInteger i = 0 ; i < _contentArr.count; i ++) {
        NSArray *arr = _contentArr[i];
        for (NSInteger j = 0; j < arr.count; j ++) {
            NSString *str = arr[j];
            YRImageView *img = [[YRImageView alloc] init];
            img.buildingId = self.building.buildingId;
            DLog(@"相册图片=====%@",str);
            [img setImageWithUrlString:str placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
            img.frame = CGRectMake(_totoalCount*kMainScreenWidth, 0, kMainScreenWidth, kMainScreenWidth*0.75);
            img.centerY = _mainScrollView.height/2.f - 13;
            img.totalIndex = _totoalCount;
            img.groupIndex = i;
            img.littleIndex = j;
            img.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ShowBigImage:)];
            [img addGestureRecognizer:tap];
            
            [_mainScrollView addSubview:img];
            [_imageArr appendObject:img];
            [_imageStringArr appendObject:str];
            _totoalCount ++;
            
        }
    }
    
    _mainScrollView.contentSize = CGSizeMake(kMainScreenWidth*_totoalCount, _mainScrollView.frame.size.height);
}

#pragma mark - YRPageControlDelegate

- (void)didPageControlClickedAtIndex:(NSInteger)index {
    YRImageView *img = _imageArr[index];
//    _numLabel.text = [NSString stringWithFormat:@"%@%ld/%lu",_titleArr[img.groupIndex],(long)img.littleIndex + 1,(unsigned long)[_contentArr[img.groupIndex] count]];
    [_controBtn selectAtIndex:img.groupIndex];
    _pageContol.currentPage = img.totalIndex + 1;
    CGFloat x = kMainScreenWidth*img.totalIndex;
    CGRect rect = CGRectMake(x, 0, kMainScreenWidth, self.view.bounds.size.height-50-64);
    [_mainScrollView scrollRectToVisible:rect animated:YES];
}

-(void)ShowBigImage:(UITapGestureRecognizer *)tap
{
    DLog(@"%f",_mainScrollView.contentOffset.x/kMainScreenWidth);
    NSInteger index = _mainScrollView.contentOffset.x/kMainScreenWidth;
    
    YRImageView *imageView = _imageArr[index];
    ShowBigImageViewController *VC = [[ShowBigImageViewController alloc]init];
    VC.bigImage =imageView.image;
    [self presentViewController:VC animated:NO completion:nil];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //    这个方法在Uisrollview有位移的时候调用，用来输出偏移量测试
    NSLog(@"contentOffset.x====%f",scrollView.contentOffset.x);
    NSLog(@"contentOffset.y====%f",scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.x < -60)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/kMainScreenWidth;
    YRImageView *img = _imageArr[index];
//    _numLabel.text = [NSString stringWithFormat:@"%@%ld/%lu",_titleArr[img.groupIndex],(long)img.littleIndex + 1,(unsigned long)[_contentArr[img.groupIndex] count]];
    DLog(@"_numLabel.text=%@",_numLabel.text);
//   NSInteger littleIndex;
//   NSInteger totalIndex; 在所有数组中的序列
//   NSInteger groupIndex;
    DLog(@"%zd   %zd   %zd",img.littleIndex,img.totalIndex,img.groupIndex);
    [_controBtn selectAtIndex:img.groupIndex];
    _pageContol.currentPage = img.totalIndex + 1;
    
}

#pragma mark - LQToolViewDelegate

-(void)backgroundViewTapClick
{
    [_tooView removeFromSuperview];
    _tooView = nil;
}
-(void)chooseBtn:(LQToolView *)view withChooseIndex:(NSInteger)chooseIndex
{ 
    NSInteger index = _mainScrollView.contentOffset.x/kMainScreenWidth;
    
    NSString*imageStr = _imageStringArr[index];
    YRImageView *imageView = _imageArr[index];
    
    switch (chooseIndex) {
        case 0:   //保存到手机
        {
            UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
            break;
            case 1:   //分享
        {
            if([UserData sharedUserData].shareRangeArray.count>0){
                [_tooView removeFromSuperview];
                ShareModel *share = [[ShareModel alloc]init];
                share.title = @"楼盘";
                share.linkUrl=@"https://www.baidu.com/";
                share.content = @" ";
                share.img = imageStr;
                
                UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
                if (image) {
                    DLog(@"%@",imageStr);
                    if(_shareView){
                        
                        [_shareView removeFromSuperview];
                    }
                    //                _shareView = [[ShareActionSheet alloc]initWithShareType:IMAGE andModel:share andParent:[UIApplication sharedApplication].keyWindow];
                    _shareView = [[ShareActionSheet alloc]initAutoShareViewWithShareRange:[UserData sharedUserData].shareRangeArray ShareType:BUILDING andModel:share andParent:self.view];
                    
                }else{
                    [self showTips:@"图片未加载完成，无法进行分享"];
                    
                }
   
            }else{
                [self showTips:@"暂不能分享"];
            }
            
           
        }
            break;
            case 2:  //取消
        {
            
            [_tooView removeFromSuperview];
            _tooView = nil;
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error){
        NSLog(@"Error");
        [self showTips:@"保存失败..."];
    }else {
        NSLog(@"OK");
        [self showTips:@"保存成功！"];
        
    }
    [_tooView removeFromSuperview];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
