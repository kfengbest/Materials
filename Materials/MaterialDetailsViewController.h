//
//  MaterialDetailsViewController.h
//  Materials
//
//  Created by Kaven Feng on 3/5/14.
//  Copyright (c) 2014 Kaven Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong)NSString* uuid;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@end
