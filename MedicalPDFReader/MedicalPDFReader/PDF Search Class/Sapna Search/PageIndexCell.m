
#import "PageIndexCell.h"

@implementation PageIndexCell

@synthesize pagePreviewImageView;

- (id)initWithReuseIdentifier:(NSString *)anIdentifier  {
	
	if (![super initWithReuseIdentifier:anIdentifier])
		return nil;
	
	pagePreviewImageView = [[UIImageView alloc] init];
	pagePreviewImageView.frame = CGRectMake(5, 20, 120, 160);
	[self addSubview:pagePreviewImageView ];
//	pagePreviewImageView.defaultImage = [UIImage imageNamed:@"PreviewDefault.png"];
	
	indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,10 + pagePreviewImageView.frame.size.height+10,130,20)]; 
	indexLabel.textColor=[UIColor blackColor];
	indexLabel.backgroundColor=[UIColor clearColor];
	indexLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:20];
	indexLabel.textAlignment=UITextAlignmentCenter;
	[self addSubview:indexLabel];
	
	return self;
}

-(void)loadbackgroundimage:(NSString*)urlPath withColumn:(NSString*)columnNo{
//	pagePreviewImageView.urlPath = urlPath;
	indexLabel.text = columnNo;
}

@end