//
//  SRTimerPicker.m
//  FitApp
//
//  Created by Scott Roberts on 20/05/2014.
//  Copyright (c) 2014 scottr. All rights reserved.
//

#import "SRTimerPicker.h"

@interface SRTimerPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) NSArray *hours, *minutes, *seconds;

@end
@implementation SRTimerPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        //Hours
        NSMutableArray *timeHours = [[NSMutableArray alloc] init];
        for (int i = 0; i < 24; i++) {
            [timeHours addObject:[NSString stringWithFormat:@"%02.f", (float)i]];
        }
        self.hours = [timeHours copy];
        
        //Minutes
        NSMutableArray *timeMinutes = [[NSMutableArray alloc] init];
        for (int i = 0; i < 60; i++) {
            [timeMinutes addObject:[NSString stringWithFormat:@"%02.f", (float)i]];
        }
        self.minutes = [timeMinutes copy];
        
        //Seconds
        NSMutableArray *timeSeconds = [[NSMutableArray alloc] init];
        for (int i = 0; i < 60; i++) {
            [timeSeconds addObject:[NSString stringWithFormat:@"%02.f", (float)i]];
        }
        self.seconds = [timeSeconds copy];
        
        self.dataSource = self;
        self.delegate = self;
    
    }
    return self;
}

#pragma mark -
#pragma mark Picker view data source
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return [NSString stringWithFormat:@"%@ Hrs",[self.hours objectAtIndex:row]];
            break;
        case 1:
            return [NSString stringWithFormat:@"%@ Min",[self.minutes objectAtIndex:row]];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@ Sec",[self.seconds objectAtIndex:row]];
            break;
    }
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (component)
    {
        case 0:
            return self.hours.count;
            break;
        case 1:
            return self.minutes.count;
            break;
        case 2:
            return self.seconds.count;
            break;
    }
    return 0;

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}


#pragma mark -
#pragma mark Picker view delegate

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *hours = [NSString stringWithFormat:@"%02.f", (float)[self selectedRowInComponent:0]];
    NSString *min = [NSString stringWithFormat:@"%02.f", (float)[self selectedRowInComponent:1]];
    NSString *sec = [NSString stringWithFormat:@"%02.f", (float)[self selectedRowInComponent:2]];
    NSString *newTime = [NSString stringWithFormat:@"%@:%@:%@", hours, min, sec];
    [self.customPickerDelegate didSelectNewTime:newTime];
    
    if (row == 0) {
        return ;
    }else{
        
        switch (component)
        {
            case 0:
                NSLog(@"selected = %@",[self.hours objectAtIndex:row]);
                break;
            case 1:
                NSLog(@"selected = %@",[self.minutes objectAtIndex:row]);
                break;
            case 2:
                NSLog(@"selected = %@",[self.seconds objectAtIndex:row]);
                break;
        }

    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
