//
//  QMSearchChatHistoryDatasource.h
//  Q-municate
//
//  Created by Andrey Ivanov on 11.03.15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMSearchChatHistoryDatasource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSString *searchText;

@property (assign, nonatomic) BOOL loading;
@property (strong, nonatomic, readonly) NSMutableArray *collection;

- (void)setObjects:(NSArray *)objects;
- (QBGeneralResponsePage *)responsePage;
- (void)updateCurrentPageWithResponcePage:(QBGeneralResponsePage *)page;

@end
