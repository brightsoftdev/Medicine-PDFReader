
#import "DTGridViewCell.h"

@interface PageIndexCell :DTGridViewCell {
	UIImageView * pagePreviewImageView;
	UILabel * indexLabel;
}
@property (nonatomic, assign) 	UIImageView * pagePreviewImageView;

-(void)loadbackgroundimage:(NSString*)urlPath withColumn:(NSString*)columnNo;

@end
