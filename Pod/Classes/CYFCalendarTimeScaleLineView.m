//
//  CYFCalendarTimeScaleLineView.m
//  CYFCollectionViewCalendarLayout
//
//  Created by Victor on 3/10/15.
//  Copyright (c) 2015 Robin Powered, Inc. All rights reserved.
//

#import "CYFCalendarTimeScaleLineView.h"

@implementation CYFCalendarTimeScaleLineView

+ (NSString *)kind {
    return @"kDecorationViewKindTimeScaleLine";
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

@end
