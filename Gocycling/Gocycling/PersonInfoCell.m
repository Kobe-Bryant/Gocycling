//
//  PersonInfoCell.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-21.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "PersonInfoCell.h"
#import "Macros.h"

@implementation PersonInfoCell

@synthesize nameLable,emailLable,telephoneLable,projectnameLable,totalPriceLabel,signalpeojectPriceLabel;

@synthesize priceLabel,otherProjectnameLable,signalpriceLable,enrollProjectLable;




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier count:(int)selectCount indexPath:(NSIndexPath*)path
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        nameLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 17, 200,15)];
        nameLable.backgroundColor = [UIColor clearColor];
        nameLable.font = [UIFont systemFontOfSize:15];
        
        nameLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        
        [self.contentView addSubview:nameLable];
        
    
        telephoneLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 17, 200,15)];
        telephoneLable.backgroundColor = [UIColor clearColor];
        telephoneLable.font = [UIFont systemFontOfSize:15];
        
        telephoneLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        
        [self.contentView addSubview:telephoneLable];
        
        
        emailLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 17, 280,15)];
        emailLable.backgroundColor = [UIColor clearColor];
        emailLable.font = [UIFont systemFontOfSize:15];
        
        emailLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        
        [self.contentView addSubview:emailLable];
        
       if (path.row ==3) {
            
            enrollProjectLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 17, 80,15)];
            enrollProjectLable.backgroundColor = [UIColor clearColor];
            enrollProjectLable.font = [UIFont systemFontOfSize:15];
            enrollProjectLable.text = @"报名项目:";
            enrollProjectLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
            
            [self.contentView addSubview:enrollProjectLable];
       }
        
        
        projectnameLable = [[UILabel alloc]initWithFrame:CGRectMake(90, 17, 200,15)];
        projectnameLable.backgroundColor = [UIColor clearColor];
        projectnameLable.font = [UIFont systemFontOfSize:15];
        projectnameLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        [self.contentView addSubview:projectnameLable];
        
        signalpeojectPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 17, 70,15)];
        signalpeojectPriceLabel.backgroundColor = [UIColor clearColor];
        signalpeojectPriceLabel.font = [UIFont systemFontOfSize:15];
        signalpeojectPriceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:signalpeojectPriceLabel];
        
        
         if (selectCount <=1) {
             
       
             
            } else {
            
               for (int i = 0 ; i <  selectCount; i++)
                {
                    
                    for ( int j = 0; j < 2; j++)
                    {
                        
               UILabel* lable = [[UILabel alloc]init];
                        
               lable.tag = 100+2*i+j;
                        
               lable.frame = CGRectMake(90.0 + 135*j,17+ 40*i, 140, 15);
                    if (lable.tag %2 == 0) {
                            
                        lable.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];

                    }else {
                    
                        lable.textColor = [UIColor redColor];
                    }
                        
             
               [self.contentView addSubview:lable];

                    }
 
                    
                }
            }
        
        
        totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(47, 17, 280,15)];
        totalPriceLabel.backgroundColor = [UIColor clearColor];
        totalPriceLabel.font = [UIFont systemFontOfSize:15];
        
        totalPriceLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB(98.0, 98.0, 98.0).CGColor];
        
        [self.contentView addSubview:totalPriceLabel];
        
        

        
    }
    return self;
}

-(void)setCellData:(NSDictionary*)dic indexPath:(NSIndexPath*)path selectCount:(int)selectCount
{
    
    
    
    NSString* key = [NSString stringWithFormat:@"key%d",path.section];
    
    NSDictionary* bigdic = [dic objectForKey:key];
    
    NSLog(@"key %d = %@",path.section,bigdic);
    

    NSArray* array = [bigdic objectForKey:@"eventName"];
    
    NSLog(@"%@",array[0]);
    NSLog(@"%@",array[1]);

    
    
    
    int eventCount = array.count;
    
    
    NSLog(@"%d",array.count);
    
    
    
    
        
    
        
        switch (path.row) {
            case 0:
      
                
        nameLable.text = [NSString stringWithFormat:@"姓名:  %@",[bigdic objectForKey:@"name"]];
          
                break;
             case 1:
           telephoneLable.text = [NSString stringWithFormat:@"电话:  %@", [bigdic objectForKey:@"mobile"]];

                break;
                
                case 2:
         emailLable.text = [NSString stringWithFormat:@"邮箱:  %@",  [bigdic objectForKey:@"email"]];

               break;
                
             case 3:
                
                if (selectCount ==1) {
                    
                    if (eventCount <=2) {
                        
                        projectnameLable.text = array[3-path.row];
                        signalpeojectPriceLabel.text = [NSString stringWithFormat:@"￥%@",array[3-path.row+1]];
                        
                        
                    }else {
                    
                        for (int i = 0;  i < selectCount*2; i ++)
                        {
                            
                            
                            UILabel* lable =(UILabel*)[self.contentView viewWithTag:i+100];
                            
                            if (i%2 == 0)
                            {
                                
                                lable.text = array[i];
                                
                                NSLog(@"%@",lable.text);
                                
                                
                            }else
                            {
                                NSLog(@"%@",[NSString stringWithFormat:@"￥%@",array[i]]);

                                lable.text = [NSString stringWithFormat:@"￥%@",array[i]];
                                
                            }
                            
                        }
                  }
                    
                    
                }else if (selectCount >=2){
                
                    if (eventCount == 2) {
                        
                        
                        projectnameLable.text = array[3-path.row];
                        signalpeojectPriceLabel.text = [NSString stringWithFormat:@"￥%@",array[3-path.row+1]];
                        
                    } else {
                    
                        for (int i = 0;  i < selectCount*2; i ++)
                        {
                            
                            
                            UILabel* lable =(UILabel*)[self.contentView viewWithTag:i+100];
                            
                            if (i%2 == 0)
                            {
                                
                                lable.text = array[i];
                                
                                
                            }else
                            {
                                
                                lable.text = [NSString stringWithFormat:@"￥%@",array[i]];
                                
                            }
                            
                        }
                    
                    
                    
                    }
                
                
                
                
                
                
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
//                
//                if (selectCount >=1 && eventCount > 2) {
//                    
//                    for (int i = 0;  i < selectCount*2; i ++) {
//                        
//                        
//                        UILabel* lable =(UILabel*)[self.contentView viewWithTag:i+100];
//                        
//                        if (i%2 == 0) {
//                            
//                            lable.text = array[i];
//                            
//                            
//                        }else {
//                            
//                            lable.text = [NSString stringWithFormat:@"￥%@",array[i]];
//                            
//                        }
//                        
//                    }
// 
//                    
//                }else if(selectCount ==2 && eventCount >= 4) {
//                
//                    for (int i = 0;  i < selectCount*2; i ++) {
//                        
//                        
//                        UILabel* lable =(UILabel*)[self.contentView viewWithTag:i+100];
//                        
//                        if (i%2 == 0) {
//                            
//                            lable.text = array[i];
//                            
//                            
//                        }else {
//                        
//                            lable.text = [NSString stringWithFormat:@"￥%@",array[i]];
//
//                        
//                        
//                        }
//                        
//                        
//                        
//                    }
//             
//                
//                
//                
//                
//                
//                }else{
//                
//                
//                    projectnameLable.text = array[3-path.row];
//                    signalpeojectPriceLabel.text = [NSString stringWithFormat:@"￥%@",array[3-path.row+1]];
//                    
//                    NSLog(@"%@",projectnameLable.text);
//                    NSLog(@"%@",signalpeojectPriceLabel.text);
//
//                
//                }
//                
                
            
            
                break;
                
                case 4:
                
                
                
                if (selectCount >=1 && eventCount > 2)
                {
                    
                      float totalPrice;
                 for (int i = 0;  i < selectCount*2; i ++)
                    {
                        
                        
                       if (i %2 ) {
                        
                            float price = [array[i] floatValue];
                        
                          totalPrice+=price;
                        
                        }
                        
                totalPriceLabel.text = [NSString stringWithFormat:@"合计:%0.f",totalPrice];

                    }
  
                    
                }else {
                    
                    
       totalPriceLabel.text = [NSString stringWithFormat:@"合计:%@",array[4-path.row+1]];

                    
            }

                break;
                
            default:
                break;
        }
        
        
        
    
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];




}

@end
