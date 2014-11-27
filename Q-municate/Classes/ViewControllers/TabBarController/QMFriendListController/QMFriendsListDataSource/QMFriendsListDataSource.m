
//
//  QMFriendsListDataSource.m
//  Q-municate
//
//  Created by Andrey Ivanov on 4/3/14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMFriendsListDataSource.h"
#import "QMFriendListViewController.h"
#import "QMFriendListCell.h"
#import "QMUsersService.h"
#import "SVProgressHud.h"
#import "REAlertView.h"
#import "QMServicesManager.h"

@interface QMFriendsListDataSource()

<QMContactListServiceDelegate>

@property (strong, nonatomic) NSMutableArray *searchResult;
@property (strong, nonatomic) NSArray *friendList;

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UISearchDisplayController *searchDisplayController;

@property (assign, nonatomic) NSUInteger contactRequestsCount;

@end

@implementation QMFriendsListDataSource

@synthesize friendList = _friendList;

- (void)dealloc {
    ILog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (instancetype)initWithTableView:(UITableView *)tableView
          searchDisplayController:(UISearchDisplayController *)searchDisplayController {
    
    self = [super init];
    if (self) {
        
        self.searchResult = [NSMutableArray array];
        
        self.tableView = tableView;
        self.tableView.dataSource = self;
        
        self.searchDisplayController = searchDisplayController;
        
        [QM.contactListService addDelegate:self];
    
        UINib *friendsCellNib = [UINib nibWithNibName:@"QMFriendListCell" bundle:nil];
        UINib *noResultsCellNib = [UINib nibWithNibName:@"QMNoResultsCell" bundle:nil];
        
        [searchDisplayController.searchResultsTableView registerNib:friendsCellNib
                                             forCellReuseIdentifier:kQMFriendsListCellIdentifier];
        
        [searchDisplayController.searchResultsTableView registerNib:noResultsCellNib
                                             forCellReuseIdentifier:kQMDontHaveAnyFriendsCellIdentifier];
    }
    
    return self;
}

#pragma mark - QMContactListServiceDelegate

- (void)contactListService:(QMContactListService *)contactListService didAddUsers:(NSArray *)users {
    
}


//- (void)setFriendList:(NSArray *)friendList {
//    _friendList = [QMUsersUtils sortUsersByFullname:friendList];
//}

- (NSArray *)friendList {
    
    if (self.searchDisplayController.isActive && self.searchDisplayController.searchBar.text.length > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fullName CONTAINS[cd] %@", self.searchDisplayController.searchBar.text];
        NSArray *filtered = [_friendList filteredArrayUsingPredicate:predicate];
        
        return filtered;
    }
    
    return _friendList;
}

- (NSArray *)friends {

    NSArray *friendsIDS = [QM.contactListService.contactListMemoryStorage userIDsFromContactList];
    NSArray *friends = [QM.contactListService.usersMemoryStorage usersWithIDs:friendsIDS];
    
    return friends;
}

- (void)searchRequestWithSearchText:(NSString *)searchText responcePage:(QBGeneralResponsePage *)responcePage {
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [QBRequest usersWithFullName:searchText
                            page:responcePage
                    successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users)
     {
         [self.searchResult removeAllObjects];
         
         NSSortDescriptor *sorter =
         [[NSSortDescriptor alloc] initWithKey:@"fullName"
                                     ascending:YES
                                      selector:@selector(localizedCaseInsensitiveCompare:)];
         
         NSArray *sortedUsers = [users sortedArrayUsingDescriptors:@[sorter]];
         
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.ID != %d", QM.profile.userData.ID];
         NSArray *filtered = [sortedUsers filteredArrayUsingPredicate:predicate];
         
         [self.searchResult addObjectsFromArray:filtered];
         NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
         
         [self.searchDisplayController.searchResultsTableView reloadSections:indexSet
                                                            withRowAnimation:UITableViewRowAnimationNone];
         [SVProgressHUD dismiss];
         
     } errorBlock:^(QBResponse *response) {
         
         [SVProgressHUD dismiss];
     }];
}

- (void)globalSearch:(NSString *)searchText {
    
    if (searchText.length == 0) {
        
        [self.searchResult removeAllObjects];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
    else {
        
        __block NSString *tsearch = [searchText copy];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.searchDisplayController.searchBar.text isEqualToString:tsearch]) {
                
                QBGeneralResponsePage *generalResponcePage =
                [QBGeneralResponsePage responsePageWithCurrentPage:1
                                                           perPage:100];
                [self searchRequestWithSearchText:tsearch
                                     responcePage:generalResponcePage];
            }
        });
    }
}

- (void)setContactRequestsCount:(NSUInteger)contactRequestsCount
{
    if (_contactRequestsCount != contactRequestsCount) {
        
        _contactRequestsCount = contactRequestsCount;
        
        if ([self.delegate respondsToSelector:@selector(didChangeContactRequestsCount:)]) {
            [self.delegate didChangeContactRequestsCount:_contactRequestsCount];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *users = [self usersAtSections:section];
    
    if (self.searchDisplayController.isActive && section == 1) {
        return (users.count > 0) ? NSLocalizedString(@"QM_STR_ALL_USERS", nil) : nil;
    }
    
    return (users.count > 0) ? NSLocalizedString(@"QM_STR_CONTACTS", nil) : nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return (self.searchDisplayController.isActive) ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *users = [self usersAtSections:section];
    
    if (self.searchDisplayController.isActive) {
        return (users.count > 0) ? users.count : 0;
    }
    
    return (users.count > 0) ? users.count : 1;
}

- (NSArray *)usersAtSections:(NSInteger)section {
    
    return (section == 0) ? self.friendList : self.searchResult;
}

- (QBUUser *)userAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *users = [self usersAtSections:indexPath.section];
    QBUUser *user = users[indexPath.row];
    
    return user;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *users = [self usersAtSections:indexPath.section];
    
    if (!self.searchDisplayController.isActive) {
        if (users.count == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQMDontHaveAnyFriendsCellIdentifier];
            return cell;
        }
    }
    QMFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:kQMFriendsListCellIdentifier];
    cell.delegate = self;
    
    QBUUser *user = users[indexPath.row];
    
    cell.contactlistItem = [QM.contactListService.contactListMemoryStorage contactListItemWithUserID:user.ID];
    cell.userData = user;
    
    if (self.searchDisplayController.isActive) {
        cell.searchText = self.searchDisplayController.searchBar.text;
    }
    
    return cell;
}


#pragma mark - QMUsersListCellDelegate

- (void)usersListCell:(QMFriendListCell *)cell
          pressAddBtn:(UIButton *)sender {
    
    NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
    
    NSArray *datasource = [self usersAtSections:indexPath.section];
    QBUUser *user = datasource[indexPath.row];
    
    [QM.contactListService addUserToContactListRequest:user
                                            completion:^(BOOL success)
     {
         if (success) {
             
             if (self.searchDisplayController.isActive) {
                 
                 CGPoint point = self.searchDisplayController.searchResultsTableView.contentOffset;
                 
                 self.friendList = [self friends];
                 
                 [self.searchDisplayController.searchResultsTableView reloadData];
                 
                 [self.tableView reloadData];
                 
                 NSUInteger idx = [self.friendList indexOfObject:user];
                 NSUInteger idx2 = [self.searchResult indexOfObject:user];
                 
                 if (idx != NSNotFound && idx2 != NSNotFound) {
                     
                     point.y += 59;
                     self.searchDisplayController.searchResultsTableView.contentOffset = point;
                     
                     [SVProgressHUD dismiss];
                 }
             }
             else {
                 
             }
         }
     }];
}

#pragma mark - UISearchDisplayController

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self globalSearch:searchString];
    
    return NO;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    // needed!
    //    [self.tableView setDataSource:nil];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    //    [self.tableView setDataSource:self];
    [self.tableView reloadData];
}

@end
