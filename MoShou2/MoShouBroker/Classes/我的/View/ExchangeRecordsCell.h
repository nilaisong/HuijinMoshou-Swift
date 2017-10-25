//
//  ExchangeRecordsCell.h
//  MoShou2
//
//  Created by Aminly on 16/1/26.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyImageView.h"
@interface ExchangeRecordsCell : UITableViewCell
@property(nonatomic,strong)MyImageView *exchangeImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *numLabel;//x1
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *coastLabel;
@property(nonatomic,strong)UILabel *statusLabel;
-(id)init;
@end
