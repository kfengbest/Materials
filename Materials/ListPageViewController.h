//
//  ListPageViewController.h
//  Materials
//
//  Created by Kaven Feng on 3/13/14.
//  Copyright (c) 2014 Kaven Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWLoadMoreTableFooterView.h"

@interface ListPageViewController : UITableViewController<PWLoadMoreTableFooterDelegate>
@property (nonatomic,strong)NSString* classification;
@property (nonatomic, assign)NSInteger totalSize;

@end
