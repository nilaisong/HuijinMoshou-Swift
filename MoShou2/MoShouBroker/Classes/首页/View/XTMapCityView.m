//
//  XTMapCityView.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTMapCityView.h"
#import "NSString+Extension.h"
#import "AutoLabel.h"

@interface XTMapCityView()


@property (nonatomic,weak)UILabel* titleLabel;

@property (nonatomic,weak)UILabel* subTitleLabel;

@property (nonatomic,weak)UIButton* clickButton;


@end

@implementation XTMapCityView
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        //        [self setBounds:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        [self setBounds:CGRectMake(0.f, 0.f, 60.f * SCALE6, 60.f * SCALE6)];
        self.backgroundColor = [UIColor colorWithHexString:@"37AEEE" alpha:0.9];
        self.layer.borderColor = [UIColor colorWithHexString:@"0069B1"].CGColor;
        //        self.clipsToBounds = YES;
        self.layer.cornerRadius = 60.0 * SCALE6 / 2.0;
        self.layer.borderWidth = 0.5;
        
        self.clickButton.frame = self.bounds;
        
        //阴影
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 2;
        
        CGFloat startY = (60* SCALE6 - 30)/2.0;
        
        CGSize textSize = [self.titleLabel.text sizeWithfont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        if (textSize.width > 56 * SCALE6) {
            NSInteger fontSize = (NSInteger)(12 * 60 * SCALE6 / textSize.width);
            fontSize = fontSize < 6?6:fontSize;
            self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        }
        
        CGSize subSize = [self.subTitleLabel.text sizeWithfont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        if (subSize.width > 56 * SCALE6) {
            NSInteger fontSize = (NSInteger)(12 * 60 * SCALE6 / subSize.width);
            fontSize = fontSize < 6?6:fontSize;
            self.subTitleLabel.font = [UIFont systemFontOfSize:fontSize];
        }
        
        self.titleLabel.frame = CGRectMake(2, startY, 56.0f * SCALE6, 13.0f);
        self.subTitleLabel.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + 4, 60.0f * SCALE6, 13.0f);
        
        
        self.userInteractionEnabled = YES;
        //        _annotationImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        //        _annotationImageView.contentMode = UIViewContentModeCenter;
        //        [self addSubview:_annotationImageView];
    }
    return self;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [label setText:@" "];
        [self addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [label setText:@" "];
        [self addSubview:label];
        _subTitleLabel = label;
    }
    return _subTitleLabel;
}

- (UIButton *)clickButton{
    if (!_clickButton) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _clickButton = btn;
        btn.userInteractionEnabled = NO;
    }
    return _clickButton ;
}

- (void)btnClick:(UIButton*)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(mapCityView:didSelected:)]) {
        [_delegate mapCityView:self didSelected:_cityModel];
    }
}

- (void)tapAction:(UITapGestureRecognizer*)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(mapCityView:didSelected:)]) {
        [_delegate mapCityView:self didSelected:_cityModel];
    }
}

- (void)setCityModel:(XTMapCityAnnotationModel *)cityModel{
    if (!cityModel) {
        return;
    }
    _cityModel = cityModel;
    
    _titleLabel.text = cityModel.cityName;
    
    _subTitleLabel.text = cityModel.numFound;
    
    [self setNeedsLayout];
}

//赋值后台传来的多层模型，进行解析
- (void)setMapCityInfoModel:(XTMapCityInfoModel *)mapCityInfoModel{
    if (!mapCityInfoModel) {
        return;
    }
    _mapCityInfoModel = mapCityInfoModel;
    XTMapCityAnnotationModel* cityAnnModel = [[XTMapCityAnnotationModel alloc]init];
    if (mapCityInfoModel.doclist.docs.count > 0) {
        cityAnnModel.numFound = mapCityInfoModel.doclist.numFound;
        XTMapDoc* cityDoc = [mapCityInfoModel.doclist.docs objectForIndex:0];
        cityAnnModel.cityName = cityDoc.cityName;
        CLLocationCoordinate2D coordinate;
        coordinate.longitude = [cityDoc.cityLongitude doubleValue];
        coordinate.latitude  = [cityDoc.cityLatitude doubleValue];
        cityAnnModel.coordinate = coordinate;
        cityAnnModel.cityId = cityDoc.cityId;
        [self setCityModel:cityAnnModel];
    }
}

@end
