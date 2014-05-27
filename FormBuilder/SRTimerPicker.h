//
//  SRTimerPicker.h
//  FitApp
//
//  Created by Scott Roberts on 20/05/2014.
//  Copyright (c) 2014 scottr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SRTimerPickerDelegate <NSObject>

-(void)didSelectNewTime:(NSString *)time;

@end

@interface SRTimerPicker : UIPickerView

@property (nonatomic, assign) id<SRTimerPickerDelegate> customPickerDelegate;

@end
