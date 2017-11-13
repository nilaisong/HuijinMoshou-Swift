//
//  XTUserTableView.m
//  JZTableViewRowActionDemo
//
//  Created by xiaotei's on 15/12/10.
//  Copyright © 2015年 Jazys. All rights reserved.
//

#import "XTUserTableView.h"
#import "UITableViewRowAction+JZExtension.h"
#import "XTUserScheduleInfoCell.h"

@interface XTUserTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, copy) NSString *tableViewReuseIdentifier;
@end

@implementation XTUserTableView

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {

        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{

    

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XTUserScheduleInfoCell* cell = [XTUserScheduleInfoCell userScheduleInfoCellWithTableView:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self setEditing:false animated:true];
        NSLog(@"删除点击");
    };
    
       UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
    
    return @[action1];
}

#pragma mark - getters

- (NSArray *)models {
    if (!_models) {
        NSMutableArray *__models = [NSMutableArray array];
        for (int index = 0; index < 20; index++) {
            [__models addObject:[UIColor colorWithHue:arc4random() % 256 / 256.0 saturation:arc4random() % 128 / 256.0 brightness:arc4random() % 128 / 256.0 alpha:1]];
        }
        _models = __models;
    }
    return _models;
}


@end
