//
//  UIColor+SRColors.h
//  SRCalendarCollectionView
//
//  Created by Scott Roberts on 07/05/2014.
//  Copyright (c) 2014 scottr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SRColors)


+(UIColor *)backgroundColor;
+(UIColor *) colorWithHexString:(NSString *)hex;
+(UIColor *) colorWithHexValue: (NSInteger) rgbValue;

@end
