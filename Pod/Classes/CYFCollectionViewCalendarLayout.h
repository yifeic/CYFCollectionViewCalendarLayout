//
//  CYFCollectionViewAbsoluteVerticalLayout.h
//  CYFCollectionViewCalendarLayout
//
//  Created by Victor on 3/10/15.
//  Copyright (c) 2015 Robin Powered, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CYFCollectionViewDelegateCalendarLayout <UICollectionViewDelegate>
@required
- (CGRect)collectionView:(UICollectionView *)collectionView frameForEventAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)timeScalesInCollectionView:(UICollectionView *)collectionView;

@end


@interface CYFCollectionViewCalendarLayout : UICollectionViewLayout

// row is index of timeSlot, section is index of timeScale
- (NSIndexPath *)indexPathOfClosestTimeSlotToPoint:(CGPoint)point;
- (CGRect)frameOfTimeSlotAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic) UIEdgeInsets timeScaleLineInsets;
@property (nonatomic) UIEdgeInsets eventCellInsets;
@property (nonatomic) CGPoint timeScaleLabelOffset;
@property (nonatomic) CGFloat timeScaleLineVerticalSpacing;
@property (nonatomic) NSInteger numberOfTimeSlotsBetweenTimeScales;
@property (nonatomic) CGFloat timeScaleLineWidth;

@end
