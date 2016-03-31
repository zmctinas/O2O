//	            __    __                ________
//	| |    | |  \ \  / /  | |    | |   / _______|
//	| |____| |   \ \/ /   | |____| |  / /
//	| |____| |    \  /    | |____| |  | |   _____
//	| |    | |    /  \    | |    | |  | |  |____ |
//  | |    | |   / /\ \   | |    | |  \ \______| |
//  | |    | |  /_/  \_\  | |    | |   \_________|
//
//	Copyright (c) 2012年 HXHG. All rights reserved.
//	http://www.jpush.cn
//  Created by Zhanghao
//

#import "RootViewController.h"
#import "APService.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
// Do any additional setup after loading the view from its nib.

}
-(void)create{
    _messageCount = 0;
    _notificationCount = 0;
    _messageContents = [[NSMutableArray alloc] initWithCapacity:6];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];

}
//获取appKey
- (NSString *)getAppKey {
  NSURL *urlPushConfig = [[[NSBundle mainBundle] URLForResource:@"PushConfig"
                                                  withExtension:@"plist"] copy];
  NSDictionary *dictPushConfig =
      [NSDictionary dictionaryWithContentsOfURL:urlPushConfig];

  if (!dictPushConfig) {
    return nil;
  }

  // appKey
  NSString *strApplicationKey = [dictPushConfig valueForKey:(@"APP_KEY")];
  if (!strApplicationKey) {
    return nil;
  }

  return [strApplicationKey lowercaseString];
}

- (void)dealloc {
  [self unObserveAllNotifications];
}

- (void)unObserveAllNotifications {
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter removeObserver:self
                           name:kJPFNetworkDidSetupNotification
                         object:nil];
  [defaultCenter removeObserver:self
                           name:kJPFNetworkDidCloseNotification
                         object:nil];
  [defaultCenter removeObserver:self
                           name:kJPFNetworkDidRegisterNotification
                         object:nil];
  [defaultCenter removeObserver:self
                           name:kJPFNetworkDidLoginNotification
                         object:nil];
  [defaultCenter removeObserver:self
                           name:kJPFNetworkDidReceiveMessageNotification
                         object:nil];
  [defaultCenter removeObserver:self
                           name:kJPFServiceErrorNotification
                         object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification {
  NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
  
  NSLog(@"未连接");
  
}

- (void)networkDidRegister:(NSNotification *)notification {
  NSLog(@"%@", [notification userInfo]);
  NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    
  NSLog(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  NSString *title = [userInfo valueForKey:@"title"];
  NSString *content = [userInfo valueForKey:@"content"];
  NSDictionary *extra = [userInfo valueForKey:@"extras"];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

  [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];

  NSString *currentContent = [NSString
      stringWithFormat:
          @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
          [NSDateFormatter localizedStringFromDate:[NSDate date]
                                         dateStyle:NSDateFormatterNoStyle
                                         timeStyle:NSDateFormatterMediumStyle],
          title, content, [self logDic:extra]];
  NSLog(@"%@", currentContent);

  [_messageContents insertObject:currentContent atIndex:0];

  _messageCount++;
 [self changebagecount:_messageCount];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
  if (![dic count]) {
    return nil;
  }
  NSString *tempStr1 =
      [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                   withString:@"\\U"];
  NSString *tempStr2 =
      [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
  NSString *tempStr3 =
      [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
  NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
  NSString *str =
      [NSPropertyListSerialization propertyListFromData:tempData
                                       mutabilityOption:NSPropertyListImmutable
                                                 format:NULL
                                       errorDescription:NULL];
  return str;
}

- (void)serviceError:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  NSString *error = [userInfo valueForKey:@"error"];
  NSLog(@"%@", error);
}

- (void)addNotificationCount {
  _notificationCount++;
    NSLog(@"%d",_notificationCount);
    [self changebagecount:_messageCount];
}

- (void)addMessageCount {
  _messageCount++;
    NSLog(@"%d",_messageCount);
    
    [self changebagecount:_messageCount];
 
}

-(void)changebagecount:(int)count
{
    [APService setBadge:count];
}

- (IBAction)cleanMessage:(id)sender {
  _messageCount = 0;
  _notificationCount = 0;
  [_messageContents removeAllObjects];
  [self changebagecount:_messageCount];

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
