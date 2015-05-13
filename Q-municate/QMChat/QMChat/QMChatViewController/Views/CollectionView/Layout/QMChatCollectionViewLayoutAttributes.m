//
//  QMChatCollectionViewLayoutAttributes.m
//  QMChat
//
//  Created by Andrey Ivanov on 20.04.15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import "QMChatCollectionViewLayoutAttributes.h"

@implementation QMChatCollectionViewLayoutAttributes

#pragma mark - Lifecycle

- (void)dealloc {
    
    _messageBubbleFont = nil;
}

#pragma mark - Setters
- (void)setMessageBubbleFont:(UIFont *)messageBubbleFont {
    
    NSParameterAssert(messageBubbleFont != nil);
    _messageBubbleFont = messageBubbleFont;
}

- (void)setMessageBubbleContainerViewWidth:(CGFloat)messageBubbleContainerViewWidth {
    
    NSParameterAssert(messageBubbleContainerViewWidth > 0.0f);
    _messageBubbleContainerViewWidth = ceilf(messageBubbleContainerViewWidth);
}

- (void)setIncomingAvatarViewSize:(CGSize)incomingAvatarViewSize {
    
    NSParameterAssert(incomingAvatarViewSize.width >= 0.0f && incomingAvatarViewSize.height >= 0.0f);
    _incomingAvatarViewSize = [self correctedAvatarSizeFromSize:incomingAvatarViewSize];
}

- (void)setOutgoingAvatarViewSize:(CGSize)outgoingAvatarViewSize {
    
    NSParameterAssert(outgoingAvatarViewSize.width >= 0.0f && outgoingAvatarViewSize.height >= 0.0f);
    _outgoingAvatarViewSize = [self correctedAvatarSizeFromSize:outgoingAvatarViewSize];
}

- (void)setCellTopLabelHeight:(CGFloat)cellTopLabelHeight {
    
    NSParameterAssert(cellTopLabelHeight >= 0.0f);
    _cellTopLabelHeight = [self correctedLabelHeightForHeight:cellTopLabelHeight];
}

- (void)setCellBottomLabelHeight:(CGFloat)cellBottomLabelHeight {
    
    NSParameterAssert(cellBottomLabelHeight >= 0.0f);
    _cellBottomLabelHeight = [self correctedLabelHeightForHeight:cellBottomLabelHeight];
}

- (void)setMessageBubbleBottomLabelHeight:(CGFloat)messageBubbleBottomLabelHeight {
    
    NSParameterAssert(messageBubbleBottomLabelHeight >= 0.0f);
    _messageBubbleBottomLabelHeight = [self correctedLabelHeightForHeight:messageBubbleBottomLabelHeight];
}

- (void)setMessageBubbleTopLabelHeight:(CGFloat)messageBubbleTopLabelHeight {
    
    NSParameterAssert(messageBubbleTopLabelHeight >= 0.0f);
    _messageBubbleTopLabelHeight = [self correctedLabelHeightForHeight:messageBubbleTopLabelHeight];
}

#pragma mark - Utilities

- (CGSize)correctedAvatarSizeFromSize:(CGSize)size {
    
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (CGFloat)correctedLabelHeightForHeight:(CGFloat)height {
    
    return ceilf(height);
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        
        return NO;
    }
    
    if (self.representedElementCategory == UICollectionElementCategoryCell) {
        
        QMChatCollectionViewLayoutAttributes *layoutAttributes = (QMChatCollectionViewLayoutAttributes *)object;
        
        if (![layoutAttributes.messageBubbleFont isEqual:self.messageBubbleFont]
            || !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewFrameInsets, self.textViewFrameInsets)
            || !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewTextContainerInsets, self.textViewTextContainerInsets)
            || !CGSizeEqualToSize(layoutAttributes.incomingAvatarViewSize, self.incomingAvatarViewSize)
            || !CGSizeEqualToSize(layoutAttributes.outgoingAvatarViewSize, self.outgoingAvatarViewSize)
            || (int)layoutAttributes.messageBubbleContainerViewWidth != (int)self.messageBubbleContainerViewWidth
            || (int)layoutAttributes.cellTopLabelHeight != (int)self.cellTopLabelHeight
            || (int)layoutAttributes.messageBubbleTopLabelHeight != (int)self.messageBubbleTopLabelHeight
            || (int)layoutAttributes.messageBubbleBottomLabelHeight != (int)self.messageBubbleBottomLabelHeight
            || (int)layoutAttributes.cellBottomLabelHeight != (int)self.cellBottomLabelHeight) {
            
            return NO;
        }
    }
    
    return [super isEqual:object];
}

- (NSUInteger)hash {
    
    return [self.indexPath hash];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    
    QMChatCollectionViewLayoutAttributes *copy = [super copyWithZone:zone];
    
    if (copy.representedElementCategory != UICollectionElementCategoryCell) {
        
        return copy;
    }
    
    copy.messageBubbleFont = self.messageBubbleFont;
    copy.messageBubbleContainerViewWidth = self.messageBubbleContainerViewWidth;
    copy.textViewFrameInsets = self.textViewFrameInsets;
    copy.textViewTextContainerInsets = self.textViewTextContainerInsets;
    copy.incomingAvatarViewSize = self.incomingAvatarViewSize;
    copy.outgoingAvatarViewSize = self.outgoingAvatarViewSize;
    copy.cellTopLabelHeight = self.cellTopLabelHeight;
    copy.cellBottomLabelHeight = self.cellBottomLabelHeight;
    copy.messageBubbleTopLabelHeight = self.messageBubbleTopLabelHeight;
    copy.messageBubbleBottomLabelHeight = self.messageBubbleBottomLabelHeight;
    
    return copy;
}

@end
