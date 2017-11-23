//
//  ViewController.m
//  W4D4- Receipts++
//
//  Created by Murat Ekrem Kolcalar on 11/23/17.
//  Copyright © 2017 murtilicious. All rights reserved.
//

#import "ViewController.h"
#import "AddViewController.h"
#import "AppDelegate.h"
#import "ReceiptCell.h"
#import "Receipt+CoreDataProperties.h"
#import "Tag+CoreDataProperties.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *receiptsArray;
@property (nonatomic, strong) NSArray *tagsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appD.persistentContainer.viewContext;
    
    [self fetchTags];
    if (self.tagsArray.count == 0) {
        [self createTags];
    }
    [self createData];
    [self.tableView reloadData];
    
    if (!self.receiptsArray) {
        NSLog(@"Receipts array nil as fuck");
    } else {
        NSLog(@"There are receipts: %@", self.receiptsArray);
    }
}

#pragma Data Creation Stuff
-(void)createData {
    NSMutableArray *results = [[NSMutableArray alloc]init];
    
    for (Tag *tag in self.tagsArray) {
        [results addObject:[tag.receipts allObjects]];
    }
    
    self.receiptsArray = [results copy];
}

-(void)fetchTags {
    // Fetch object
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    self.tagsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (self.tagsArray == nil) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
}

-(void)createTags {
    // Create new object
    Tag *tag1 = [NSEntityDescription
                 insertNewObjectForEntityForName:@"Tag"
                 inManagedObjectContext:self.managedObjectContext];
    tag1.tagName = @"Personal";
    
    Tag *tag2 = [NSEntityDescription
                 insertNewObjectForEntityForName:@"Tag"
                 inManagedObjectContext:self.managedObjectContext];
    tag2.tagName = @"Family";
    
    Tag *tag3 = [NSEntityDescription
                 insertNewObjectForEntityForName:@"Tag"
                 inManagedObjectContext:self.managedObjectContext];
    tag3.tagName = @"Business";
    
    // Save object
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    
    [self fetchTags];
}

#pragma Segue Stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueToAdd"]) {
        AddViewController *controller =  (AddViewController *) [segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
        controller.tagsArray = self.tagsArray;
    }
}

#pragma TableView Stuff
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.receiptsArray.count; //also try adding receiptsArray here later for sorting n stuff?
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.receiptsArray[section] count];
//    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Tag *tag = self.tagsArray[section];
    NSString *sectionHeader = tag.tagName;
    return sectionHeader;
}

- (ReceiptCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ReceiptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Receipt *receipt = self.receiptsArray[indexPath.section][indexPath.row];
    cell.noteLabel.text = @"FUUUUUUUUCK";
    NSLog(@"%@", receipt.note);
//    cell.amountLabel.text = @"fuck";
    
//    cell.noteLabel.text = receipt.note;
//    cell.amountLabel.text = [NSString stringWithFormat:@"$%f", receipt.amount];
    
    return cell;
}

@end
