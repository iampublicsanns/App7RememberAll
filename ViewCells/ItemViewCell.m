//
//  ItemViewCell.m
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "ItemViewCell.h"


@interface ItemViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) void (^clickHandler)(void);

@end


@implementation ItemViewCell

- (void)createImageView
{
	self.imageView = [[UIImageView alloc] init];
	[self.contentView addSubview:self.imageView];

	self.imageView.layer.cornerRadius = 5;
	self.imageView.clipsToBounds = YES;

	//coursera Intro to UIImageView
	self.imageView.layer.borderWidth = 1;
	// instead of autofix:
	self.imageView.layer.borderColor = [UIColor colorWithRed:1 green:0.6 blue:0 alpha:1].CGColor;

	self.imageView.userInteractionEnabled = YES;

	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClick)];
	[singleTap setNumberOfTapsRequired:1];
	[self.imageView addGestureRecognizer:singleTap];
}

- (void)resetViews
{
	self.imageView.image = nil;
	self.label.text = @"reset";
}

- (void)setImage:(UIImage *)image number:(NSNumber *)number
{
	[self setImage:image];

	self.label.text = [NSString stringWithFormat:@"%@", number];
}

- (void)setImage:(UIImage *)image
{
	[self setupViews];

	self.imageView.image = image;

	CGFloat parentWidth = CGRectGetWidth(self.frame);
	CGFloat parentHeight = CGRectGetHeight(self.frame);

	//https://www.youtube.com/watch?v=qV4gHfqwFPU
	self.imageView.frame = CGRectMake(0, 0, parentWidth, parentHeight);
}


- (void)setupViews
{
	if (self.imageView == nil)
	{
		[self createImageView];
	}

	CGFloat parentWidth = CGRectGetWidth(self.frame);
	CGFloat parentHeight = CGRectGetHeight(self.frame);

	if (self.label == nil)
	{
		self.label = [[UILabel alloc] init];
		self.label.text = @"new";
		self.label.frame = CGRectMake(0, 0, parentWidth, parentHeight);

		[self.contentView addSubview:self.label];
	}

}

#pragma mark touch events

- (void)setOnClickBlock:(void (^)(void))block
{
	self.clickHandler = block;
}

- (void)handleClick
{
	self.clickHandler();
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"\n  Sanz -- %@", super.description];
}

@end
