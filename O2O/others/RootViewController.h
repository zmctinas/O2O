//
//  IndexViewController.h
//  PushSDK
//
//  Created by 张 on 14-7-16.
//
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController {
  NSMutableArray *_messageContents;
  int _messageCount;
  int _notificationCount;
}
-(void)create;
-(void)addMessageCount;
- (void)addNotificationCount;
- (IBAction)cleanMessage:(id)sender;
@end
