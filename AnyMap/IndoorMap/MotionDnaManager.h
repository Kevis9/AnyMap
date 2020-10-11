//
//  MotionDnaManager.h
//  iOS-helloworld-ObjC
//
//  Created by James Grantham on 9/14/18.
//  Copyright © 2018 Navisens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MotionDnaSDK/MotionDnaSDK.h>
@class IndoorMapViewController;

@interface MotionDnaManager : MotionDnaSDK
@property (weak, nonatomic) IndoorMapViewController *receiver;
-(void)receiveMotionDna:(MotionDna*)motionDna;
-(void)receiveNetworkData:(MotionDna*)motionDna;
-(void)receiveNetworkData:(NetworkCode)opcode WithPayload:(NSDictionary*)payload;
-(void)reportError:(ErrorCode)error WithMessage:(NSString*)message;
@end
