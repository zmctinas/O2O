//
//  goodsDetailViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/21.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "goodsDetailViewController.h"
#import "detailModel.h"
#import "rootTableViewCell.h"
#import "headTableViewCell.h"
#import "baseMessageTableViewCell.h"
#import "merchant TableViewCell.h"
#import "productTableViewCell.h"
#import "commentTableViewCell.h"
#import "UIColor+hexColor.h"
#import "detMsgViewController.h"
#import "photoalbumViewController.h"
#import "commentStar.h"
#import "UMSocial.h"
#import "delLineLabel.h"
#import "bottomView.h"
#import "orderViewController.h"
#import "groupOrderViewController.h"
#import "commerModel.h"
#import "guanggaoModel.h"
#import "AppDelegate.h"
#import "loginViewController.h"
#import "WXApi.h"



@interface goodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UMSocialUIDelegate,HTTPRequestDataDelegate
>
{
    NSMutableArray* _tableSource;
    HTTPRequest* _request;
    HTTPRequest* collectReq;
    NSUserDefaults* defaults;
    NSString* ydfs;
    NSString* address;
    NSString* phoneNum;
    NSString* comName;
    NSString* starnum;
    NSString* comNum;
    NSNumber* canbuynum;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic) UIView* suspendView;

@property(strong,nonatomic)UILabel* label;


@end

@implementation goodsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    _tableSource = [[NSMutableArray alloc]init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.titleView = self.label;
    
    [self registerCell];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    _request = [[HTTPRequest alloc]init];
    _request.delegate = self;
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_commid,@"commodityid", nil];
    [_request requestWitUrl:GOODSDETAIL_IF andArgument:dic andType:WXHTTPRequestGet];
    
    
    
    [self createNavigation];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"geag");
    // Dispose of any resources that can be recreated.
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

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    NSLog(@"%@",requestDic);
    NSString* message = requestDic[@"message"];
    
    
    if (request == _request) {
        [_tableSource removeAllObjects];
        NSDictionary* productMessage = requestDic[@"productMessage"];
        canbuynum = productMessage[@"canbuynum"];
        
        _model.salesprice = [NSString stringWithFormat:@"%@",productMessage[@"salesprice"]];
        _model.originalprice = [NSString stringWithFormat:@"%@",productMessage[@"yj"]];
        _model.num = [productMessage[@"sold_num"] integerValue];
        _model.comName = productMessage[@"bt"];
        _model.ydfs = productMessage[@"ydfs"];
        NSDictionary* url = requestDic[@"url"];
        ydfs = productMessage[@"ydfs"];
        
        if ([url[@"picarr"] length]>0) {
            _model.smallPic = url[@"picarr"];
        }
        
        [self.view addSubview:self.suspendView];
        _suspendView.hidden = YES;
        
//        _model.num = [productMessage[@"sold_num"] integerValue];
        _model.descriptions = productMessage[@"description"];
        [_tableSource addObject:_model];
        [_tableSource addObject:_model];
        
        
//        NSDictionary* productMessage = requestDic[@"productMessage"];
        
        allMerModel* productMessagemodel = [[allMerModel alloc]init];
        [productMessagemodel setValuesForKeysWithDictionary:productMessage];
        productMessagemodel.type = WXGOODSProductMessage;
        NSString* description = productMessage[@"message"];
        productMessagemodel.message = description;
        productMessagemodel.commoditys = nil;
        [_tableSource addObject:productMessagemodel];
        
        NSDictionary* consumeReminder = requestDic[@"consumeReminder"];
        allMerModel* consumeRemindermodel = [[allMerModel alloc]init];
        [consumeRemindermodel setValuesForKeysWithDictionary:consumeReminder];
        consumeRemindermodel.message = consumeRemindermodel.message_ts;
        consumeRemindermodel.type = WXGoodsConsumeReminder;
        consumeRemindermodel.commoditys = nil;
        [_tableSource addObject:consumeRemindermodel];
        
        NSDictionary* businessMessage = requestDic[@"businessMessage"];
        allMerModel* model = [[allMerModel alloc]init];
        [model setValuesForKeysWithDictionary:businessMessage];
        NSArray* arr1 = businessMessage[@"commoditys"];
        if (arr1.count>0) {
            NSDictionary* dic = arr1[0];
            address = dic[@"address"];
            phoneNum = dic[@"phoneNum"];
            model.latitude = dic[@"latitude"];
            model.longitude = dic[@"longitude"];
        }
        
        model.phoneNum = phoneNum;
        model.type = WXGOODSMerchantMessage;
        [_tableSource addObject:model];
        
        NSDictionary* comment = requestDic[@"comment"];
        comNum = comment[@"commnum"];
        starnum = comment[@"star"];
        allMerModel* commentmodel = [[allMerModel alloc]init];
        [commentmodel setValuesForKeysWithDictionary:comment];
        starnum = comment[@"star"];
        commentmodel.type = WXGoodsComment;
        [_tableSource addObject:commentmodel];
        
        NSArray* guanggao_pic = requestDic[@"guanggao_pic"];
        allMerModel* guanggaomodel = [[allMerModel alloc]init];
        for (NSDictionary* dic in guanggao_pic) {
            guanggaoModel* model = [[guanggaoModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [guanggaomodel.commoditys addObject:model];
        }
        NSLog(@"%ld",guanggaomodel.commoditys.count);
        guanggaomodel.type = WXGoodsRecommend;
        [_tableSource addObject:guanggaomodel];
        
        [_tableView reloadData];
    }else if (request == collectReq)
    {
        
        NSString* content = nil;
        NSInteger msg = [message integerValue];
        switch (msg) {
            case 1:
                content = @"收藏成功";
                break;
            case 2:
                content = @"失败";
                break;
            case 3:
                content = @"已收藏";
                break;
            case 4:
                content = @"用户不存在";
                break;
            case 5:
                content = @"商品不存在";
                break;
                
            default:
                break;
        }
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"产品详情";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

-(UIView*)suspendView
{
    if (_suspendView == nil) {
        _suspendView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
        _suspendView.backgroundColor = [UIColor whiteColor];
        UILabel* lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 21)];
        lastLabel.adjustsFontSizeToFitWidth = YES;
        if (_model.currentprice.length>0) {
            lastLabel.text = [NSString stringWithFormat:@"￥%.2f",[_model.currentprice floatValue]];
        }else
        {
            lastLabel.text = [NSString stringWithFormat:@"￥%.2f",[_model.salesprice floatValue]];
        }
        
        [_suspendView addSubview:lastLabel];
        delLineLabel* oldLabel = [[delLineLabel alloc]initWithFrame:CGRectMake(80, 13, 75, 16)];
        oldLabel.adjustsFontSizeToFitWidth = YES;
        oldLabel.text = [NSString stringWithFormat:@"￥%.2f",[_model.originalprice floatValue]];
        oldLabel.font = [UIFont systemFontOfSize:11];
        [_suspendView addSubview:oldLabel];
        
        
        if ([ydfs isEqualToString:@"2"]) {
            
            
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(140, 5, 80, 28)];
            [btn setTitle:@"加入购物车" forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"loginbtn"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(tapCar:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [_suspendView addSubview:btn];
        }
        
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(230, 5, 80, 28)];
        [button setTitle:@"立即购买" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"loginbtn"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buyBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_suspendView addSubview:button];
        UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
        
        line.backgroundColor = [UIColor colorWithHexString:@"#EFEFF4"];
        [_suspendView addSubview:line];
    }
    
    return _suspendView;
}

#pragma mark - private

-(void)tapCar:(UIButton*)sender
{
    
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid == nil) {
        loginViewController* login = [[loginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }else
    {
        bottomView* bottom = [[bottomView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
        
        bottom.gid = _commid;
        bottom.canbuynum = canbuynum;
        bottom.comname = _model.comName;
        bottom.price = _model.salesprice;
        [bottom addorderDelegate:self AndAction:@selector(addShopCar:andDic:)];
        [self.view addSubview:bottom];
    }
    
}

-(void)createNavigation
{
    UIButton* right1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [right1 setFrame:CGRectMake(0, 0, 20, 20)];
    [right1 setImage:[UIImage imageNamed:@"double_arr"] forState:UIControlStateNormal];
    [right1 addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* item1 = [[UIBarButtonItem alloc]initWithCustomView:right1];
    
    UIButton* right2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [right2 setFrame:CGRectMake(0, 0, 20, 20)];
    [right2 setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    [right2 addTarget:self action:@selector(likeBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc]initWithCustomView:right2];
    self.navigationItem.rightBarButtonItems = @[item2,item1];
}

-(void)pushOrder:(NSArray*)attSource andSum:(NSDictionary*)messageDic
{
    
    orderViewController* root = [[orderViewController alloc]init];
    
    NSData *data=  [NSJSONSerialization dataWithJSONObject:@{@"goods":attSource} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    root.gid = _commid;
    root.jsonStr = jsonStr;
    root.attSource = attSource;
    root.messageDic = messageDic;
    
    [self.navigationController pushViewController:root animated:YES];
}

-(void)buyBtn:(UIButton*)sender
{
    UIApplication* app = [UIApplication sharedApplication];
    AppDelegate* delegate = app.delegate;
    delegate.delegate = self;
    NSString* uid = [defaults objectForKey:@"uid"];
    if (uid == nil) {
        loginViewController* login = [[loginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    if ([ydfs isEqualToString:@"2"]) {
        bottomView* bottom = [[bottomView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bottom.gid = _commid;
        bottom.canbuynum = canbuynum;
        bottom.comname = _model.comName;
        bottom.price = _model.salesprice;
        [bottom addorderDelegate:self AndAction:@selector(pushOrder:andSum:)];
        [self.view addSubview:bottom];
    }else
    {
        
        NSString* price = nil;
        if (_model.salesprice.length >0) {
            price = _model.salesprice;
        }else
        {
            price = _model.currentprice;
        }
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:address,@"address",phoneNum,@"phoneNum",_model.comName,@"name",_commid,@"gid",price,@"price",canbuynum,@"canbuynum", nil];
        groupOrderViewController* root = [[groupOrderViewController alloc]init];
        root.messageDic = dic;
        [self.navigationController pushViewController:root animated:YES];
    }
    
}

-(void)likeBtn:(UIButton*)sender
{
    NSString* uid = [defaults objectForKey:@"uid"];
    
    if (uid != nil) {
        collectReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",_commid,@"gid", nil];
        
        [collectReq requestWitUrl:ADDCOLLECT_IF andArgument:dic andType:WXHTTPRequestGet];
    }else
    {
        loginViewController* root = [[loginViewController alloc]init];
        [self.navigationController pushViewController:root animated:YES];
    }
    
    
}

-(void)shareBtn:(UIButton*)sender
{
    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:@[UMShareToSina]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        NSLog(@"fawef");
        [arr addObjectsFromArray:@[UMShareToTencent,UMShareToQzone,UMShareToQQ]];
    }
    if ([WXApi isWXAppInstalled]) {
        NSLog(@"fawef");
        [arr addObjectsFromArray:@[UMShareToWechatSession,UMShareToWechatTimeline]];
    }
    
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [NSString stringWithFormat:@"http://115.28.133.70/interface/mobile/fenxianggoods.php?id=%@",_commid];
    [UMSocialData defaultData].extConfig.tencentData.urlResource.url = [NSString stringWithFormat:@"http://115.28.133.70/interface/mobile/fenxianggoods.php?id=%@",_commid];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://115.28.133.70/interface/mobile/fenxianggoods.php?id=%@",_commid];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://115.28.133.70/interface/mobile/fenxianggoods.php?id=%@",_commid];
    
    [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"http://115.28.133.70/interface/mobile/fenxianggoods.php?id=%@",_commid];
    
    
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"http://115.28.133.70/interface/mobile/fenxianggoods.php?id=%@",_commid];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"554876ba67e58e52450026ba"
                                                     shareText:self.model.comName
                                                     shareImage:self.image
                                                     shareToSnsNames:arr
                                                     delegate:self];
}

-(void)pushDetail:(NSDictionary*)dic
{
    NSString* key = dic[@"key"];
    if ([key isEqualToString:@"image"]) {
        photoalbumViewController* photo = [[photoalbumViewController alloc]init];
        photo.imageName = dic[@"imageName"];
        photo.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        photo.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:photo animated:YES completion:^{
            
        }];
    }else if ([key isEqualToString:@"buy"])
    {
        
        UIApplication* app = [UIApplication sharedApplication];
        AppDelegate* delegate = app.delegate;
        delegate.delegate = self;
        NSString* uid = [defaults objectForKey:@"uid"];
        if (uid == nil) {
            loginViewController* login = [[loginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
        if ([ydfs isEqualToString:@"2"]) {
            bottomView* bottom = [[bottomView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
            bottom.gid = _commid;
            bottom.canbuynum = canbuynum;
            bottom.comname = _model.comName;
            bottom.price = _model.salesprice;
            [bottom addorderDelegate:self AndAction:@selector(pushOrder:andSum:)];
            [self.view addSubview:bottom];
        }else
        {
            NSString* price = nil;
            if (_model.salesprice.length >0) {
                price = _model.salesprice;
            }else
            {
                price = _model.currentprice;
            }
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_commid,@"gid",price,@"price",_model.comName,@"name",@"phoneNum",phoneNum,address,@"address",canbuynum,@"canbuynum", nil];
            groupOrderViewController* root = [[groupOrderViewController alloc]init];
            root.messageDic = dic;
            
            [self.navigationController pushViewController:root animated:YES];
        }
        
    }else if ([key isEqualToString:@"merchant"])
    {
        detMsgViewController* root = [[detMsgViewController alloc]init];
        root.offset = 1;
        root.comid = _commid;
        [self.navigationController pushViewController:root animated:YES];
    }else if ([key isEqualToString:@"headImage"])
    {
        detMsgViewController* root = [[detMsgViewController alloc]init];
        root.offset = 0;
        root.comid = _commid;
        [self.navigationController pushViewController:root animated:YES];
    }else if ([key isEqualToString:@"shopcar"])
    {
        NSString* uid = [defaults objectForKey:@"uid"];
        if (uid == nil) {
            loginViewController* login = [[loginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }else
        {
            bottomView* bottom = [[bottomView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
            bottom.gid = _commid;
            bottom.canbuynum = canbuynum;
            bottom.comname = _model.comName;
            bottom.price = _model.salesprice;
            [bottom addorderDelegate:self AndAction:@selector(addShopCar:andDic:)];
            [self.view addSubview:bottom];
        }
        
    }
    
}

-(void)addShopCar:(NSArray*)array andDic:(NSDictionary*)dic
{
    NSMutableDictionary* shopDic = [[NSMutableDictionary alloc]init];
    NSDictionary* goods = [NSDictionary dictionaryWithObjectsAndKeys:array,@"goods", nil];
    NSData *data=  [NSJSONSerialization dataWithJSONObject:goods options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [shopDic setObject:jsonStr forKey:@"json"];
    [shopDic setObject:dic[@"num"] forKey:@"num"];
    [shopDic setObject:[defaults objectForKey:@"uid"] forKey:@"uid"];
    [shopDic setObject:_commid forKey:@"gid"];
    [HTTPRequest requestWitUrl:ADDSHOPCAR_IF andArgument:shopDic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        
            if ([requestDic[@"message"] isEqualToString:@"1"]) {
                [WXalertView alertWithMessage:@"添加成功" andDelegate:self];
            }else
            {
                [WXalertView alertWithMessage:@"添加失败" andDelegate:self];
            }
    } Falsed:^(NSError *error) {
        [WXalertView alertWithMessage:@"添加失败" andDelegate:self];
    }];
    
}

-(void)tapdetail:(UITapGestureRecognizer*)tap
{
    UIImageView* imageView = (UIImageView*)tap.view;
    
    detMsgViewController* root = [[detMsgViewController alloc]init];
    if (imageView.tag == 5) {
        root.offset = 2;
    }else
    {
        root.offset = 0;
    }
    
    //电影
    root.comid = _commid;
    [self.navigationController pushViewController:root animated:YES];
    
}

-(void)registerCell
{
    UINib* headnib = [UINib nibWithNibName:@"headTableViewCell" bundle:nil];
    [_tableView registerNib:headnib forCellReuseIdentifier:@"headcell"];
    
    UINib* basenib = [UINib nibWithNibName:@"baseMessageTableViewCell" bundle:nil];
    [_tableView registerNib:basenib forCellReuseIdentifier:@"baseMessagecell"];
    
    UINib* merchant = [UINib nibWithNibName:@"merchant TableViewCell" bundle:nil];
    [_tableView registerNib:merchant forCellReuseIdentifier:@"merchantcell"];
    
    UINib* product = [UINib nibWithNibName:@"productTableViewCell" bundle:nil];
    [_tableView registerNib:product forCellReuseIdentifier:@"productcell"];
    
    UINib* comment = [UINib nibWithNibName:@"commentTableViewCell" bundle:nil];
    [_tableView registerNib:comment forCellReuseIdentifier:@"commentcell"];
    
    UINib* recommend = [UINib nibWithNibName:@"recomTableViewCell" bundle:nil];
    [_tableView registerNib:recommend forCellReuseIdentifier:@"recommendcell"];
    
}

-(void)dealloc
{
     [[ SDWebImageManager sharedManager] cancelAll];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    allMerModel* model = _tableSource[section];
    if (model.type == WXGoodsRecommend) {
        if ((model.commoditys.count%2)>0) {
            return model.commoditys.count/2+1;
        }else
        {
            return model.commoditys.count/2;
        }
    }
    if (model.commoditys !=nil) {
        if (section>1) {
            return model.commoditys.count;
        }
        
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString* str = [NSMutableString stringWithString:@"cell"];
    allMerModel* model = _tableSource[indexPath.section];
    
    if (indexPath.section == 0) {
        [str insertString:@"head" atIndex:0];
     }else if (indexPath.section == 1 )
     {
         [str insertString:@"baseMessage" atIndex:0];
     }else
     {
         switch (model.type) {
             case WXGOODSMerchantMessage:
                 [str insertString:@"merchant" atIndex:0];
                 break;
             case WXGOODSProductMessage:
//                 model.message = model.description;
                 [str insertString:@"product" atIndex:0];
                 break;
             case WXGoodsConsumeReminder:
                 model.message = model.message_ts;
                 [str insertString:@"product" atIndex:0];
                 break;
             case WXGoodsComment:
                 [str insertString:@"comment" atIndex:0];
                 break;
             case WXGoodsRecommend:
                 [str insertString:@"recommend" atIndex:0];
                 
             default:
                 break;
         }
     }
    
    rootTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    
    [cell addDelegate:self andAction:@selector(pushDetail:)];
    
    cell.merModel = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
//        
//    {
//        
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//        
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
//        
//    {
//        
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//        
//    }
//    
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    allMerModel* model = _tableSource[indexPath.section];
    if (model.type == WXGOODSMerchantMessage&& indexPath.section>2) {
        
        WXMapViewController* root = [[WXMapViewController alloc]init];
        root.latitude = model.latitude;
        root.longitude = model.longitude;
        [self.navigationController pushViewController:root animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 210;
    }else if (indexPath.section == 1)
    {
        return 90;
    }else
    {
        allMerModel* model = _tableSource[indexPath.section];
        NSInteger height;
        CGRect rect;
        switch (model.type) {
            
            case WXGOODSMerchantMessage:
                height = 90;
                break;
            case WXGOODSProductMessage:
                
            case WXGoodsConsumeReminder:
                
                rect = [model.message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 10, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
                height = rect.size.height - 21 + 44;
                break;
            case WXGoodsRecommend:
                height = 160;
                break;
            case WXGoodsComment:
                
                rect = [[model.commoditys[indexPath.row] objectForKey:@"body"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 10, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
                height = rect.size.height - 20 + 60;
                if ([[model.commoditys[indexPath.row] objectForKey:@"picarr"] count]>0) {
                    height += 100;
                }
                
                break;
                
            default:
                break;
        }
        return height;
    }
    
    
    
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section<2) {
        return nil;
    }
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor whiteColor];
    

    
    UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    [view addSubview:line2];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 20)];
    [view addSubview:label];
    
    allMerModel* model = _tableSource[section];
    switch (model.type) {
        case WXGoodsComment:
            label.text = [NSString stringWithFormat:@"评价（%@人评价）",comNum];
            
            break;
        case WXGoodsConsumeReminder:
            label.text = @"消费提示";
            break;
        case WXGOODSMerchantMessage:
            label.text = @"商家信息";
            break;
        case WXGOODSProductMessage:
            label.text = @"产品信息";
            break;
        case WXGoodsRecommend:
            label.text = @"为您推荐";
            break;
        default:
            break;
    }
    
    if (model.type == WXGoodsComment) {
        commentStar* star = [[commentStar alloc]initWithFrame:CGRectMake(170, 0, 90, 30)];
        star.selectingenabled = NO;
        if ([starnum isMemberOfClass:[NSString class]]  ) {
            star.numofStar = starnum.integerValue ;
        }else
        {
            NSInteger num = (NSInteger)[starnum floatValue];
            star.numofStar =  num;
        }
        
        [view addSubview:star];
        
        UILabel* fenshu = [[UILabel alloc]initWithFrame:CGRectMake(265, 5, 60, 20)];
        fenshu.text = [NSString stringWithFormat:@"%0.1f分",[starnum floatValue]];
        fenshu.textColor = [UIColor colorWithHexString:@"#F15C00"];
        [view addSubview:fenshu];
        
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section <2) {
        return 0.01;
    }
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    allMerModel* model = _tableSource[section];
    if (model.type == WXGOODSProductMessage) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        imageview.userInteractionEnabled = YES;
        imageview.backgroundColor = [UIColor whiteColor];
        imageview.tag = section;
        [view addSubview:imageview];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, 20)];
        label.text = @"查看图文详情";
        label.textColor = [UIColor colorWithHexString:@"#FF638E"];
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
        line.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
        [view addSubview:line];
        return view;
    }else if (model.type == WXGoodsComment)
    {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        imageview.userInteractionEnabled = YES;
        imageview.backgroundColor = [UIColor whiteColor];
        imageview.tag = section;
        [view addSubview:imageview];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, 20)];
        label.text = @"查看全部评论";
        label.textColor = [UIColor colorWithHexString:@"#FF638E"];
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
        
        UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
        [view addSubview:line];
        UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
        [view addSubview:line2];
        
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    detailModel* model = _tableSource[section];
    if (section < 2) {
        return 10;
    }else if (model.type == WXGOODSProductMessage || model.type == WXGoodsComment)
    {
        return 40;
    }
    return 10;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y >=200) {
        _suspendView.hidden = NO;
    }else
    {
        _suspendView.hidden = YES;
    }
}

#pragma mark - UMSocialUIDelegate

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        
        NSString* message = [NSString stringWithFormat:@"分享到%@成功",[[response.data allKeys] objectAtIndex:0]];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}



@end
