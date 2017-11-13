//
//  XTWebNavigationControler.m
//  MoShou2
//
//  Created by xiaotei's on 16/9/27.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTWebNavigationControler.h"
#import "RecommendNewsListView.h"
#import "DataFactory+Main.h"
#import "XTOperationModelItem.h"
#import "XTRecdDescriptionModel.h"
#import "XTRecdDescModelItem.h"
#import "MyWebView.h"
#import "NSString+Extension.h"
#import "BuildingDetailViewController.h"
#import "XTOperationListController.h"
#import "ShareActionSheet.h"
#import "ShareModel.h"
#import "TFHpple.h"
#import "NSString+Base64.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface XTWebNavigationControler()<UIWebViewDelegate,UIScrollViewDelegate,PLNavigationBarDelegate>
{
    CGFloat _trueContentHeight;
}
@property (nonatomic,copy)NSString* urlString;//网页链接
@property (nonatomic,copy)NSString* navTitle;
@property (nonatomic,copy)NSString* subTitle;
@property (nonatomic,strong)NSURL* url;


@property (nonatomic,weak)MyWebView* webView;

//@property (nonatomic,weak)UIScrollView* contentScrollView;

@property (nonatomic,weak)RecommendNewsListView* listView;

@property (nonatomic,weak)UILabel* titleLabel;

@property (nonatomic,weak)UILabel* createTimeLabel;

@property (nonatomic,weak)UIButton* shareButton;

@property (nonatomic,weak)ShareActionSheet* shareView;

/**
 *  推荐详情
 */
@property (nonatomic,strong)XTRecdDescriptionModel* recdDesdModel;

@property (nonatomic,strong)NSXMLParser* m_parser;

@property (nonatomic,strong)UIWebView* caculateWebView;

@property (nonatomic,weak)UIImageView* rotateAnimateView;

@end

@implementation XTWebNavigationControler

- (instancetype)initWithURLString:(NSString *)urlString{
    if (self = [super init]) {
        self.urlString = urlString;
        if (urlString.length > 0 && urlString != nil) {
            self.url = [NSURL URLWithString:urlString];
        }
        
    }
    return self;
}

- (instancetype)initWithURLString:(NSString *)urlString title:(NSString *)title{
    if (self = [self initWithURLString:urlString]) {
        self.navTitle = title;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (![NetworkSingleton sharedNetWork].isNetworkConnection) {
        [self createNoNetWorkViewWithReloadBlock:^{
            //[self.view removeAllSubviews];
            [self commonInit];
        }];
    }else{
        [self commonInit];    
    }
    
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)commonInit{
    if (self.itemModel.title.length > 0){
        self.navigationBar.titleLabel.text = self.itemModel.title;
    }else if (self.navTitle.length > 0) {
        self.navigationBar.titleLabel.text = self.navTitle;
    }
    self.navigationBar.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.listView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 116);
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.frame = CGRectMake(0 , 64, kMainScreenWidth , kMainScreenHeight - 64);
    [self addObserver];
    if (self.url != nil) {
        //        [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
    }
    if (_titleString.length > 0 && self.itemModel.title.length <= 0) {
        self.navigationBar.titleLabel.text = _titleString;
    }
    
    if (_itemModel.skipUrl.length > 0 && _itemModel.isSkipUrl == 2) {
        self.navigationBar.titleLabel.text = _itemModel.title;
        NSURL* url = [NSURL URLWithString:[self extensionUrlWithUrlStr:_itemModel.skipUrl]];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url];
        [self.webView loadRequest:request];
    }
    UIImageView* animV = [self setRotationAnimationWithView];
    _rotateAnimateView = animV;
    if (!_itemModel || _itemModel.skipUrl.length > 0 ) {
        return;
    }
    [[DataFactory sharedDataFactory] getReportDetailWithType:_itemModel.type recdId:_itemModel.ID callBack:^(XTRecdDescriptionModel *result) {
        [self removeRotationAnimationView:_rotateAnimateView];
        if (!result) {
            return ;
        }
        
        _recdDesdModel = result;
        self.titleLabel.text =  result.recdDesc.title;
        
        self.createTimeLabel.text = [NSString stringWithFormat:@"%@ 汇金行",[result.recdDesc.createTime substringToIndex:result.recdDesc.createTime.length - 3]];
        NSString* autoSizeString = @"<meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0\">";
        NSString* contentS = [autoSizeString stringByAppendingString:result.recdDesc.content];
        //        contentS = [contentS stringByAppendingString:@"<a href=\"https://www.baidu.com\">百度一下</a>"];
        //        self.webView.frame = CGRectMake(8, 0, kMainScreenWidth - 16, 1);
        [self.webView loadHTMLString:contentS baseURL:nil];
        if (result.relateRecd.count > 0 && result.relateRecd) {
            self.listView.relateRecdArray = result.relateRecd;
            self.listView.hidden = NO;
        }else{
            self.listView.hidden = YES;
        }
        if (result.recdDesc.contentNotag > 0) {
            //            [self parseXMLWithString:result.recdDesc.content];
            [self fliterContent:result.recdDesc.contentNotag];
        }
        if ([UserData sharedUserData].shareRangeArray.count>0) {
            [self shareButton];
        }
    } failedCallBack:^(ActionResult *result) {
        if (result.message.length > 0) {
            [self showTips:result.message];
        }
    }];
    
//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(woshiceshicrash:) userInfo:nil repeats:NO];
}

-(MyWebView*)webView{
    if (!_webView) {
        MyWebView* webV = [[MyWebView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64)];
        webV.scrollView.contentInset = UIEdgeInsetsMake(0, 8, 0, 8);
        webV.backgroundColor = [UIColor whiteColor];
        webV.opaque = NO;
        webV.scrollView.backgroundColor = [UIColor whiteColor];
        webV.backgroundColor = [UIColor clearColor];
        //        webV.scrollView.bounces = NO;
        webV.scrollView.showsVerticalScrollIndicator = NO;
        webV.scrollView.showsHorizontalScrollIndicator = NO;
        [webV setDelegate:(id)self];
        webV.scalesPageToFit = YES;
        webV.delegate = self;
        //        webV.scrollView.scrollEnabled = NO;
        webV.contentMode = UIViewContentModeScaleAspectFit;
        webV.autoresizingMask=(UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth);
        [self.view addSubview:webV];
        self.view.userInteractionEnabled = YES;
        webV.scrollView.userInteractionEnabled= YES;
        webV.userInteractionEnabled = YES;
        //        [webV.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        _webView = webV;
    }
    return _webView;
}

- (UIWebView *)caculateWebView{
    if (!_caculateWebView) {
        MyWebView* webV = [[MyWebView alloc] initWithFrame:CGRectMake(-kMainScreenWidth, 64, kMainScreenWidth, 1)];
        webV.scrollView.contentInset = UIEdgeInsetsMake(0, 8, 0, 8);
        webV.backgroundColor = [UIColor whiteColor];
        webV.opaque = NO;
        webV.scrollView.backgroundColor = [UIColor whiteColor];
        webV.backgroundColor = [UIColor clearColor];
        //        webV.scrollView.bounces = NO;
        webV.scrollView.showsVerticalScrollIndicator = NO;
        webV.scrollView.showsHorizontalScrollIndicator = NO;
        [webV setDelegate:(id)self];
        webV.scalesPageToFit = YES;
        webV.delegate = self;
        //        webV.scrollView.scrollEnabled = NO;
        webV.contentMode = UIViewContentModeScaleAspectFit;
        webV.autoresizingMask=(UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth);
        [self.view addSubview:webV];
        //        self.view.userInteractionEnabled = YES;
        //        webV.scrollView.userInteractionEnabled= YES;
        //        webV.userInteractionEnabled = YES;
        //        [webV.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        _caculateWebView = webV;
    }
    return _caculateWebView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self layoutUI];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (!webView.canGoBack && [request.URL.absoluteString isEqualToString:@"about:blank"]) {
        _showTitleAndMore = YES;
        //        if (webView != self.caculateWebView){
        //            NSString* autoSizeString = @"<meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0\">";
        //            NSString* contentS = [autoSizeString stringByAppendingString:_recdDesdModel.recdDesc.content];
        //            [_caculateWebView loadHTMLString:contentS baseURL:nil];
        
        //        }
    }else {
        _showTitleAndMore = NO;
        //        if (webView != self.caculateWebView)
        //            [_caculateWebView loadRequest:request];
    }
    BOOL status = [self checkRequest:request];
    return status;
}

- (void)leftBarButtonItemClick{
    if(!_showTitleAndMore && !_webView.canGoBack && ![_webView.request.URL.absoluteString isEqualToString:@"about:blank"]){
        
        if (_recdDesdModel.recdDesc.content.length > 0) {
            [_webView stopLoading];
            [_webView removeFromSuperview];
            [self removeObserver];
            //            [_webView.scrollView removeObserver:self
            //                                     forKeyPath:@"contentSize" context:nil];
            _webView = nil;
            //            self.webView.frame = CGRectMake(8, 0, kMainScreenWidth - 16, 1);
            NSString* autoSizeString = @"<meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0\">";
            NSString* contentS = [autoSizeString stringByAppendingString:_recdDesdModel.recdDesc.content];
            //        contentS = [contentS stringByAppendingString:@"<a href=\"https://www.baidu.com\">百度一下</a>"];
            
            [self.webView loadHTMLString:contentS baseURL:nil];
            [self addObserver];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        return;
    }
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}




- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}

/**
 *  判断请求内容
 */
- (BOOL)checkRequest:(NSURLRequest*)request{
    NSString *requestString = [[request URL] absoluteString];
    //    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    //    if ([components count] > 1 && [(NSString *)[components objectForIndex:0] isEqualToString:@"testapp"]) {
    //        if([(NSString *)[components objectForIndex:1] isEqualToString:@"build"])
    //        {
    //            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //            self.popGestureRecognizerEnable = YES;
    //            BuildingDetailViewController* bVC = [[BuildingDetailViewController alloc]init];
    //            bVC.buildingId = [components objectForIndex:2];
    
    //            [self.navigationController pushViewController:bVC animated:YES];
    
    //        }
    //        return NO;
    //    }
    
    
    if ([requestString rangeOfString:@"loupan"].length > 0) {
//        NSData *data=[NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
        NSRange startRange = [requestString rangeOfString:@"loupan%3E" options:NSCaseInsensitiveSearch];
        NSRange endRange = [requestString rangeOfString:@"%3C/loupan" options:NSCaseInsensitiveSearch];
        NSString* buildId = [requestString substringWithRange:NSMakeRange(startRange.location+ startRange.length, endRange.location  - startRange.location - startRange.length)];
        if (buildId.length > 0 && [buildId integerValue] > 0) {
            BuildingDetailViewController* bVC = [[BuildingDetailViewController alloc]init];
            bVC.buildingId = buildId;
            
            [self.navigationController pushViewController:bVC animated:YES];
        }
        
        return NO;
        //        NSRange
    }
    
    //    NSURL* url = [self smartURLForString:requestString];
    //    BOOL validUrl = [self isValidUrl:requestString];
    
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    self.listView.hidden = !_showTitleAndMore || _isSecondLoad;
    self.listView.hidden = YES;
    self.titleLabel.hidden = !_showTitleAndMore;
    self.createTimeLabel.hidden = !_showTitleAndMore;
    
    //    UIImageView* animV = [self setRotationAnimationWithView];
    //    _rotateAnimateView = animV;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (webView == _caculateWebView) {
        if (_caculateWebView) {
//            CGSize size = [_caculateWebView sizeThatFits:CGSizeMake(0, 0)];
        }
        
        //          _trueContentHeight = webView.scrollView.contentSize.height;
    }
    BOOL hasData = _recdDesdModel.relateRecd.count > 0;
    self.listView.hidden = !_showTitleAndMore || _isSecondLoad || !hasData;
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    height += 20;
    
    if (_rotateAnimateView) {
        [self removeRotationAnimationView:_rotateAnimateView];
    }
    
    [self layoutUI];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //js调用iOS
    //第一种情况
    //其中test1就是js的方法名称，赋给是一个block 里面是iOS代码
    //此方法最终将打印出所有接收到的参数，js参数是不固定的 我们测试一下就知道
    __weak typeof(self) weakSelf = self;
    context[@"luanchNativeShare"] = ^() {
        NSArray *args = [JSContext currentArguments];
        ShareModel* model = [[ShareModel alloc] init];
        model.content = @" ";
        if (args.count == 1) {
            JSValue* value = args.firstObject;
            
            model.linkUrl = value.toString;
        }else if(args.count == 2){
            JSValue* value1 = args.firstObject;
            JSValue* value2 = args.lastObject;
            model.linkUrl = value1.toString;
            model.title = value2.toString;
        }else if (args.count == 3){
            JSValue* value1 = args.firstObject;
            JSValue* value2 = [args objectForIndex:1];
            JSValue* value3 = args.lastObject;
            model.linkUrl = value1.toString;
            model.title = value2.toString;
            model.img = value3.toString;
        }else{
            return ;
        }
        [weakSelf shareWithModel:model];
    };
   
  
//    [context evaluateScript:@"shareWithUrl('www.baidu.com')"];
//    [context evaluateScript:@"luanchNativeShare('www.baidu.com','和谐号','http://avatar.csdn.net/1/3/6/1_lwjok2007.jpg')"];
//    [context evaluateScript:@"luanchNativeShare('http://www.baidu.com','和谐号')"];
}

- (void)shareWithModel:(ShareModel*)model{
    if (_shareView) {
        [_shareView removeFromSuperview];
    }
//    ShareActionSheet* shareView = [[ShareActionSheet alloc]initContentOperateWithShareType:WEBOPERATE andModel:model andParent:self.view];
    
    ShareActionSheet *shareView = [[ShareActionSheet alloc]initAutoShareViewWithShareRange:[UserData sharedUserData].shareRangeArray ShareType:CONTENTOPERATE andModel:model andParent:self.view];
    _shareView = shareView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    self.listView.frame = CGRectMake(0,scrollView.contentSize.height - scrollView.contentOffset.y + 64, kMainScreenWidth, 116);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    [super viewDidDisappear:animated];
    //    [self.webView loadRequest:nil];
    //    [self.webView removeFromSuperview];
    //    self.webView = nil;
    //    self.webView.delegate = nil;
    [self.webView stopLoading];
    
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.text = @"标题";
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        [self.view addSubview:label];
        _titleLabel  = label;
    }
    if (_recdDesdModel.recdDesc.title.length > 0) {
        _titleLabel.text = _recdDesdModel.recdDesc.title;
    }
    return _titleLabel;
}

- (UILabel *)createTimeLabel{
    if (!_createTimeLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.text = @"时间";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"#777777"];
        [self.view addSubview:label];
        _createTimeLabel = label;
    }
    if (_recdDesdModel.recdDesc.createTime.length > 0) {
        _createTimeLabel.text = _recdDesdModel.recdDesc.createTime;
    }
    return _createTimeLabel;
}

//计算ui，
- (void)layoutUI{
    [self removeObserver];//移除监听，修改frame，
    [self.webView.scrollView addSubview:self.listView];
    [self.webView.scrollView addSubview:self.titleLabel];
    [self.webView.scrollView addSubview:self.createTimeLabel];
    //    CGSize wsize =[_webView sizeThatFits:CGSizeMake(_webView.frame.size.width, 1)];
    UIView* browserV = self.webView.scrollView.subviews[0];
    
    CGFloat height = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    //    CGFloat bodyH = [[_webView stringByEvaluatingJavaScriptFromString:@"(document.height !== undefined) ? document.height : document.body.offsetHeight;"] floatValue];
    
    if (_showTitleAndMore) {
        CGSize tSize = [self.titleLabel.text sizeWithfont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(kMainScreenWidth - 32, MAXFLOAT)];
        CGSize mSize = [self.createTimeLabel.text sizeWithfont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(kMainScreenWidth - 32, MAXFLOAT)];
        self.titleLabel.frame = CGRectMake(8,15, tSize.width, tSize.height);
        self.createTimeLabel.frame = CGRectMake(8, CGRectGetMaxY(_titleLabel.frame) + 15,mSize.width, mSize.height);
        
        NSLog(@"----%f",_webView.scrollView.contentSize.height);
        
        CGFloat listVH = 0;
        if (_recdDesdModel.relateRecd.count > 0) {
            listVH =  [RecommendNewsListView heightWithRelateArray:_recdDesdModel.relateRecd];
        }
        
        CGFloat headH = CGRectGetMaxY(_createTimeLabel.frame) + 8;
        if(_isSecondLoad){
            self.listView.frame = CGRectZero;
            listVH = 0;
        }else{
            if (_recdDesdModel.relateRecd.count > 0) {
                //                    self.listView.frame = CGRectMake(0, CGRectGetMaxY(_webView.frame), kMainScreenWidth, [RecommendNewsListView heightWithRelateArray:_recdDesdModel.relateRecd]);
                self.listView.frame=  CGRectMake(-8, height + headH, kMainScreenWidth , listVH );
            }else{
                //                    self.contentScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_webView.frame));
                
            }
        }
        CGRect bframe = browserV.frame;
        bframe.origin.y = headH;
        browserV.frame = bframe;
        _webView.scrollView.contentSize = CGSizeMake(0, height + listVH + headH);
        //            _webView.scrollView.delegate = self;
    }else{
        //            self.webView.frame = CGRectMake(8,0, kMainScreenWidth - 16, height);
        //            self.listView.frame = CGRectZero;
        CGRect bframe = browserV.frame;
        bframe.origin.y = 0;
        browserV.frame = bframe;
        _webView.scrollView.contentSize = CGSizeMake(0, height);
    }
    
    [self addObserver];
    
}
- (UIButton *)shareButton{
    if (!_shareButton) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kMainScreenWidth-44, 20, 44, 44);
        [self.navigationBar addSubview:btn];
        _shareButton = btn;
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"iconfont-fenxiang-2"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"iconfont-fenxiang-2-down"] forState:UIControlStateSelected];
    }
    return _shareButton;
}

- (RecommendNewsListView *)listView{
    if (!_listView) {
        __weak typeof(self) weakSelf = self;
        RecommendNewsListView* listV = [[RecommendNewsListView alloc]initWithCallBack:^(RecommendNewsListView *view, RecommendNewsListViewEventType event,XTOperationModelItem *model) {
            switch (event) {
                case RecommendNewsListViewEventMore:
                {
                    XTOperationListController* listVC = [[XTOperationListController alloc]init];
                    listVC.requestType = weakSelf.itemModel.type;
                    listVC.navTitle = @"相关推荐";
                    [weakSelf.navigationController pushViewController:listVC animated:YES];
                    
                }
                    break;
                case RecommendNewsListViewEventClick:{
                    if (model) {
                        XTWebNavigationControler* wNav = [[XTWebNavigationControler alloc]init];
                        model.type = weakSelf.itemModel.type;
                        //                        model.imgUrl = weakSelf.itemModel.imgUrl;
                        if (model.imgUrl.length <= 0) {
                            model.imgUrl = weakSelf.itemModel.imgUrl;
                        }
                        if (model.imgUrl.length <= 0) {
                            model.imgUrl = weakSelf.itemModel.imgUrl;
                        }
                        wNav.itemModel = model;
                        wNav.isSecondLoad = YES;
                        wNav.showTitleAndMore = YES;
                        wNav.titleString = model.title;
                        [weakSelf.navigationController pushViewController:wNav animated:YES];
                    }
                }
                    break;
                default:
                    break;
            }
            
        }];
        [self.view addSubview:listV];
        _listView = listV;
        listV.userInteractionEnabled = YES;
    }
    if (_recdDesdModel.relateRecd.count > 0) {
        _listView.relateRecdArray = _recdDesdModel.relateRecd;
    }
    return _listView;
}


- (void)addObserver{
    if (_webView) {
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    
}

- (void)removeObserver{
    if (_webView) {
        [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    }
}


- (BOOL)isValidUrl:(NSString*)urlStr
{
    if(urlStr == nil)
        return NO;
    NSString *url;
    if (urlStr.length>4 && [[urlStr substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",self];
    }
    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}

//parseHTML
- (void)parseXMLWithString:(NSString*)htmlStr{
    NSData* data = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple* thppleParse = [[TFHpple alloc]initWithHTMLData:data];
    
    NSArray* dataArray = [thppleParse searchWithXPathQuery:@"//p"];
    
    NSString* content = @"";
    for (TFHppleElement* element in dataArray) {
        content = element.content;
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (content.length > 0) {
            break;
        }
    }
    self.subTitle = content;
}

- (void)fliterContent:(NSString*)content{
    NSMutableArray* contentArray = [NSMutableArray arrayWithArray:[self.recdDesdModel.recdDesc.contentNotag componentsSeparatedByString:@"\t"]];
    //    self.recdDesdModel.recdDesc.imageUrl = smallImgUrl(self.recdDesdModel.recdDesc.imageUrl);
    if(contentArray.count <= 0)return;
    for (int i = 0; i < contentArray.count; i++) {
        NSString* subStr = [contentArray objectForIndex:i];
        if ([subStr isKindOfClass:[NSString class]]) {
            if ([subStr rangeOfString:@"img"].length != 0) {
                [contentArray removeObjectForIndex:i];
            }
        }else{
            [contentArray removeObjectForIndex:i];
        }
    }
    
    
    if (contentArray.count >= 1) {
        self.subTitle = [contentArray firstObject];
    }
    
}


#pragma mark - 分享按钮点击
- (void)shareBtnClick:(UIButton*)btn{
    ShareModel* model = [[ShareModel alloc]init];
    model.img = _recdDesdModel.recdDesc.imageUrl;
    model.linkUrl = _recdDesdModel.shareUrl;
    model.title = _recdDesdModel.recdDesc.title;
    model.content = self.subTitle;
    
    if (_shareView) {
        [_shareView removeFromSuperview];
    }
//    ShareActionSheet* shareView = [[ShareActionSheet alloc]initContentOperateWithShareType:CONTENTOPERATE andModel:model andParent:self.view];
//    _shareView = shareView;
    ShareActionSheet* shareView = [[ShareActionSheet alloc]initAutoShareViewWithShareRange:[UserData sharedUserData].shareRangeArray ShareType:CONTENTOPERATE andModel:model andParent:self.view];
    
    _shareView = shareView;

}

- (NSString*)extensionUrlWithUrlStr:(NSString*)urlStr{
    NSString* userID = [NSString encodeBase64String:[UserData sharedUserData].userInfo.userId];
    NSString* cityID = [NSString encodeBase64String:[UserData sharedUserData].cityId];
    NSString* phone  = [NSString encodeBase64String:[UserData sharedUserData].userInfo.mobile];
    if ([urlStr rangeOfString:@"?"].length > 0) {
        urlStr = [urlStr stringByAppendingString:@"&"];
    }else{
        urlStr = [urlStr stringByAppendingString:@"?"];
    }
    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"userid=%@",userID]];
    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&phone=%@",phone]];
    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&city_id=%@",cityID]];
    return urlStr;
}

- (void)dealloc{
    if (_webView) {
        //        [_webView.scrollView removeObserver:self
        //                                 forKeyPath:@"contentSize" context:nil];
    }
    [self removeObserver];
}

@end
