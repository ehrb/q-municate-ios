//
//  QMChatToolbarContentView.m
//  Qmunicate
//
//  Created by Andrey on 20.06.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMChatToolbarContentView.h"
#import "QMChatInputTextView.h"
#import "Parus.h"

@interface QMChatToolbarContentView()

@property (strong, nonatomic) UIView *leftBarButtonContainerView;
@property (strong, nonatomic) UIView *rightBarButtonContainerView;
@property (strong, nonatomic) QMChatInputTextView *textView;

@property (strong, nonatomic) NSLayoutConstraint *rightBarButtonContainerViewWidthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *leftBarButtonContainerViewWidthConstraint;

@end

@implementation QMChatToolbarContentView

#pragma mark - Initialization

#define DEBUG_COLORS 0


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureChatToolbarContentView];
       
        self.leftBarButtonItem = nil;
        self.rightBarButtonItem = nil;
        
#if DEBUG_COLORS
        self.leftBarButtonContainerView.backgroundColor = [UIColor redColor];
        self.rightBarButtonContainerView.backgroundColor = [UIColor greenColor];
#endif
    }
    
    return self;
}

- (void)dealloc {
    
    _textView = nil;
    _leftBarButtonItem = nil;
    _rightBarButtonItem = nil;
    _leftBarButtonContainerView = nil;
    _rightBarButtonContainerView = nil;
}

- (void)configureChatToolbarContentView {
    
    self.leftBarButtonContainerView = [[UIView alloc] init];
    self.rightBarButtonContainerView = [[UIView alloc] init];
    self.textView = [[QMChatInputTextView alloc] init];
    
    self.textView.placeHolder = @"input text here...";
    self.textView.placeHolderTextColor = [UIColor grayColor];
    
    [self addSubview:self.leftBarButtonContainerView];
    [self addSubview:self.textView];
    [self addSubview:self.rightBarButtonContainerView];
    
    [self configureConstraints];
}

- (void)configureConstraints {
    
    CGFloat margin = 6.f;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.leftBarButtonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.rightBarButtonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *lView = self.leftBarButtonContainerView;
    UIView *cView = self.textView;
    UIView *rView = self.rightBarButtonContainerView;
    
    [self addConstraints:PVGroup(@[ PVLeftOf(lView).equalTo.leftOf(self).plus(margin).asConstraint,
                                    PVLeftOf(cView).equalTo.rightOf(lView).plus(margin).asConstraint,
                                    PVRightOf(cView).equalTo.leftOf(rView).minus(margin).asConstraint,
                                    PVRightOf(rView).equalTo.rightOf(self).minus(margin).asConstraint,
                                    /*Boottom*/
                                    PVBottomOf(lView).equalTo.bottomOf(self).minus(12).asConstraint,
                                    PVBottomOf(cView).equalTo.bottomOf(self).minus(margin).asConstraint,
                                    PVBottomOf(rView).equalTo.bottomOf(self).minus(margin).asConstraint,
                                    /*Top*/
                                    PVTopOf(cView).equalTo.topOf(self).plus(margin).asConstraint]).asArray];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    
    [super setBackgroundColor:backgroundColor];
    self.leftBarButtonContainerView.backgroundColor = backgroundColor;
    self.rightBarButtonContainerView.backgroundColor = backgroundColor;
}

- (void)setLeftBarButtonItem:(UIButton *)leftBarButtonItem {
    
    if (_leftBarButtonItem) {
        [_leftBarButtonItem removeFromSuperview];
    }
    
    if (!leftBarButtonItem) {
        
        self.leftBarButtonItemWidth = 0.0f;
        _leftBarButtonItem = nil;
        self.leftBarButtonContainerView.hidden = YES;
        return;
    }
    
    leftBarButtonItem.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.leftBarButtonContainerView.hidden = NO;
    
    [self.leftBarButtonContainerView addSubview:leftBarButtonItem];
    [self pinAllEdgesOfSubview:leftBarButtonItem ofView:self.leftBarButtonContainerView];
    [self setNeedsUpdateConstraints];
    
    _leftBarButtonItem = leftBarButtonItem;
}

- (void)setLeftBarButtonItemWidth:(CGFloat)leftBarButtonItemWidth {
    
    self.leftBarButtonContainerViewWidthConstraint.constant = leftBarButtonItemWidth;
    [self setNeedsUpdateConstraints];
}

- (void)setRightBarButtonItem:(UIButton *)rightBarButtonItem {
    
    if (_rightBarButtonItem) {
        [_rightBarButtonItem removeFromSuperview];
    }
    
    if (!rightBarButtonItem) {
        
        self.rightBarButtonItemWidth = 0.0f;
        _rightBarButtonItem = nil;
        self.rightBarButtonContainerView.hidden = YES;
        return;
    }
    
    rightBarButtonItem.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.rightBarButtonContainerView.hidden = NO;
    
    [self.rightBarButtonContainerView addSubview:rightBarButtonItem];
    [self pinAllEdgesOfSubview:rightBarButtonItem ofView:self.rightBarButtonContainerView];
    [self setNeedsUpdateConstraints];
    
    _rightBarButtonItem = rightBarButtonItem;
}

- (void)pinAllEdgesOfSubview:(UIView *)subview ofView:(UIView *)view {
    
    [self addConstraints:PVGroup(@[
                                   PVTopOf(subview).equalTo.topOf(view).asConstraint,
                                   PVLeftOf(subview).equalTo.leftOf(view).asConstraint,
                                   PVBottomOf(subview).equalTo.bottomOf(view).asConstraint,
                                   PVRightOf(subview).equalTo.rightOf(view).asConstraint,
                                   ]).asArray];
}

- (void)setRightBarButtonItemWidth:(CGFloat)rightBarButtonItemWidth {
    
    self.rightBarButtonContainerViewWidthConstraint.constant = rightBarButtonItemWidth;
    [self setNeedsUpdateConstraints];
}

#pragma mark - Getters

- (CGFloat)leftBarButtonItemWidth {
    
    return self.leftBarButtonContainerViewWidthConstraint.constant;
}

- (CGFloat)rightBarButtonItemWidth {
    
    return self.rightBarButtonContainerViewWidthConstraint.constant;
}

#pragma mark - UIView overrides

- (void)setNeedsDisplay {
    
    [super setNeedsDisplay];
    [self.textView setNeedsDisplay];
}

@end
