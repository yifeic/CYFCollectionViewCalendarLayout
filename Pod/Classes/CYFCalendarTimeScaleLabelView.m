//
//  CYFCalendarTimeScaleLabelView.m
//  CYFCollectionViewCalendarLayout
//
//  Created by Victor on 3/10/15.
//  Copyright (c) 2015 Robin Powered, Inc. All rights reserved.
//

#import "CYFCalendarTimeScaleLabelView.h"


@implementation CYFCalendarTimeScaleLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _timeScaleLabel = [[UILabel alloc] init];
        _timeScaleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_timeScaleLabel];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[label]|" options:0 metrics:nil views:@{@"label": _timeScaleLabel}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]" options:0 metrics:nil views:@{@"label": _timeScaleLabel}]];
    }
    return self;
}

+ (NSString *)kind {
    return @"kSupplementaryViewKindTimeScaleLabel";
}

@end
