//
//  SelectionView.m
//  MoShou2
//
//  Created by strongcoder on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "SelectionView.h"
#import "OptionData.h"
#import "MyButton.h"
#import "NSString+Extension.h"


@implementation SelectionView
{
    
    NSInteger _selectIndex;
    NSArray *_titleArr;
    
    NSMutableArray *_tempArr; //临时数组
    NSMutableArray *_secondTempArr; //二级 临时数组

    
    CityFirstResult * _cityFirstResult;//楼盘页面初始化的数据
    
    NSMutableArray * _btnArray;  //存放button 的数组
    NSMutableArray * _districtArr;  //区域 商圈
    NSMutableArray * _featureArr;  //特色标签
    NSMutableArray * _acreageArr;  //面积
    NSMutableArray * _priceTypesArr;  //价格排序
    CGFloat _tableViewHeight;
    
    BOOL _showMapSecondTableView;//是否展示第二个
    
    NSDictionary *_moreDic;
    
    BOOL _isMapSeleView;
    
    NSString *_tableViewSelectString;
    
    
    NSInteger _lastIndexPath;  //
    
    NSMutableDictionary * _selectDic;
    
    
}

-(id)initWithFrame:(CGRect)frame WithBuildingsResult:(CityFirstResult *)cityFirstResult WithIsMapSeleView:(BOOL )isMapSeleView;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _selectIndex = -1;
        _cityFirstResult = cityFirstResult;
        _tempArr = [NSMutableArray array];
        _secondTempArr = [NSMutableArray array];
        _btnArray = [NSMutableArray array];
        _isMapSeleView = isMapSeleView;
        _districtArr =[NSMutableArray array];
        _featureArr = [NSMutableArray array];
        _acreageArr = [NSMutableArray array];
        _priceTypesArr = [NSMutableArray array];
        
        _selectDic = [NSMutableDictionary dictionary];
        [self loadUI];
        [self customPriceView];
        [self moreChooseView];
    }
    
    return self;
}

-(void)loadUI
{
    _titleArr = @[@"区域",@"单价",@"面积",@"更多"];
    _tableViewHeight = kMainScreenHeight - 64 - 74/2;

    ItemData *data0;

    if (_isMapSeleView) {
        //区域的
        ItemData *districtData  = [[ItemData alloc]init];
        districtData.itemID = @"";
        districtData.itemName = @"区域";
        NSMutableArray *array = [NSMutableArray array];
        ItemData *data =[[ItemData alloc]init];
        data.itemID = @"";
        data.itemName = @"不限";
        data.longitude = @"";
        data.latitude = @"";
        [array appendObject:data];
        for ( DistrictModel *disModel in _cityFirstResult.districts) {
          
            ItemData *data =[[ItemData alloc]init];
            data.itemID = disModel.districtId;
            data.itemName = disModel.name;
            data.longitude = disModel.longitude;
            data.latitude = disModel.latitude;
            if (data.itemName.length > 0) {
                [array appendObject:data];
            }
        }
        districtData.platLists =array;
        [_districtArr appendObject:districtData];
       //附近
        ItemData *vicinitItemData = [[ItemData alloc]init];
        vicinitItemData.itemID = @"";
        vicinitItemData.itemName = _cityFirstResult.vicinity.name.length <= 0?@"附近":_cityFirstResult.vicinity.name;
        NSMutableArray *vicinitarray = [NSMutableArray array];
        ItemData *xdata = [[ItemData alloc]init];
        xdata.itemID = @"";
        xdata.itemName = @"不限";
        [vicinitarray appendObject:xdata];
        for (SysDic *sys in _cityFirstResult.vicinity.sysDics) {
            ItemData *data = [[ItemData alloc]init];
            data.itemID = sys.code;
            data.itemName = sys.label;
            if (data.itemName.length > 0) {
                [vicinitarray appendObject:data];
            }
        }
        vicinitItemData.platLists  = vicinitarray;
        [_districtArr appendObject:vicinitItemData];

        data0 =[[ItemData alloc]init];
        data0.itemName = @"不限";
        data0.itemID = @"";
//        [_districtArr insertObject:data0 forIndex:0];
   
    }else{
        
        for ( DistrictModel *disModel in _cityFirstResult.districts) {
            ItemData *data =[[ItemData alloc]init];
            data.itemID = disModel.districtId;
            data.itemName = disModel.name;
            NSMutableArray *templistArr = [NSMutableArray array];
            ItemData *platData0;
            NSInteger allNumbel = 0;
            for (PlatList *listData in disModel.platLists)
            {
                ItemData *platData =[[ItemData alloc]init];
                platData.itemID = listData.listId;
                platData.itemName =[NSString stringWithFormat:@"%@(%@)",listData.name,listData.estateCount] ;
                allNumbel= allNumbel+[listData.estateCount integerValue];
                [templistArr appendObject:platData];
                platData.longitude = listData.longitude;
                platData.latitude = listData.latitude;
            }
            platData0 = [[ItemData alloc]init];
            if (disModel.estateCount.length>0) {
                platData0.itemName = [NSString stringWithFormat:@"不限(%@)",disModel.estateCount];
            }else{
                platData0.itemName = [NSString stringWithFormat:@"不限"];
#warning 这里如果后台数据正常后  需要注释掉  不用自己手动加总数
                //            platData0.itemName = [NSString stringWithFormat:@"不限(%zd)",allNumbel];
            }
            platData0.itemID = disModel.districtId;  //次级 目录  选不限的话   上传的ID 为父级别目录的id
            
            [templistArr insertObject:platData0 forIndex:0];
            
            data.platLists = [NSArray arrayWithArray:templistArr];
            
            [_districtArr appendObject:data];
        }
        data0 =[[ItemData alloc]init];
        data0.itemName = @"不限";
        data0.itemID = @"";
        [_districtArr insertObject:data0 forIndex:0];
        
        
    }
    
  

    
    Standard *standard = _cityFirstResult.feature;
    
    for (SysDic *sys in standard.sysDics) {
        
        ItemData *data = [[ItemData alloc]init];
        
        data.itemID = sys.code;
        data.itemName = sys.label;
        
        [_featureArr appendObject:data];
    }
//    if(!_isMapSeleView)
    [_featureArr insertObject:data0 forIndex:0];
    
    Standard *acreageStandard = _cityFirstResult.acreage;
    for (SysDic *sys in acreageStandard.sysDics) {
        ItemData *data = [[ItemData alloc]init];
        data.itemID = sys.code;
        data.itemName = sys.label;
        [_acreageArr appendObject:data];
    }
    [_acreageArr insertObject:data0 forIndex:0];
    
    for (OptionData *optionData in _cityFirstResult.priceTypes) {
        
          ItemData *data = [[ItemData alloc]init];
        
        data.itemName =optionData.itemName;
        data.itemID = optionData.itemValue;
        [_priceTypesArr appendObject:data];
    }
    [_priceTypesArr insertObject:data0 forIndex:0];

//    _tempArr = _buildResult.areas;
//    
//    DLog(@"%zd",_buildResult.acreageTypes.count);
   
       for (NSInteger i = 0; i < 4; i ++)
    {
        
        MyButton *chooseBtn = [[MyButton alloc]initWithFrame:CGRectMake((kMainScreenWidth/4)*i, 0, kMainScreenWidth/4, 74/2)];
        [chooseBtn setTitle:_titleArr[i] forState:UIControlStateNormal];
        chooseBtn.titleLabel.font = FONT(13.f);
        [chooseBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [chooseBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateSelected];
        [chooseBtn setImage:[UIImage imageNamed:@"38-lan.png"] forState:UIControlStateSelected];
        [chooseBtn setImage:[UIImage imageNamed:@"38-副本.png"] forState:UIControlStateNormal];

        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        chooseBtn.tag = 8000+i;
        
        [_btnArray appendObject:chooseBtn];
        
        [self addSubview:chooseBtn];
        if (i < 3)
        {
            UILabel *verticalLineLabel = [[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth/4)*(i+1), 8, 0.7, 74/2-8*2)];
            verticalLineLabel.backgroundColor = LINECOLOR;
            verticalLineLabel.alpha = 0.8;
            [self addSubview:verticalLineLabel];
        }
    }
    UILabel *linellabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 74/2-1, kMainScreenWidth, 1)];
    linellabel.backgroundColor = LINECOLOR;
    [self addSubview:linellabel];
    
}


-(void)chooseBtnClick:(UIButton *)sender
{
    _showMapSecondTableView = YES;
    switch (sender.tag) {
        case 8000:
        {
            _tempArr = _districtArr;
            /**
             *  二级数组初始值
             */
            ItemData *data = _districtArr[0];
            _secondTempArr = [NSMutableArray arrayWithArray:data.platLists];
            _showMapSecondTableView = YES;
        }
            break;
            case 8001:
        {
            _tempArr = _priceTypesArr;
 
        }
            break;
            case 8002:
        {
            _tempArr = _acreageArr;
 
        }
            break;
            case 8003:
        {
        }
            break;
            
        default:
            break;
    }
    
    
    sender.selected = !sender.selected;
    self.isTableViewOpen = sender.selected;

    if (_selectIndex!=sender.tag)
    {

        UIButton *lastBtn = (UIButton *)[self viewWithTag:_selectIndex];
        if (lastBtn.selected)
        {
            lastBtn.selected = !lastBtn.selected;
        }
    }
    _selectIndex = sender.tag;
    
    DLog(@"%f,%f %zd ",sender.titleLabel.width,sender.imageView.width,_selectIndex);
    
    
    
    [self addTableView];
    [self.tableView reloadData];
    [self.secondTableView reloadData];
    
    if (_isMapSeleView && sender.tag == 8000 && sender.selected) {
        NSIndexPath* indexP = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView selectRowAtIndexPath:indexP animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
//    if (_selectIndex == 8000) {
//        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [_tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    }
    
}

-(void)addTableView
{
    if (_bgView == nil)
    {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+74/2, kMainScreenWidth, kMainScreenHeight)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.5;
        _bgView.userInteractionEnabled = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewClick)];
        [_bgView addGestureRecognizer:tap];
    }
    
    if (_selectIndex == 8000) {
        
        if (_tableView == nil)
        {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+74/2, kMainScreenWidth/3, _tableViewHeight) style:UITableViewStylePlain];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.tableFooterView = [[UIView alloc] init];

            [[UIApplication sharedApplication].keyWindow addSubview:_tableView];
            
        }else{
            _tableView.width = kMainScreenWidth/3;
            _secondTableView.width = kMainScreenWidth/3*2;
        }
        if (_secondTableView == nil) {
            _secondTableView = [[UITableView alloc]initWithFrame:CGRectMake(kMainScreenWidth/3, 64+74/2, (kMainScreenWidth/3)*2, _tableViewHeight) style:UITableViewStylePlain];
            _secondTableView.delegate =self;
            _secondTableView.dataSource = self;
            _secondTableView.backgroundColor = BACKGROUNDCOLOR;
//            [_secondTableView setSeparatorColor:[UIColor whiteColor]];

            _secondTableView.tableFooterView = [[UIView alloc] init];

            [[UIApplication sharedApplication].keyWindow addSubview:_secondTableView];
        }else{
            _tableView.width = kMainScreenWidth/3;
            _secondTableView.width = kMainScreenWidth/3*2;
        }
        
    }else{
        
        if (_tableView == nil)
        {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+74/2, kMainScreenWidth, _tableViewHeight) style:UITableViewStylePlain];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.tableFooterView = [[UIView alloc] init];
            [[UIApplication sharedApplication].keyWindow addSubview:_tableView];
            
        }else{
            _tableView.width = kMainScreenWidth;

        }
        _secondTableView.width = 0;
    }
    
       if (self.isTableViewOpen)
    {
        [self setTableViewOpen];
    
    }else
    {
        [self setTableViewClose];
    }
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([self.secondTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.secondTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.secondTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.secondTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)bgViewClick
{
    UIButton *button = (UIButton*)[self viewWithTag:_selectIndex];
    button.selected = !button.selected;
    [self setTableViewClose];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex == 8001) {
        if (indexPath.row == _tempArr.count) {
            return 166/2;
        }else{
            return 74/2;
        }
    
    }else if(_selectIndex == 8003) {
        
        return self.tableView.height;
    }else{
        return 74/2;
   
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _showMapSecondTableView = YES;
    if (tableView == _tableView) {
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (_selectIndex == 8001) {
            
            if (indexPath.row == _tempArr.count) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:_customPriceView];
                
            }else{
                if (_tempArr.count>0) {
                    ItemData *data = _tempArr[indexPath.row];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",data.itemName];
                    cell.textLabel.font = FONT(13.f);
                    NSString *priceValue = [_selectDic valueForKey:@"price"];
                    
                    if ([priceValue isEqualToString:data.itemName]) {
                        cell.textLabel.textColor = BLUEBTBCOLOR;
                    }
                    
                    
                    
                }
            }
            
        }else if(_selectIndex == 8003){
            
            [cell.contentView addSubview:self.moreChooseView];
            
        }else if (_selectIndex == 8002){
            
            if (_tempArr.count>0)
            {
                
                ItemData *data = _tempArr[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",data.itemName];
                cell.textLabel.font = FONT(13.f);
                NSString *string = [_selectDic valueForKey:@"acreage"];
                if ([string isEqualToString:data.itemName]) {
                    cell.textLabel.textColor = BLUEBTBCOLOR;
                }
            }
            
        }else{

            if (_tempArr.count>0)
              {
                
                ItemData *data = _tempArr[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",data.itemName];
                cell.textLabel.font = FONT(13.f);
                  NSString *string = [_selectDic valueForKey:@"firstTableViewSelect"];
                  if ([string isEqualToString:data.itemName]) {
                      cell.textLabel.textColor = BLUEBTBCOLOR;
                      
                      _secondTempArr = [NSMutableArray arrayWithArray:data.platLists];
                      [_secondTableView reloadData];
                  }
                  if (string.length==0 && indexPath.row == 0 && [data.itemName isEqualToString:@"区域"]) {
                      cell.textLabel.textColor = BLUEBTBCOLOR;
                      _tableViewSelectString = @"区域";
                  }
              }
            }
    
        return cell;
    }else if (tableView == _secondTableView){
        
      
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (_secondTempArr.count>0) {
                ItemData *data = _secondTempArr[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",data.itemName];
                cell.textLabel.font = FONT(13.f);
            
            NSString *firstString = [_selectDic valueForKey:@"firstTableViewSelect"];
            NSString *secondString = [_selectDic valueForKey:@"secondTableViewSelect"];
            
            //当前选中的data
            ItemData *firstSelectData = _tempArr[_lastIndexPath];
            
            if ( [firstSelectData.itemName isEqualToString:firstString]) {
                //
                if ([secondString isEqualToString:data.itemName]) {
                    
                    cell.textLabel.textColor = BLUEBTBCOLOR;
                }
            }
        }            return cell;
    }
    
    UITableViewCell *noCell;
    return noCell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (tableView == _tableView) {
        
        if (_selectIndex == 8001) {
            
            return _tempArr.count+1;

        }else if(_selectIndex==8003){
        
            return 1;
        }else {
            return _tempArr.count;

        }

    }else if (tableView == _secondTableView){
        return _showMapSecondTableView?_secondTempArr.count:0;
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UIButton *button = (UIButton*)[self viewWithTag:_selectIndex];
    ItemData *data;
  
    //自定义价格筛选单独处理
    if (_selectIndex == 8001 && indexPath.row == _tempArr.count) {
        data = _tempArr[indexPath.row];

        
        return;
    }
    
    if (tableView == _tableView) {
        data = _tempArr[indexPath.row];
        
        if (_selectIndex == 8001) {
            [_selectDic setValue:data.itemName forKey:@"price"];
        }
        
        if (_selectIndex == 8002) {
            [_selectDic setValue:data.itemName forKey:@"acreage"];
        }
        
        if (_selectIndex == 8000) {
          
            
            if ([data.itemName isEqualToString:@"不限"]){
                button.selected = !button.selected;
                [_selectDic setValue:data.itemName forKey:@"firstTableViewSelect"];

                [button setTitle:_titleArr[_selectIndex-8000] forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"38-副本.png"] forState:UIControlStateNormal];
                [self setTableViewClose];
                if ([self.delegate respondsToSelector:@selector(select:withchooseIndex:AndOptionData:AndPriceModel:)])
                {
                    [self.delegate select:self withchooseIndex:_selectIndex-8000 AndOptionData:data AndPriceModel:nil];
                }
 
            }else{
                
                _tableViewSelectString = data.itemName;
                
                    NSIndexPath *index =[NSIndexPath indexPathForRow:_lastIndexPath inSection:0];
                    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:index];
                    lastCell.textLabel.textColor = [UIColor blackColor];
                
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.textLabel.textColor = BLUEBTBCOLOR;
                _lastIndexPath = indexPath.row;
                
                _secondTempArr = [NSMutableArray arrayWithArray:data.platLists];
                [_secondTableView reloadData];
            }
            
        }else  {
            
            button.selected = !button.selected;
            if ([data.itemName isEqualToString:@"不限"]){
                [button setTitle:_titleArr[_selectIndex-8000] forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"38-副本.png"] forState:UIControlStateNormal];
                [self cleanTextFiledContent];

            }else if([data.itemName isEqualToString:@"价格从高到低"])
            {
                [button setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"38-lan-xia.png"] forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@",@"单价"] forState:UIControlStateNormal];
                [self cleanTextFiledContent];

            }else if([data.itemName isEqualToString:@"价格从低到高"]){
                [button setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"38-lan.png"] forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@",@"单价"] forState:UIControlStateNormal];
                [self cleanTextFiledContent];

            }else{
                [button setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"38-lan-xia.png"] forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@",data.itemName] forState:UIControlStateNormal];
            }
            [self setTableViewClose];
            
            if ([self.delegate respondsToSelector:@selector(select:withchooseIndex:AndOptionData:AndPriceModel:)])
            {
                [self.delegate select:self withchooseIndex:_selectIndex-8000 AndOptionData:data AndPriceModel:nil];
            }
            
        }

    }else if (tableView == _secondTableView){
        button.selected = !button.selected;
        ItemData *secondData = _secondTempArr[indexPath.row];
       
        //点击第二列表的时候  存储 选择的两项内容
        ItemData * firstTableSelectdata = _tempArr[_lastIndexPath];
        [_selectDic setValue:firstTableSelectdata.itemName forKey:@"firstTableViewSelect"];
       
        [_selectDic setValue:secondData.itemName forKey:@"secondTableViewSelect"];
        
        if ([secondData.itemName rangeOfString:@"不限"].location != NSNotFound){
            
            for ( ItemData *tempData in _tempArr) {
                
                if (tempData.itemID == secondData.itemID) {
                    [button setTitle:tempData.itemName forState:UIControlStateNormal];
                }
            }
            
        }else{
            [button setTitle:secondData.itemName forState:UIControlStateNormal];

        }
        [button setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"38-lan-xia.png"] forState:UIControlStateNormal];

        [self setTableViewClose];
        
        if (_isMapSeleView) {
            if ([secondData.itemName rangeOfString:@"不限"].location != NSNotFound){
                button.selected = NO;
                
                if (_lastIndexPath == 0) {
                    [button setTitle:@"区域" forState:UIControlStateNormal];
  
                }else if(_lastIndexPath == 1){
                    [button setTitle:@"附近" forState:UIControlStateNormal];
 
                }
                
                [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"38-副本.png"] forState:UIControlStateNormal];
            }
            if ([self.delegate respondsToSelector:@selector(select:withchooseString:AndOptionData:)]) {
                
                [self.delegate select:self withchooseString:_tableViewSelectString AndOptionData:secondData];
            }
            
        }else{
            
            
            if ([self.delegate respondsToSelector:@selector(select:withchooseIndex:AndOptionData:AndPriceModel:)])
            {
                [self.delegate select:self withchooseIndex:_selectIndex-8000 AndOptionData:secondData AndPriceModel:nil];
            }

            
            
        }
        
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
//    {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
//    {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

-(void)setTableViewClose
{
    [_tableView setHeight:0];
    [_secondTableView setHeight:0];
    [self setHeight:74/2];
    [self.bgView setHeight:0];
    
    [self resignTextFiledFirstResponder];
    
    
//    if (_secondTempArr.count>0) {
//        [_secondTempArr removeAllObjects];
//    }
    
//    if (_selectIndex == 8000) {
//        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [_tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
//    }
    
}

-(void)setTableViewOpen
{
    [_tableView reloadData];
    if (_selectIndex == 8000 || _selectIndex == 8003) {
        
        [_tableView setHeight:_tableViewHeight];
        [_secondTableView setHeight:_tableViewHeight];
    }else{
        [_tableView setHeight:_tableView.contentSize.height];
        [_secondTableView setHeight:_secondTableView.contentSize.height];
        
    }
    
    [self setHeight:kMainScreenHeight-74/2-64];
    [self.bgView setHeight:kMainScreenHeight-74/2-64];
    [_tableView reloadData];
    [_secondTableView reloadData];

}

-(void)setSelectBtnStateNormal
{
    if (_btnArray.count>0) {
        for (NSInteger i = 0; i < _btnArray.count; i ++) {
            
            MyButton *button = _btnArray[i];
            button.selected = NO;
            [button setTitleColor:UIColorFromRGB(0x333333)forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"38-副本.png"] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"%@",_titleArr[i]] forState:UIControlStateNormal];
        }
        
 
    }
    [self setTableViewClose];

}

-(UIView*)customPriceView
{
    if (!_customPriceView) {
        
        _customPriceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 166/2)];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 25/2, 180, 14)];
        label.text = @"自定义单价";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = UIColorFromRGB(0x888888);
        label.font = FONT(13.f);
        
        [_customPriceView addSubview:label];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, label.bottom+15/2, kMainScreenWidth-20, 76/2)];
        bgView.backgroundColor = UIColorFromRGB(0xececec);
        [_customPriceView addSubview:bgView];
        
        
        self.firstTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, (bgView.width-10-15-15-20-30-10)/3 +20 , 55/2)];
        self.firstTF.backgroundColor =[UIColor whiteColor];             // UIColorFromRGB(0x333333);
        self.firstTF.delegate = self;
        self.firstTF.placeholder = @"最小";
        self.firstTF.keyboardType = UIKeyboardTypePhonePad;
        self.firstTF.layer.cornerRadius = 3;
        self.firstTF.textAlignment = NSTextAlignmentCenter;
        self.firstTF.layer.masksToBounds = YES;
        [bgView addSubview:_firstTF];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.firstTF.right+5, 20, 15, 2)];
        lineLabel.backgroundColor = [UIColor grayColor];
        [bgView addSubview:lineLabel];
        
        self.secondTF = [[UITextField alloc]initWithFrame:CGRectMake(lineLabel.right+5, 5, self.firstTF.width, 55/2)];
        self.secondTF.delegate =self;
        self.secondTF.backgroundColor =[UIColor whiteColor];             // UIColorFromRGB(0x333333);
        self.secondTF.placeholder = @"最大";
        self.secondTF.keyboardType =UIKeyboardTypePhonePad;
        self.secondTF.textAlignment = NSTextAlignmentCenter;
        self.secondTF.layer.cornerRadius = 3;
        self.secondTF.layer.masksToBounds = YES;
        [bgView addSubview:_secondTF];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.secondTF.right+20, 5, self.firstTF.width-20, 55/2)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:BLUEBTBCOLOR];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = FONT(14);
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
    }
    
    return _customPriceView;
}


-(MoreChooseView*)moreChooseView
{

    if (!_moreChooseView) {
        _moreChooseView = [[MoreChooseView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, _tableViewHeight) andCityFirstResult:_cityFirstResult];
        _moreChooseView.delegate = self;
        
    }else{
        
//        刷新状态即可
        [_moreChooseView refreshBtnStyleWithChooseDic:_moreDic];
        
    }

    return _moreChooseView;
}

#pragma mark - MoreChooseViewDelegate

-(void)didcommintBtnWithMoreChooseDic:(NSDictionary *)moreDic;
{
    UIButton *button = (UIButton*)[self viewWithTag:_selectIndex];
    button.selected = !button.selected;

    _moreDic = [NSDictionary dictionaryWithDictionary:moreDic];
    
    DLog(@" moreDic.allValues.count===%zd  ",moreDic.allValues.count);
    if (moreDic.allValues.count>0) {
        
        [button setTitle:[NSString stringWithFormat:@"更多(%zd)",moreDic.allValues.count/2] forState:UIControlStateNormal];
        [button setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"38-lan-xia.png"] forState:UIControlStateNormal];
    }else{
        [button setTitle:[NSString stringWithFormat:@"更多"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"38-副本.png"] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];

    }
    
    if ([self.delegate respondsToSelector:@selector(select:WithMoreChooseDic:WithCommitType:)]) {
        
        [self.delegate select:self WithMoreChooseDic:moreDic WithCommitType:CommitTypeStyle];
    }
    
    [self setTableViewClose];
    
}


-(void)btnClick:(UIButton *)sender
{
    PriceModel *priceModel = [[PriceModel alloc]init];
    
    NSString *showString;
    UIButton *chooseButton = (UIButton*)[self viewWithTag:_selectIndex];
    //点击   获取 第一个和第二个数字  然后 按照规则  拼接好放在上面Btn 显示 然后  把参数通过代理 传值出去   并且把窗口关闭即可
    NSInteger firstNum = [self.firstTF.text integerValue];
    NSInteger seconfNum = [self.secondTF.text integerValue];
    
    
    if (firstNum==0 && seconfNum == 0) {
        AlertShow(@"至少填写一项");
        return;

    }else if (firstNum==0 && seconfNum >0){
        
        //   0-----输入值
        showString = [NSString stringWithFormat:@"%zd~%zd",firstNum,seconfNum];
        priceModel.priceMax = [NSString stringWithFormat:@"%zd",seconfNum];

        
    }else if (firstNum>0 && seconfNum>0){
        
        if (firstNum > seconfNum) {
            
            AlertShow(@"最小值不能大于最大值");
            return;
            
        }else{
            
            //正常的两个值
            showString = [NSString stringWithFormat:@"%zd~%zd",firstNum,seconfNum];
            
            priceModel.priceMin = [NSString stringWithFormat:@"%zd",firstNum];
            priceModel.priceMax = [NSString stringWithFormat:@"%zd",seconfNum];

        }
        
        
    }else if (firstNum>0 && seconfNum == 0){
        
        // 输入值-----最大值
        showString = [NSString stringWithFormat:@"%zd~%@",firstNum,@"最大"];
        priceModel.priceMin = [NSString stringWithFormat:@"%zd",firstNum];

    }
    
    [_selectDic setValue:nil forKey:@"price"];
    chooseButton.selected = !chooseButton.selected;
    [self setTableViewClose];
    
    [chooseButton setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [chooseButton setImage:[UIImage imageNamed:@"38-lan-xia.png"] forState:UIControlStateNormal];
    [chooseButton setTitle:[NSString stringWithFormat:@"%@",showString] forState:UIControlStateNormal];
    
    [self.delegate select:self withchooseIndex:_selectIndex-8000 AndOptionData:nil AndPriceModel:priceModel];

}

-(void)resignTextFiledFirstResponder
{
    [self.firstTF resignFirstResponder];
    [self.secondTF resignFirstResponder];
}

-(void)cleanTextFiledContent
{
    self.firstTF.text = @"";
    self.secondTF.text = @"";
    
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    DLog(@"当前的文本内容===%@    即将出现的文本内容===%@",textField.text,string);
    if (![self isValidNumberWithString:string]) {
        return NO;
    }
    


    return YES;

}

- (BOOL)isValidNumberWithString:(NSString*)str {
    
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
    
}
-(void)setTableViewCloseAndNomalStyle
{
    
    [_tableView setHeight:0];
    [_secondTableView setHeight:0];
    [self setHeight:74/2];
    [self.bgView setHeight:0];
    
    [self resignTextFiledFirstResponder];
    if (_btnArray.count>0) {
        
        for (NSInteger i = 0; i < _btnArray.count; i ++) {
            
            MyButton *button = _btnArray[i];
            button.selected = NO;
            
        }

    }
    
}



@end
