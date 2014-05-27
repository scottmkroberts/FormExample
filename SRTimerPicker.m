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
        [timeHours addObject:@"Hours"];
        for (int i = 0; i < 24; i++) {
            [timeHours addObject:[NSString stringWithFormat:@"%i", i]];
        }
        self.hours = [timeHours copy];
        
        //Minutes
        NSMutableArray *timeMinutes = [[NSMutableArray alloc] init];
        [timeMinutes addObject:@"Minutes"];
        for (int i = 0; i < 60; i++) {
            [timeMinutes addObject:[NSString stringWithFormat:@"%i", i]];
        }
        self.minutes = [timeMinutes copy];
        
        //Seconds
        NSMutableArray *timeSeconds = [[NSMutableArray alloc] init];
        [timeSeconds addObject:@"Seconds"];
        for (int i = 0; i < 60; i++) {
            [timeSeconds addObject:[NSString stringWithFormat:@"%i", i]];
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
            return [self.hours objectAtIndex:row];
            break;
        case 1:
            return [self.minutes objectAtIndex:row];
            break;
        case 2:
            return [self.seconds objectAtIndex:row];
            break;
    }
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 1)
        return self.hours.count;
    else if(component == 2)
        return self.minutes.count;
    else
        return self.seconds.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}


#pragma mark -
#pragma mark Picker view delegate

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        return ;
    }else{
        
        switch (component)
        {
            case 0:
                DLog(@"selected = %@",[self.hours objectAtIndex:row]);
                break;
            case 1:
                DLog(@"selected = %@",[self.minutes objectAtIndex:row]);
                break;
            case 2:
                DLog(@"selected = %@",[self.seconds objectAtIndex:row]);
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
