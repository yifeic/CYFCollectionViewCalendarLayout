//
//  CYFCollectionViewHelper.m
//  CYFCollectionViewCalendarLayout
//
//  Created by Yifei Chen on 3/9/15.
//  Copyright (c) 2015 Robin Powered, Inc. All rights reserved.
//

#import "CYFCollectionViewHelper.h"
#import "UICollectionViewDelegate_CYFDraggable.h"

@interface CYFCollectionViewHelper () <UIGestureRecognizerDelegate>

@property (nonatomic ,strong) UIView *selectedView;
@property (nonatomic ,strong) NSIndexPath *selectedItemIndexPath;
@property (nonatomic) CGPoint selectedViewOriginalCenter;
@property (nonatomic) CGFloat selectedViewOriginalHeight;
@property (nonatomic) BOOL decelerating;

@property (nonatomic) BOOL resizing;
@property (nonatomic) CGFloat resizeMinHeight;

@end

@implementation CYFCollectionViewHelper

- (id)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handlePanGesture:)];
        _panGestureRecognizer.delegate = self;

        [_collectionView addGestureRecognizer:_panGestureRecognizer];

        [collectionView.panGestureRecognizer requireGestureRecognizerToFail:_panGestureRecognizer];
        
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isEqual:self.panGestureRecognizer]) {
        
        if (self.selectedItemIndexPath == nil || self.selectedView == nil || self.decelerating) {
            return NO;
        }
        
        CGPoint location = [gestureRecognizer locationInView:self.selectedView];
        return [self.selectedView pointInside:location withEvent:nil];
    }
    
    return YES;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    if (self.selectedItemIndexPath == nil || self.selectedView == nil) {
        return;
    }
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
        
            CGPoint location = [sender locationInView:self.selectedView];
            
            BOOL shouldResize = NO;
            if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:shouldResizeDraggableView:)]) {
                shouldResize = [(id<UICollectionViewDelegate_CYFDraggable>)self.collectionView.delegate collectionView:self.collectionView shouldResizeDraggableView:self.selectedView];
            }
            
            if (shouldResize) {
                CGFloat resizeAreaHeight = 30;
                if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:resizeAreaHeightOfDraggableView:)]) {
                    resizeAreaHeight = [(id<UICollectionViewDelegate_CYFDraggable>)self.collectionView.delegate collectionView:self.collectionView resizeAreaHeightOfDraggableView:self.selectedView];
                }
                
                CGFloat del = self.selectedView.bounds.size.height - location.y;
                if (del < resizeAreaHeight) {
                    self.resizing = YES;
                    self.selectedViewOriginalHeight = self.selectedView.bounds.size.height;
                    
                    self.resizeMinHeight = [(id<UICollectionViewDelegate_CYFDraggable>)self.collectionView.delegate collectionView:self.collectionView resizeMinHeightOfDraggableView:self.selectedView];
                    break;
                }
            }
            
            self.selectedViewOriginalCenter = self.selectedView.center;
            
        } break;
        case UIGestureRecognizerStateChanged: {
            
            CGPoint translation = [sender translationInView:self.collectionView];
            if (self.resizing) {
                
                CGFloat height = self.selectedViewOriginalHeight + translation.y;
                height = MAX(self.resizeMinHeight, height);
                self.selectedView.frame = CGRectMake(self.selectedView.frame.origin.x, self.selectedView.frame.origin.y, self.selectedView.frame.size.width, height);
                [(id<UICollectionViewDelegate_CYFDraggable>)self.collectionView.delegate collectionView:self.collectionView draggableViewDidResize:self.selectedView];
            }
            else {
                
                self.selectedView.center = CGPointMake(self.selectedViewOriginalCenter.x, self.selectedViewOriginalCenter.y+translation.y);
                [(id<UICollectionViewDelegate_CYFDraggable>)self.collectionView.delegate collectionView:self.collectionView draggableViewDidMove:self.selectedView];
            }
            
        } break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            if (self.resizing) {
                self.resizing = NO;
                
                CGFloat targetYPosition = -1;
                BOOL cancel = NO;
                [(id<UICollectionViewDelegate_CYFDraggable>)self.collectionView.delegate collectionView:self.collectionView draggableViewWillEndResizing:self.selectedView targetYPosition:&targetYPosition cancel:&cancel];
                
                if (cancel) {
                    targetYPosition = self.selectedView.frame.origin.y + self.selectedViewOriginalHeight;
                }
                
                if (targetYPosition > self.selectedView.frame.origin.y) {
                    self.decelerating = YES;
                    
                    [UIView animateWithDuration:0.15 animations:^{
                        self.selectedView.frame = CGRectMake(self.selectedView.frame.origin.x, self.selectedView.frame.origin.y, self.selectedView.frame.size.width, targetYPosition - self.selectedView.frame.origin.y);
                    } completion:^(BOOL finished) {
                        self.decelerating = NO;
                        [(id<UICollectionViewDelegate_CYFDraggable>)self.collectionView.delegate collectionView:self.collectionView draggableViewDidEndDeceleratingForResizing:self.selectedView];
                    }];
                }
            }
            else {
                CGFloat targetYPosition = -1;
                BOOL cancel = NO;
                [(id<UICollectionViewDelegate_CYFDraggable>)self.collectionView.delegate collectionView:self.collectionView draggableViewWillEndDragging:self.selectedView targetYPosition:&targetYPosition cancel:&cancel];
                
                if (cancel) {
                    self.decelerating = YES;
                    [UIView animateWithDuration:0.15 animations:^{
                        self.selectedView.center = self.selectedViewOriginalCenter;
                    } completion:^(BOOL finished) {
                        self.decelerating = NO;
                        [(id<UICollectionViewDelegate_CYFDraggable>)self.collectionView.delegate collectionView:self.collectionView draggableViewDidEndDeceleratingForDragging:self.selectedView];
                    }];
                }
                else if (targetYPosition >= 0) {
                    self.decelerating = YES;
                    [UIView animateWithDuration:0.15 animations:^{
                        self.selectedView.frame = CGRectMake(self.selectedView.frame.origin.x, targetYPosition, self.selectedView.frame.size.width, self.selectedView.frame.size.height);
                    } completion:^(BOOL finished) {
                        self.decelerating = NO;
                        [(id<UICollectionViewDelegate_CYFDraggable>)self.collectionView.delegate collectionView:self.collectionView draggableViewDidEndDeceleratingForDragging:self.selectedView];
                    }];
                }
            }
            
        } break;
            
        default:
            break;
    }
    
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:draggableViewForItemAtIndexPath:insets:)]) {
        
        self.selectedItemIndexPath = indexPath;
        
        [self.selectedView removeFromSuperview];
        UIEdgeInsets insets = UIEdgeInsetsZero;
        self.selectedView = [(id<UICollectionViewDelegate_CYFDraggable>)self.collectionView.delegate collectionView:self.collectionView draggableViewForItemAtIndexPath:indexPath insets:&insets];
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        self.selectedView.frame = UIEdgeInsetsInsetRect(cell.frame, insets);
        
        [self.collectionView addSubview:self.selectedView];
    }
}

- (void)deselectItem {
    self.selectedItemIndexPath = nil;
    [self.selectedView removeFromSuperview];
    self.selectedView = nil;
}

@end
