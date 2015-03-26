//
//  QMChatHistoryCell.m
//  Q-municate
//
//  Created by Andrey Ivanov on 11.03.15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import "QMChatHistoryCell.h"
#import "QMImageView.h"

@interface QMChatHistoryCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet QMImageView *qmImgeView;

@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;

@end

@implementation QMChatHistoryCell

+ (NSString *)cellIdentifier {
    
    static NSString *cellIdentifier = @"QMChatHistoryCell";
    return cellIdentifier;
}

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.timeLabel.text = nil;
    self.subTitleLabel.text = nil;
}

- (void)setSubTitle:(NSString *)subTitle {
    
    if (![_subTitle isEqualToString:subTitle]) {
        
        _subTitle = subTitle;
        self.subTitleLabel.text = _subTitle;
    }
}

- (void)setTime:(NSString *)time {

    if (![_title isEqualToString:time]) {
        
        _title = time;
        self.timeLabel.text = _time;
    }
}

- (void)setImageWithUrl:(NSString *)url {
    
}

@end