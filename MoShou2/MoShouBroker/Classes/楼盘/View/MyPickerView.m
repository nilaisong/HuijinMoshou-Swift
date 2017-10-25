//
//  MyPickerView.m
//  MoShou2
//
//  Created by strongcoder on 15/12/21.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MyPickerView.h"

@implementation MyPickerView 
{
    UIPickerView * _pickerView;
    NSMutableArray *_dataSource;
    
    
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(id)initWithpickerStyle:(MyPickerViewStyle)pickerViewStyle;

{
    
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];

    if (self) {
        self.pickerViewStyle = pickerViewStyle;
        
        
        [self loadUI];
    }
    
    return self;
}



-(void)loadUI
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-(46*5), kMainScreenWidth, 46)];
    if (self.pickerViewStyle == MyPickerViewYearsStyle) {
        titleLabel.text = @"按揭年限";
        _nomoreSelectString = @"16年";
        _dataSource = [NSMutableArray array];
        
        for (NSInteger i = 1; i < 31 ; i++)
        {
            NSString *string = [NSString stringWithFormat:@"年限%zd年",i];

            [_dataSource appendObject:string];
        }
        

    }else if (self.pickerViewStyle == MyPickerViewShouFuBiStyle )
    {
        titleLabel.text = @"首付比";
        _nomoreSelectString = @"首付比";
        _dataSource = [NSMutableArray array];
        for (NSInteger i = 1; i < 10 ; i++)
        {
            NSString *string = [NSString stringWithFormat:@"%zd成",i];
            
            [_dataSource appendObject:string];
        }
        [_dataSource insertObject:@"首付比" forIndex:0];
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT(16.f);
    titleLabel.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    [self addSubview:titleLabel];
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
    _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _pickerView.frame = CGRectMake(0, kMainScreenHeight-(46*4), kMainScreenWidth, 46*3);
    _pickerView.delegate =self;
    _pickerView.dataSource = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.showsSelectionIndicator = YES;
    
    if (self.pickerViewStyle == MyPickerViewYearsStyle){
        
        [_pickerView selectRow:_dataSource.count/2 inComponent:0 animated:YES];

    }else if (self.pickerViewStyle == MyPickerViewShouFuBiStyle ){
        [_pickerView selectRow:0 inComponent:0 animated:YES];

    }

    [self addSubview:_pickerView];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-46, kMainScreenWidth, 46)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    for (NSInteger i  = 0; i < 2; i ++)
    {
        
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = [UIColor whiteColor];
        button.frame = CGRectMake(i*(kMainScreenWidth/2), kMainScreenHeight-46, kMainScreenWidth/2-0.5, 46);
        [button setTitle:i==0?@"取消":@"确定" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        [button setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
        button.tag = 8900+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        if (i==1)
        {
            UILabel *hengLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-47, kMainScreenWidth, 0.5)];
            hengLineLabel.backgroundColor = LINECOLOR;
            [self addSubview:hengLineLabel];
            
            UILabel *shuLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth/2, kMainScreenHeight-46, 0.5, 46)];
            shuLineLabel.backgroundColor = LINECOLOR;
            [self addSubview:shuLineLabel];
        }
        
    }
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfClickTap)];
    
    [self addGestureRecognizer:tap];
    
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return _dataSource.count;
    
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return _dataSource [row];
    
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    
    return 44.0;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    DLog(@"%@",_dataSource[row]);
    
    _nomoreSelectString =_dataSource[row];
    
}

-(void)selfClickTap
{
    
    if ([self.delegate respondsToSelector:@selector(tapBgViewAndCancel:)])
    {
        [self.delegate tapBgViewAndCancel:self];
    }
    
    [self removeView];
    
}

-(void)buttonClick:(UIButton *)sender
{
    
    if (sender.tag == 8900)
    {
        if ([self.delegate respondsToSelector:@selector(tapBgViewAndCancel:)])
        {
            [self.delegate tapBgViewAndCancel:self];
            
        }
        DLog(@"取消");
       [self removeView];
        
    }else
    {
        DLog(@"确定");
        if ([self.delegate respondsToSelector:@selector(determineBtnClick:WithChooseString:)])
        {
            [self.delegate determineBtnClick:self WithChooseString:_nomoreSelectString];
        }

        [self removeView];

    }
    
    
}

-(void)removeView
{
    if (self)
    {
        [self removeFromSuperview];
        
    }

    
    
    
}


@end
