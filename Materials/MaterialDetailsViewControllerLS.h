//
//  MaterialDetailsViewControllerLS.h
//  Materials
//
//  Created by Kaven Feng on 3/25/14.
//  Copyright (c) 2014 Kaven Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialDetailsViewControllerLS : UIViewController<UITableViewDataSource, UITableViewDelegate>

- (IBAction)onSegmentChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentCtrl;
@property (nonatomic,strong)NSString* contentId;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;

@end
