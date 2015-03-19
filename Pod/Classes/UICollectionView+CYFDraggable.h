//
//  UICollectionView+CYFSelectable.h
//  CYFCollectionViewCalendarLayout
//
//  Created by Yifei Chen on 3/9/15.
//  Copyright (c) 2015 Robin Powered, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (CYFDraggable)

/// Current draggable view
- (UIView *)selectedView;

/// Create a draggable view above the cell
- (void)cyf_startDraggingCellAtIndexPath:(NSIndexPath *)indexPath;

@end
