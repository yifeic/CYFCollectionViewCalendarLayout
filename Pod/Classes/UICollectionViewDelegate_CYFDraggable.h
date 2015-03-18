//
//  UICollectionViewDataSourceSelectable.h
//  CYFCollectionViewCalendarLayout
//
//  Created by Yifei Chen on 3/9/15.
//  Copyright (c) 2015 Robin Powered, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICollectionViewDelegate_CYFDraggable <UICollectionViewDelegate>
@required
- (UIView *)collectionView:(UICollectionView *)collectionView draggableViewForItemAtIndexPath:(NSIndexPath *)indexPath insets:(inout UIEdgeInsets *)insets;
- (void)collectionView:(UICollectionView *)collectionView draggableViewDidMove:(UIView *)draggableView;

- (void)collectionView:(UICollectionView *)collectionView draggableViewWillEndDragging:(UIView *)draggableView targetYPosition:(inout CGFloat *)targetYPosition cancel:(inout BOOL *)cancelDragging;

- (void)collectionView:(UICollectionView *)collectionView draggableViewDidEndDeceleratingForDragging:(UIView *)draggableView;

- (void)collectionView:(UICollectionView *)collectionView draggableViewDidResize:(UIView *)draggableView;

- (void)collectionView:(UICollectionView *)collectionView draggableViewWillEndResizing:(UIView *)draggableView targetYPosition:(inout CGFloat *)targetYPosition cancel:(inout BOOL *)cancelResizing;

- (void)collectionView:(UICollectionView *)collectionView draggableViewDidEndDeceleratingForResizing:(UIView *)draggableView;

- (BOOL)collectionView:(UICollectionView *)collectionView shouldResizeDraggableView:(UIView *)draggableView;

- (CGFloat)collectionView:(UICollectionView *)collectionView resizeMinHeightOfDraggableView:(UIView *)draggableView;

- (CGFloat)autoScrollEdgeHeightInCollectionView:(UICollectionView *)collectionView;
- (CGFloat)autoScrollSpeedInCollectionView:(UICollectionView *)collectionView;

- (CGRect)boundaryOfDragAreaInCollectionView:(UICollectionView *)collectionView;

@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView resizeAreaHeightOfDraggableView:(UIView *)draggableView;

@end
