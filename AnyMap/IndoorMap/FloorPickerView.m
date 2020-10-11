//
//  FloorPickerView.m
//  AnyMap
//
//  Created by bytedance on 2020/10/7.
//  Copyright © 2020 hwl. All rights reserved.
//

#import "FloorPickerView.h"

@implementation FloorPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFloors:(NSArray*)floors action:(ACTION)switchFloor {
    if(self = [super init]){
        _floors = floors;
        _selectedIdx = 0;
        _onFloor = [_floors objectAtIndex:_selectedIdx];
        
        self.backgroundColor = UIColor.whiteColor;
        
        self.delegate = self;
        self.dataSource = self;
        
        _switchFloor = switchFloor;
    }
    return self;
}

@end

@interface FloorPickerView (UIPickerViewDataSource) <UIPickerViewDataSource>
@end

@implementation FloorPickerView (UIPickerViewDataSource)

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_floors count];
}

@end

@interface FloorPickerView (UIPickerViewDelegate) <UIPickerViewDelegate>
@end

@implementation FloorPickerView (UIPickerViewDelegate)

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_floors objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectedIdx = row;
    _onFloor = [_floors objectAtIndex:row];
    
    _switchFloor(_onFloor, _selectedIdx);
}

@end
