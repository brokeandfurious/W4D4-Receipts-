//
//  ReceiptCell.h
//  W4D4- Receipts++
//
//  Created by Murat Ekrem Kolcalar on 11/23/17.
//  Copyright © 2017 murtilicious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *noteLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;

@end
