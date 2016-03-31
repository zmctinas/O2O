//
//  MerchantDetailViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "MerchantDetailViewController.h"
#import "detailModel.h"
#import "merHdTableViewCell.h"
#import "commentTableViewCell.h"
#import "serviceTableViewCell.h"
#import "photoalbumViewController.h"
#import "UIColor+hexColor.h"
#import "detMsgViewController.h"
#import "commentModel.h"

@interface MerchantDetailViewController ()<UITableViewDelegate,UITableViewDataSource,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    NSString* commentNum;
    NSString* commentstars;
    NSString* ispage;
    NSString* nextpage;
    HTTPRequest* _request;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)UILabel* label;


@end

@implementation MerchantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableSource = [[NSMutableArray alloc]init];
    
    self.navigationItem.titleView = self.label;
    
    [self registercell];
    
    _request = [[HTTPRequest alloc]init];
    _request.delegate = self;
    NSDictionary* dic1 = [[NSDictionary alloc]initWithObjectsAndKeys:_comID,@"commid", nil];
    
    
    [_request requestWitUrl:COMMER_DET_IF andArgument:dic1 andType:WXHTTPRequestGet];
    
    
//    NSArray *familyNames = [UIFont familyNames];
//    for( NSString *familyName in familyNames ){
//        printf( "Family: %s \n", [familyName UTF8String] );
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
//        for( NSString *fontName in fontNames ){
//            printf( "\tFont: %s \n", [fontName UTF8String] );
//        } 
//    }
    
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    
    view.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[ SDWebImageManager sharedManager] cancelAll];
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    ispage = requestDic[@"ispage"];
    nextpage = requestDic[@"nextpage"];
    if (request.tag == 2) {
        detailModel* comodels = _tableSource[2];
        
        NSArray* comments = requestDic[@"comments"];
        for (NSDictionary* commentsDic  in comments) {
            commentModel* comModel = [[commentModel alloc]init];
            [comModel setValuesForKeysWithDictionary:commentsDic];
            [comodels.comments addObject:comModel];
        }
    }else
    {
        
        NSLog(@"%@",requestDic);
        detailModel* model = [[detailModel alloc]init];
        NSDictionary* commercial = requestDic[@"commercial"];
        model.descriptions = commercial[@"description"];
        model.type = WXGoodsService;
        commentstars = commercial[@"stars"];
        model.latitude = commercial[@"latitude"];
        model.longitude = commercial[@"longitude"];
        [model setValuesForKeysWithDictionary:commercial];
        model.commid = _comID;
        model.merName = self.model.merName;
        [_tableSource addObject:model];
        [_tableSource addObject:model];
        
        commentNum = requestDic[@"commentNum"];
        
        detailModel* comodels = [[detailModel alloc]init];
        comodels.type = WXGoodsComment;
        NSArray* comments = requestDic[@"comments"];
        for (NSDictionary* commentsDic  in comments) {
            commentModel* comModel = [[commentModel alloc]init];
            [comModel setValuesForKeysWithDictionary:commentsDic];
            [comodels.comments addObject:comModel];
        }
        
        [_tableSource addObject:comodels];
        
        
    }
    
    [_tableView reloadData];
    
}

#pragma mark - private

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        _label.text = @"商家详情";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:15];
    }
    return _label;
}

-(void)tapdetail:(UITapGestureRecognizer*)tap
{
    UIImageView* imageView = (UIImageView*)tap.view;
    if (imageView.tag == 2) {
        if ([ispage isEqualToString:@"1"]) {
            NSDictionary* dic1 = [[NSDictionary alloc]initWithObjectsAndKeys:_comID,@"commid",nextpage,@"page", nil];
            _request.tag = 2;
            
            [_request requestWitUrl:COMMER_DET_IF andArgument:dic1 andType:WXHTTPRequestGet];
        }else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多评论了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    
}

-(void)pushDetail:(NSDictionary*)dic
{
    NSString* key = dic[@"key"];
    if ([key isEqualToString:@"image"]) {
        photoalbumViewController* photo = [[photoalbumViewController alloc]init];
        photo.imageName = dic[@"imageName"];
        [self presentViewController:photo animated:YES completion:^{
            
        }];
    }else if([key isEqualToString:@"buy"])
    {
        
    }
    
}

-(void)registercell
{
    UINib * comment = [UINib nibWithNibName:@"commentTableViewCell" bundle:nil];
    [_tableView registerNib:comment forCellReuseIdentifier:@"commentcell"];
    
    UINib* service = [UINib nibWithNibName:@"serviceTableViewCell" bundle:nil];
    [_tableView registerNib:service forCellReuseIdentifier:@"servicecell"];
    
    UINib* merhd = [UINib nibWithNibName:@"merHdTableViewCell" bundle:nil];
    [_tableView registerNib:merhd forCellReuseIdentifier:@"merHdcell"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    detailModel* model = _tableSource[section];
    if (model.comments != nil) {
        if (section>1) {
            return model.comments.count;
        }
        
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString* identifier = [[NSMutableString alloc]initWithString:@"cell"];
    detailModel* model = _tableSource[indexPath.section];
    if (indexPath.section == 0) {
        [identifier insertString:@"merHd" atIndex:0];
    }else
    {
        switch (model.type) {
                
            case WXGoodsComment:
                [identifier insertString:@"comment" atIndex:0];
                break;
            case WXGoodsService:
                [identifier insertString:@"service" atIndex:0];
                break;
                
            default:
                break;
        }
    }
    
    rootTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell addDelegate:self andAction:@selector(pushDetail:)];
    cell.tag = indexPath.row;
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailModel* model = _tableSource[indexPath.section];
    
    if (indexPath.section == 0) {
        return 220;
    }else
    {
        
        commentModel* comModel = nil;
        if (model.comments.count>0) {
            comModel = model.comments[indexPath.row];
        }
        NSInteger height;
        CGRect rect;
        switch (model.type) {
                
            case WXGOODSMerchantMessage:
                height = 90;
                break;
            case WXGoodsService:{
                
                CGRect rect = [model.descriptions boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
                
                height = rect.size.height - 18 + 44;
            }
                break;
            case WXGoodsComment:
                
                rect = [comModel.commentText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 10, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
                height = rect.size.height - 20 + 60;
                if (comModel.picarr.count>0) {
                    height += 90;
                }
                break;
                
            default:
                break;
        }
        return height;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    detailModel* model = _tableSource[section];
    if (section<1) {
        return nil;
    }
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 160, 20)];
    
    [view addSubview:label];
    
    switch (model.type) {
        case WXGoodsComment:
            label.text = [NSString stringWithFormat:@"评价(%@人评论)",commentNum];
            
            break;
        case WXGoodsService:
            label.text = @"门店服务";
            break;
        
        default:
            break;
    }
    
    if (model.type == WXGoodsComment) {
        commentStar* star = [[commentStar alloc]initWithFrame:CGRectMake(170, 0, 90, 30)];
        star.numofStar = [commentstars integerValue];
        star.selectingenabled = NO;
        [view addSubview:star];
        UILabel* fenshu = [[UILabel alloc]initWithFrame:CGRectMake(265, 5, 60, 20)];
        fenshu.text = [NSString stringWithFormat:@"%0.1f分",commentstars.floatValue];
        fenshu.textColor = [UIColor colorWithHexString:@"#F37C00"];
        [view addSubview:fenshu];
    }
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else
    {
        return 30;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    detailModel* model = _tableSource[section];
    if (model.type == WXGoodsComment)
    {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        imageview.userInteractionEnabled = YES;
        imageview.backgroundColor = [UIColor whiteColor];
        imageview.tag = section;
        [view addSubview:imageview];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, 20)];
        label.text = @"查看全部评论";
        label.textColor = [UIColor colorWithHexString:@"#FF658E"];
        [view addSubview:label];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 10)];
        grayView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
        [view addSubview:grayView];
        
        UIImageView* arrView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20, 8, 10, 15)];
        arrView.image = [UIImage imageNamed:@"right_arr"];
        [view addSubview:arrView];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapdetail:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imageview addGestureRecognizer:tap];
        
        UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F3F2F3"];
        [view addSubview:line];
       
        
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    detailModel* model = _tableSource[section];
    if (model.type == WXGoodsComment) {
        return 40;
    }
    return 10;
}

@end
