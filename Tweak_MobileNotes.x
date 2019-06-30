#import <substrate.h>
#import <Foundation/Foundation.h>

//note

@interface ICNote:NSObject
@property (readonly,nonatomic) NSString * title;
@end

@interface ICNoteEditorViewController:UIViewController
@property (strong,nonatomic) ICNote * note;
@end


%hook ICNoteEditorViewController

- (void)viewWillAppear:(BOOL)arg1{
	%orig;
	NSString * content = self.note.title;
	NSString * contentLength = [NSString stringWithFormat:@"%lu",(unsigned long)[content length]];
	self.title = contentLength;
}

- (void)textViewDidChange:(UITextView *)arg1{
	NSLog(@"note textViewDidChange %@",arg1);
	self.title = [NSString stringWithFormat:@"%lu",(unsigned long)[arg1.text length]];
	%orig;
}

%end


