//
//  UIColor+SRColors.h
//  SRCalendarCollectionView
//
//  Created by Scott Roberts on 07/05/2014.
//  Copyright (c) 2014 scottr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SRColors)

+(UIColor *)primaryColor;
+(UIColor *)secondaryColor;
+(UIColor *)backgroundColor;


+ (UIColor *) colorWithHexString:(NSString *)hex;
+ (UIColor *) colorWithHexValue: (NSInteger) hex;

@end
