//
//  MaterialDetailsViewController.m
//  Materials
//
//  Created by Kaven Feng on 3/5/14.
//  Copyright (c) 2014 Kaven Feng. All rights reserved.
//

#import "MaterialDetailsViewController.h"
#import"MKNetworkKit.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XMLReader/XMLReader.h"
#import "CellInDetailPage.h"

@interface MaterialDetailsViewController ()
{
    NSDictionary* dict;
    NSDictionary *groupInfos;
    NSMutableArray* visibleTabs;
}
@end

@implementation MaterialDetailsViewController
@synthesize uuid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* path  = [[NSBundle mainBundle] pathForResource:@"groupInfo" ofType:@"plist"];
    groupInfos = [[NSDictionary alloc] initWithContentsOfFile:path];
 
	// Do any additional setup after loading the view.
    
    //    http://exchange.services-staging.autodesk.com/Search/restapi/v1/contents?q=contentId:3177e620-51b6-4b1b-b85e-3863c15b4b57&detail=5&access_token=GC---Y0DMq0bzUwoyIAagT6qG1L9kHI
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"exchange.services-staging.autodesk.com" customHeaderFields:nil];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:@"contentId:3177e620-51b6-4b1b-b85e-3863c15b4b57" forKey:@"q"];
    [dic setObject: @"5" forKey:@"detail"];
    [dic setObject: @"GC---Y0DMq0bzUwoyIAagT6qG1L9kHI" forKey:@"access_token"];
    
    MKNetworkOperation *op = [engine operationWithPath:@"/Search/restapi/v1/contents" params:dic httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
        NSData* data = [operation responseData];
        NSError *error = nil;
        
        NSDictionary* xmlData = [XMLReader dictionaryForXMLData:data
                                                     options:XMLReaderOptionsProcessNamespaces
                                                       error:&error];
        if (xmlData != NULL && [xmlData count] == 1) {
            NSDictionary* dic = [xmlData objectForKey:@"list"];
            if (dic != NULL) {
                dict = [dic objectForKey:@"content"];
                if (dict != NULL) {

                    [self loadVisibleTabs:dict];
                    
                    [self.mTableView reloadData];
                }
            }
        }

    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
    }];
    [engine enqueueOperation:op];
    
}

-(void) loadVisibleTabs : (NSDictionary*) product{
    visibleTabs = [[NSMutableArray alloc] init];
    
    NSString* path  = [[NSBundle mainBundle] pathForResource:@"tabDef" ofType:@"plist"];
    NSArray* tabDef = [[NSArray alloc] initWithContentsOfFile:path];
    NSArray* keywords = [[product objectForKey:@"keywords"] objectForKey:@"keyword"];
    
    for (NSDictionary* item in tabDef) {
        NSString* cond = [item objectForKey:@"condition"];
        for (int i = 0; i < [keywords count]; i++) {
            NSString* kwName = [keywords[i] objectForKey:@"name"];
            if ([kwName hasPrefix:cond]) {
                [visibleTabs addObject:item];
                break;
            }
        }
        
    }
    
    // UI
    for (int i = 0; i < [visibleTabs count]; i++) {
        NSString* strTitle = [visibleTabs[i] objectForKey:@"name"];
        if (i >= self.segmentCtrl.numberOfSegments) {
            [self.segmentCtrl insertSegmentWithTitle:strTitle atIndex:i animated:YES];
        }
        [self.segmentCtrl setTitle:strTitle forSegmentAtIndex:i];
    }

    
}

-(NSDictionary*) groupInfoForTab : (NSString*) tabId{
    
    NSDictionary* groupInfo = nil;
    NSString* type = @"identity";
    if (tabId == type) {
        groupInfo = [groupInfos objectForKey:type];
    }else{
        NSString* typeID = [NSString stringWithFormat:@"%@identity.type", tabId ];
        NSDictionary* item = [self findByKeyword:typeID fromDictionary:dict];
        NSString* infoKey = [NSString stringWithFormat:@"%@_%@",tabId, [[item objectForKey : @"value" ] objectForKey : @"text" ]];
        groupInfo = [groupInfos objectForKey: infoKey];
    }
    
    return groupInfo;
}

//-(void) generateGroupsInOneTab : (NSDictionary*) groupInfo withProduct : (CellInDetailPage*) cell{
//    
//    NSArray* groups = [groupInfo objectForKey:@"groups"];
//    for (NSDictionary* group in groups) {
//        NSArray* properties = [group objectForKey:@"properties"];
//        NSString* prefix = [group objectForKey:@"prefix"];
//        for (NSDictionary* property in properties) {
//            NSString* name = [property objectForKey:@"name"];
//            NSString* keyword = [NSString stringWithFormat:@"%@%@", prefix, name ];
//            NSDictionary* valueDic = [self findByKeyword:keyword fromDictionary:dict];
//            
//            NSString* valueText = [[valueDic objectForKey:@"value"] objectForKey:@"text"];
//            NSString* uom = [valueDic objectForKey:@"uom"];
//            
//            NSString* propertyLabel = [[valueDic objectForKey:@"title"] objectForKey:@"Name"];
//            NSString* propertyValue = [NSString stringWithFormat:@"%@ %@", valueText, uom];
//            
//            cell.keyLabel.text = propertyLabel;
//            cell.valueLabel.text = propertyValue;
//        }
//    }
//    
//}

-(void) generateGroupsInOneTab : (NSDictionary*) groupInfo forCell : (CellInDetailPage*) cell forIndexPath : (NSIndexPath *)indexPath{
    
    NSArray* groups = [groupInfo objectForKey:@"groups"];
    NSDictionary* group = groups[indexPath.section];

    NSString* prefix = [group objectForKey:@"prefix"];
    NSArray* properties = [group objectForKey:@"properties"];
    NSDictionary* property = properties[indexPath.row];

    NSString* name = [property objectForKey:@"name"];
    NSString* keyword = [NSString stringWithFormat:@"%@%@", prefix, name ];
    NSDictionary* valueDic = [self findByKeyword:keyword fromDictionary:dict];
    
    NSString* valueText = [[valueDic objectForKey:@"value"] objectForKey:@"text"];
    NSString* uom = [valueDic objectForKey:@"uom"];
    
    NSString* propertyLabel = [valueDic objectForKey:@"title"];
    NSString* propertyValue = [NSString stringWithFormat:@"%@ %@", valueText, uom];
    
    cell.keyLabel.text = propertyLabel;
    cell.valueLabel.text = propertyValue;
    
}

-(NSDictionary*) findByKeyword : (NSString*) keyword fromDictionary : (NSDictionary*) product{
    
    NSArray* keywords = [[product objectForKey:@"keywords"] objectForKey:@"keyword"];
    for (int i = 0; i < [keywords count]; i++) {
        NSString* name = [keywords[i] objectForKey:@"name"];
        
        if ([name compare:keyword options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            return keywords[i];
        }
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int index = self.segmentCtrl.selectedSegmentIndex;
    NSString* tabId = [visibleTabs[index] objectForKey:@"id"];
    NSDictionary* groupInfo = [self groupInfoForTab: tabId];
    NSArray* groups = [groupInfo objectForKey:@"groups"];

    return [groups count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int index = self.segmentCtrl.selectedSegmentIndex;
    NSString* tabId = [visibleTabs[index] objectForKey:@"id"];
    NSDictionary* groupInfo = [self groupInfoForTab:tabId];
    NSArray* groups = [groupInfo objectForKey:@"groups"];
    NSDictionary* group = groups[section];
    
    return [group objectForKey:@"name"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int index = self.segmentCtrl.selectedSegmentIndex;
    NSString* tabId = [visibleTabs[index] objectForKey:@"id"];
    
    NSDictionary* groupInfo = [self groupInfoForTab:tabId];
    NSArray* groups = [groupInfo objectForKey:@"groups"];
    NSArray* properties = [groups[section] objectForKey:@"properties"];

    return [properties count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellInDetailPage";
    CellInDetailPage *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
    int index = self.segmentCtrl.selectedSegmentIndex;
    NSString* tabId = [visibleTabs[index] objectForKey:@"id"];
    NSDictionary* groupInfo = [self groupInfoForTab:tabId];

    [self generateGroupsInOneTab:groupInfo forCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (IBAction)onSegmentChanged:(id)sender {
    
//    UISegmentedControl* control = (UISegmentedControl*)sender;
//    switch (control.selectedSegmentIndex) {
//        case 0:
//            NSLog(@"0");
//            break;
//        case 1:
//            NSLog(@"1");
//
//            break;
//        case 2:
//            NSLog(@"2");
//
//            break;
//        default:
//            break;
//    }
    
    [self.mTableView reloadData];
    
}
@end
