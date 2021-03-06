#import "dmzMitesModuleiPhone.h"
#import "ControlsViewController.h"
#import "dmzUIKitUtil.h"

@implementation ControlsViewController

@synthesize mitesLabel, chipsLabel, speedLabel, waitLabel;
@synthesize mitesSlider, chipsSlider, speedSlider, waitSlider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
   
   if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
       
      self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
   }
   
   UIKitImproveSliderAccuracy (mitesSlider);
   UIKitImproveSliderAccuracy (chipsSlider);
   UIKitImproveSliderAccuracy (speedSlider);
   UIKitImproveSliderAccuracy (waitSlider);
   
   return self;
}


- (void)dealloc {
   
   [mitesLabel release];
   [chipsLabel release];
   [speedLabel release];
   [waitLabel release];
   [mitesSlider release];
   [chipsSlider release];
   [speedSlider release];
   [waitSlider release];
   
   [super dealloc];
}


/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}



- (IBAction)sliderValueChanged:(id)sender {
   
   dmz::MitesModuleiPhone *mod (dmz::MitesModuleiPhone::get_instance ());
   
   if (mod) {
      
      if (sender == mitesSlider) {
         
         mod->set_mites (dmz::Int64 ([mitesSlider value] + 0.5f));
      }
      else if (sender == chipsSlider) {
         
         mod->set_chips (dmz::Int64 ([chipsSlider value] + 0.5f));
      }
      else if (sender == speedSlider) {
         
         mod->set_speed ([speedSlider value]);
      }
      else if (sender == waitSlider) {
         
         mod->set_wait ([waitSlider value]);
      }
   }
   
   [self updateLabels];
}


- (void)updateLabels {
   
   mitesLabel.text = [NSString stringWithFormat:@"%.0f", [mitesSlider value]];
   chipsLabel.text = [NSString stringWithFormat:@"%.0f", [chipsSlider value]];
   speedLabel.text = [NSString stringWithFormat:@"%.0f", [speedSlider value]];
   waitLabel.text = [NSString stringWithFormat:@"%.0f", [waitSlider value]];
}


@end
