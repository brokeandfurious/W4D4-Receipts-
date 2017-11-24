//
//  AddViewController.m
//  W4D4- Receipts++
//
//  Created by Murat Ekrem Kolcalar on 11/23/17.
//  Copyright © 2017 murtilicious. All rights reserved.
//

#import "ViewController.h"
#import "AddViewController.h"
#import "AppDelegate.h"
#import "Receipt+CoreDataProperties.h"
#import "Tag+CoreDataProperties.h"
#import "TagCell.h"

@interface AddViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate>

@property (strong, nonatomic) NSMutableSet *setForSelectedTags;

@end

@implementation AddViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.amountTextField) {
        [self.amountTextField resignFirstResponder];
    } else if (textField == self.noteTextField) {
        [self.noteTextField resignFirstResponder];
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.noteTextField resignFirstResponder];
    [self.amountTextField resignFirstResponder];
//    [self.datePicker resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDel.persistentContainer.viewContext;
    
    if (!self.managedObjectContext) {
        NSLog(@"I am nil as fuck.");
    } else {
        NSLog(@"YAY");
    }
    
    if (!self.tagsArray) {
        NSLog(@"NOOOO NO TAGSSSS");
    } else {
        NSLog(@"%@", self.tagsArray);
    }
    
    self.setForSelectedTags = [[NSMutableSet alloc]init];
    //TODO: hack, adding first tag to all receipts for now.
    if (self.tagsArray.firstObject) {
        [self.setForSelectedTags addObject:self.tagsArray.firstObject];
    }
    
}

- (IBAction)doneButton:(UIButton *)sender {
    [self createReceipt];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createReceipt {
    Receipt *newReceipt = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Receipt"
                           inManagedObjectContext:self.managedObjectContext];
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *receiptNumber = [numFormatter numberFromString:self.amountTextField.text];
    
    newReceipt.amount = [receiptNumber floatValue];
    newReceipt.note = self.noteTextField.text;
    newReceipt.timeStamp = self.datePicker.date;
    newReceipt.tags = self.setForSelectedTags;
    
    // Save object
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tagsArray.count == 0) {
        return 3;
    } else {
        return self.tagsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tagCell" forIndexPath:indexPath];
    Tag *tag = self.tagsArray[indexPath.row];
    cell.textLabel.text = tag.tagName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    
    Tag *selectedTag = self.tagsArray[indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [self.setForSelectedTags addObject:selectedTag];
    } else {
        [self.setForSelectedTags removeObject:selectedTag];
    }
}

@end
