//
//  IndoorMapViewController.h
//  AnyMap
//
//  Created by bytedance on 2020/9/8.
//  Copyright © 2020 hwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotionDnaManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface IndoorMapViewController : UIViewController
@property (strong, nonatomic) MotionDnaManager *manager;
-(void)receiveMotionDna:(MotionDna*)motionDna;
-(void)receiveNetworkData:(MotionDna*)motionDna;
-(void)receiveNetworkData:(NetworkCode)opcode WithPayload:(NSDictionary*)payload;
@end

NS_ASSUME_NONNULL_END
