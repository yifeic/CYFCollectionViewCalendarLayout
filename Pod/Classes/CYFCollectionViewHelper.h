//
//  CYFCollectionViewHelper.h
//  CYFCollectionViewCalendarLayout
//
//  Created by Yifei Chen on 3/9/15.
//  Copyright (c) 2015 Robin Powered, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYFCollectionViewHelper : NSObject

- (id)initWithCollectionView:(UICollectionView *)collectionView;
@property (nonatomic, weak, readonly) UICollectionView *collectionView;
@property (nonatomic, readonly) UIGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, readonly) UIGestureRecognizer *panGestureRecognizer;

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)deselectItem;

@end
