//
//  CYFCollectionViewAbsoluteVerticalLayout.m
//  CYFCollectionViewCalendarLayout
//
//  Created by Victor on 3/10/15.
//  Copyright (c) 2015 Robin Powered, Inc. All rights reserved.
//

#import "CYFCollectionViewCalendarLayout.h"
#import "CYFCalendarTimeScaleLineView.h"
#import "CYFCalendarTimeScaleLabelView.h"

@interface CYFCollectionViewCalendarLayout ()

@property (nonatomic, strong) NSMutableDictionary *indexPathToAttributes;

@property (nonatomic) CGSize contentSize;

@property (nonatomic, strong) NSArray *timeScaleLineLayoutAttributes;
@property (nonatomic, strong) NSArray *timeScaleLabelLayoutAttributes;

@end

@implementation CYFCollectionViewCalendarLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    NSArray *timeScales = @[];
    
    if ([self.collectionView.delegate respondsToSelector:@selector(timeScalesInCollectionView:)]) {
        timeScales = [(id<CYFCollectionViewDelegateCalendarLayout>)self.collectionView.delegate timeScalesInCollectionView:self.collectionView];
    }
    
    UIEdgeInsets timeScaleLineInsects = self.timeScaleLineInsects;
    
    CGPoint timeScaleLabelOffset = self.timeScaleLabelOffset;
    
    CGFloat timeScaleLineVerticalSpacing = self.timeScaleLineVerticalSpacing;
    
    NSInteger numberOfTimeSlots = self.numberOfTimeSlotsBetweenTimeScales;
    
    CGFloat timeScaleLineWidth = self.timeScaleLineWidth;
    
    CGFloat contentHeight = timeScales.count * (timeScaleLineVerticalSpacing+timeScaleLineWidth) - timeScaleLineVerticalSpacing - timeScaleLineWidth + timeScaleLineInsects.top + timeScaleLineInsects.bottom;
    self.contentSize = CGSizeMake(0, contentHeight);
    
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
    
    CGFloat timeScaleLineY = timeScaleLineInsects.top;
    
    NSMutableArray *timeScaleLineLayoutAttributes = [NSMutableArray arrayWithCapacity:timeScales.count];
    NSMutableArray *timeScaleLabelLayoutAttributes = [NSMutableArray arrayWithCapacity:timeScales.count];
    
    for (int i = 0; i < timeScales.count; i++) {
        
        UICollectionViewLayoutAttributes *timeScaleLineAttr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:[CYFCalendarTimeScaleLineView kind] withIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        timeScaleLineAttr.frame = CGRectMake(timeScaleLineInsects.left, timeScaleLineY, collectionViewWidth-timeScaleLineInsects.left, timeScaleLineWidth);
        [timeScaleLineLayoutAttributes addObject:timeScaleLineAttr];
        
        UICollectionViewLayoutAttributes *timeScaleLabelAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:[CYFCalendarTimeScaleLabelView kind] withIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        timeScaleLabelAttr.frame = CGRectMake(timeScaleLabelOffset.x, timeScaleLineY+timeScaleLabelOffset.y, timeScaleLineInsects.left, 30);
        [timeScaleLabelLayoutAttributes addObject:timeScaleLabelAttr];
        
        timeScaleLineY += timeScaleLineVerticalSpacing+timeScaleLineWidth;
    }
    
    self.timeScaleLineLayoutAttributes = timeScaleLineLayoutAttributes;
    self.timeScaleLabelLayoutAttributes = timeScaleLabelLayoutAttributes;
    
    self.indexPathToAttributes = [NSMutableDictionary dictionaryWithCapacity:20];
    
    NSInteger sectionCount = 1;
    if ([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sectionCount = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    
    for (int i = 0; i < sectionCount; i++) {
        NSInteger itemCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:i];
        
        for (int j = 0; j < itemCount; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            CGRect itemFrame = [(id<CYFCollectionViewDelegateCalendarLayout>)self.collectionView.delegate collectionView:self.collectionView frameForEventAtIndexPath:indexPath];
            CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
            itemFrame = CGRectMake(timeScaleLineInsects.left, itemFrame.origin.y, collectionViewWidth, itemFrame.size.height);
            
            
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attr.frame = itemFrame;
            [self.indexPathToAttributes setObject:attr forKey:indexPath];
        }
    }
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"DecorationViewOfKind %@ at %ld", elementKind, (long)indexPath.item);
    if ([elementKind isEqualToString:[CYFCalendarTimeScaleLineView kind]]) {
        return self.timeScaleLineLayoutAttributes[indexPath.item];
    }
    
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"SupplementaryViewOfKind %@ at %ld", elementKind, (long)indexPath.item);
    if ([elementKind isEqualToString:[CYFCalendarTimeScaleLabelView kind]]) {
        return self.timeScaleLabelLayoutAttributes[indexPath.item];
    }
    
    return nil;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:20];

    for (int i = 0; i < self.timeScaleLabelLayoutAttributes.count; i++) {
        UICollectionViewLayoutAttributes *labelAttrs = self.timeScaleLabelLayoutAttributes[i];
        
        CGRect frame = labelAttrs.frame;
        
        if (frame.origin.y+frame.size.height < rect.origin.y || frame.origin.y > rect.origin.y+rect.size.height) {
            continue;
        }

        [result addObject:labelAttrs];
        [result addObject:self.timeScaleLineLayoutAttributes[i]];
    }
    
    
    for (NSIndexPath *indexPath in self.indexPathToAttributes) {
        UICollectionViewLayoutAttributes *attr = self.indexPathToAttributes[indexPath];
        CGRect frame = attr.frame;
        
        if (frame.origin.y+frame.size.height < rect.origin.y || frame.origin.y > rect.origin.y+rect.size.height) {
            continue;
        }
        
        [result addObject:attr];
    }

    return result;
}

- (NSIndexPath *)indexPathOfClosestTimeSlotToPoint:(CGPoint)point {
    
    CGFloat y = point.y;
    y -= self.timeScaleLineInsects.top;
    y = MAX(y, 0);
    
    NSUInteger indexOfTimeScale = y / (self.timeScaleLineVerticalSpacing+self.timeScaleLineWidth);
    
    y -= indexOfTimeScale * (self.timeScaleLineVerticalSpacing+self.timeScaleLineWidth);
    
    y -= self.timeScaleLineWidth;
    
    CGFloat slotHeight = self.timeScaleLineVerticalSpacing/self.numberOfTimeSlotsBetweenTimeScales;
    
    NSUInteger indexOfTimeSlot = y / slotHeight;
    
    y -= indexOfTimeSlot * slotHeight;
    
    if (y > slotHeight/2.0) {
        indexOfTimeSlot++;
    }
    
    if (indexOfTimeSlot == self.numberOfTimeSlotsBetweenTimeScales) {
        indexOfTimeSlot = 0;
        indexOfTimeScale++;
    }
    
    return [NSIndexPath indexPathForRow:indexOfTimeSlot inSection:indexOfTimeScale];
}

- (CGRect)frameOfTimeSlotAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger timeScaleIndex = indexPath.section;
    NSUInteger timeSlotIndex = indexPath.row;
    
    UICollectionViewLayoutAttributes *labelAttrs = self.timeScaleLabelLayoutAttributes[timeScaleIndex];
    CGRect frame = labelAttrs.frame;
    
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y+self.timeScaleLineVerticalSpacing/self.numberOfTimeSlotsBetweenTimeScales*timeSlotIndex);
    
    return frame;
}

@end
