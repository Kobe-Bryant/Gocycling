//
//  ActivityRegisterCell.m
//  Gocycling
//
//  Created by Apple on 14-4-14.
//
//

#import "ActivityRegisterCell.h"
#import "Activity.h"
#import "Macros.h"
@implementation ActivityRegisterCell
@synthesize mainLable,subLable,imageView,smallImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        mainLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5 ,180, 60)];
        mainLable.numberOfLines = 2;
        mainLable.lineBreakMode = NSLineBreakByWordWrapping;
        mainLable.font = [UIFont systemFontOfSize:15];
        mainLable.textColor = [UIColor colorWithCGColor:
                               UIColorFromRGB(49.0, 49.0, 49.0).CGColor];
        [self.contentView addSubview:mainLable];
        
        smallImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 94.0,11 , 11)];
        [self.contentView addSubview:smallImageView];
        
        
        subLable = [[UILabel alloc]initWithFrame:CGRectMake(25, 90.0, 200, 20)];
        subLable.font = [UIFont systemFontOfSize:8];
        subLable.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:subLable];
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 5, 100, 106)];
        [self.contentView addSubview:imageView];

    }
    return self;
}

-(void)setCellInfo:(Activity*)model
{
    mainLable.text = model.title;
    subLable.text = model.dateString;
    UIImage* image = [UIImage imageNamed:@"clock.png"];
    smallImageView.image =image;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
