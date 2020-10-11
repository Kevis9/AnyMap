//
//  FloorPickerView.h
//  AnyMap
//
//  Created by bytedance on 2020/10/7.
//  Copyright © 2020 hwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FloorPickerView : UIPickerView
@property(strong, nonatomic) NSArray<NSString*> *floors;
@property(strong, nonatomic) NSString *onFloor;
@property(nonatomic) uint selectedIdx;

typedef void (^ACTION)(NSString*, uint);
@property ACTION switchFloor;
- (instancetype)initWithFloors:(NSArray*)floors action:(ACTION)switchFloor;

- (instancetype)initWithFloors:(NSArray*)floors;
@end

NS_ASSUME_NONNULL_END
