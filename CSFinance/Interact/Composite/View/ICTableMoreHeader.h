//
//  ICTableMoreHeader.h
//  CSFinance
//
//  Created by csco on 2018/4/25.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XWActionHandle)(void);

@interface ICTableMoreHeader : UITableViewHeaderFooterView
@property (copy, nonatomic) XWActionHandle actionhandle;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)seeDetail:(id)sender;

@end
