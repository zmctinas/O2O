//
//  Head.h
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#ifndef O2O_Head_h
#define O2O_Head_h

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define ISCORRECTPSD @"^[A-Za-z0-9\u4E00-\u9FA5-]{6,10}$"

#import "HTTPRequest.h"

#import "FrameSize.h"

#import "UIImageView+WebCache.h"

#import "MyMD5.h"

#import "WXProcess.h"

#import "WXalertView.h"

#define HEADURL @"http://115.28.133.70/interface/"

#define HEADIMG @"http://115.28.133.70/"

#define MAIN_IF @"json_index.php"//首页

#define COMMER_IF @"json_commercial.php"//商家列表

#define COMMER_GOODS_IF @"json_searchgoodsbycommid.php"//商家商品列表

#define FLASH_IF @"json_goods_flashsale.php"//限时秒杀

#define INTEGRAL_IF @"json_goods_integralStore.php"//积分商城

#define ALL_IF @"json_goods_all.php"//全部商品

#define MYMessage_if @"json_my.php"//我的信息

//#define COM_CATE_IF @"json_commercialtype.php"//商户类型json_comtype_all
#define COM_CATE_IF @"json_comtype_all.php"//

#define RECOMMEND_IF @"json_goods_recommend_everyday.php"//每日推荐

#define COMMER_DET_IF @"json_commerdetails.php"//商户详情

#define REGISTER_IF @"json_userreg.php"//注册

#define LOGIN_IF @"json_userlogin.php"//登陆

#define EDITPASS_IF @"json_editpassword.php"//修改密码；

#define EDITMOBILE_IF @"json_editmobile.php"//更换手机

#define RESETPASS_IF @"json_resetpassword.php"//找回密码

#define EDITPAY_IF @"json_setpaypassword.php"//设置支付密码

#define XIUGAIPAY_IF @"json_editpaypassword.php"//修改

#define EDITNAME_IF @"json_editusername.php"//修改用户名

#define GOODSDETAIL_IF @"json_goods_details.php"//商品详情

#define MYCOLLECT_IF @"json_mycollect.php"//我的收藏；

#define ADDCOLLECT_IF @"json_addcollect.php"//添加收藏

#define GOODTYPE_IF @"json_goodstype.php"//商品类型；

#define CATETYPE_IF @"json_type_all.php"//商品分类

#define GOODMORE_IF @"json_goods_more.php"//更多分类

#define USERAVATAR_IF @"json_useravatar.php"//上传头像

#define SHENG_IF @"json_selectsheng.php"//省

#define SHI @"json_selectshi.php"//市

#define XIAN_IF @"json_selectxian.php"//县

#define ADDADDRESS_IF @"json_addaddress.php"//新建收货地址

#define MYGROUPCOU_IF @"json_mygroupcoupon.php"//我的团购券

#define SELECTADDRESS_IF @"json_myaddress.php"//收货地址查寻

#define DELETEADDRESS_IF @"json_deladdress.php"//删除地址

#define MYADDRESS_IF @"json_myaddress.php"//收货地址查询

#define DELADDRESS_IF @"json_deladdress.php"//删除地址接口

#define EDITADDRESS_IF @"json_editaddisfirst.php"//修改默认地址

#define SEARCH_IF @"json_searchgoods.php"//搜索

#define INTEDETIAL @"json_integral_detail.php"//积分明细

#define LEFTCATE_IF @"json_classify_L.php"//左侧分类

#define RIGHTCATE_IF @"json_classify_R.php"//右侧分类

#define ADDCOMMENT_IF @"json_addcomment.php"//添加评论

#define INTEXCHANGE_IF @"json_integral_exchange.php"//积分兑换详情接口

#define EXCHANGE_IF @"json_integral_user.php"//积分兑换

#define HOT_IF @"json_goods_hot.php"//热门

#define ATTR_IF @"json_attrs.php"//属性接口

#define GOBUY_IF @"json_orderinfo.php"//立即购买

#define CREATEORDER_IF @"json_orderpost.php"//生成订单

#define ALLORDER_IF @"json_myorder.php"//全部订单；

#define ORDERDETAIL_IF @"json_ordercontent.php"//订单详情

#define CREATEGROUPCOUPON_IF @"json_addgroupcoupon.php"//团购券生成

#define ORDERDELETE_IF @"json_delorder.php"//删除订单

#define ORDERBACK_IF @"json_orderreturn.php"//退货接口

#define MYCOUPON_IF @"json_mycoupon.php"//我的优惠券；

#define COUPONDETAIL_IF @"json_couponcontent.php"//优惠券详情

#define ALLCOUPON_IF @"json_coupon.php"//所有优惠券

#define ADDCOUPON_IF @"json_addcoupon.php"//领取优惠券

#define YIJIAN_IF @"json_yijian.php"//意见反馈

#define COMMENT_IF @"json_goodscomment.php"//评论接口

#define COMMERQUAN_IF @"json_shangquan.php"//商圈接口

#define NOTIFICATION_IF @"json_jgmessage.php"//推送

#define SHARK_IF @"json_yaoyiyao.php"//摇一摇；

#define HUIYUANPAY @"json_zhanghupay.php"//会员卡支付

#define ORDERNUM @"json_chongzhinum.php"//生成订单号

#define CHARGEREC_IF @"json_myflow.php"//充值记录

#define USEREC_IF @"json_mypayflow.php"//使用记录

#define GETGOODS_IF @"json_get.php"  //确认收货接口

#define USEABLE_IF @"json_mycouponuse.php"//可用优惠券

#define MOBILE_IF @"json_sendsms.php"//短信包

#define DELETECOLLECT_IF @"json_delcollect.php"//删除收藏

#define FINDMOBILE_IF @"json_sendsmsfind.php"//找回短信包

#define DELETEGROUP_IF @"json_delgroupcoupon.php"//删除团购券

#define BDSJONE_IF @"json_sendsmsbyok.php"//绑定手机1

#define BDSJTWO_IF @"json_sendsmsfornewphone.php"//绑定手机2

#define BDSJTHREE_IF @"json_editmobile.php"//绑定手机3

#define GETPAY_IF @"json_getpay.php"//货到付款

#define ADDSHOPCAR_IF @"json_addshopcart.php"//添加购物车

#define EXITSHOPCAR_IF @"json_shopcart.php"//修改购物车

#define SHOPCAR_IF @"json_shopcartlist.php"//购物车

#define FORPAY_IF @"json_orderinfo_car.php"//去结算

#define FORDINGDAN_IF @"json_order_car.php"//提交订单




#define WEIXINDIAO @"http://115.28.133.70/interface/wxpay/unit/notify_url.php"//微信回调
#define ZHIFUBAODIAO @"http://115.28.133.70/interface/alipay/notify_url.php"//支付宝回调

#define WEIDIAO @"json_wxnotify.php"//


#define PAY_WEB @"http://115.28.133.70/interface/mobile/payhelp.php"//支付帮助
#define MY_WEB @"http://115.28.133.70/interface/mobile/aboutus.php"//关于我们
#define COMDETAIL_WEB @"http://115.28.133.70/interface/mobile/goodscontent.php?id=%@"//商品详情
#define SHANGJIA_WEB @"http://115.28.133.70/interface/mobile/commercialcontent.php?id=%@"//商家详情

#define SERVICE_WEB @"http://115.28.133.70/interface/mobile/fuwuzhongxin.php"//服务中心
#define CREDITECARD_WEB @"http://115.28.133.70/interface/mobile/membercart.php"//会员卡中心

#define YONGHUXIEYI_WEB @"http://115.28.133.70/interface/mobile/xieyi.php"//用户协议


#endif
