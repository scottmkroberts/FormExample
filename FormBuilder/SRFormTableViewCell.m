//
//  SRFormTableViewCell.m
//  FormBuilder
//
//  Created by Scott Roberts on 22/05/2014.
//  Copyright (c) 2014 scottr. All rights reserved.
//

#import "SRFormTableViewCell.h"

@implementation SRFormTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - 200, 0, 120, CGRectGetHeight(self.contentView.frame))];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.textColor = [UIColor blueColor];
        [self.contentView addSubview: self.valueLabel];
    
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
