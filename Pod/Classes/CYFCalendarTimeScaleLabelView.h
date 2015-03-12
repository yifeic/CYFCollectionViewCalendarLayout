//
//  CYFCalendarTimeScaleLabelView.h
//  CYFCollectionViewCalendarLayout
//
//  Created by Victor on 3/10/15.
//  Copyright (c) 2015 Robin Powered, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CYFCalendarTimeScaleLabelView : UICollectionReusableView

@property (nonatomic, readonly, strong) UILabel *timeScaleLabel;

+ (NSString *)kind;

@end
