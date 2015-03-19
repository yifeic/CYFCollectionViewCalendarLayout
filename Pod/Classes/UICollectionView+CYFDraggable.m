//
//  UICollectionView+CYFSelectable.m
//  CYFCollectionViewCalendarLayout
//
//  Created by Yifei Chen on 3/9/15.
//  Copyright (c) 2015 Robin Powered, Inc. All rights reserved.
//

#import "UICollectionView+CYFDraggable.h"
#import "CYFCollectionViewHelper.h"
#import <objc/runtime.h>

@implementation UICollectionView (CYFDraggable)

- (CYFCollectionViewHelper *)helper
{
    CYFCollectionViewHelper *helper = objc_getAssociatedObject(self, "CYFCollectionViewHelper");
    if(helper == nil) {
        helper = [[CYFCollectionViewHelper alloc] initWithCollectionView:self];
        objc_setAssociatedObject(self, "CYFCollectionViewHelper", helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return helper;
}

- (void)cyf_startDraggingCellAtIndexPath:(NSIndexPath *)indexPath {
    [self.helper selectItemAtIndexPath:indexPath];
}

- (UIView *)selectedView {
    return self.helper.selectedView;
}

@end
