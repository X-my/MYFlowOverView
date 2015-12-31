# MYFlowOverView

<img src="./flow.gif"/>

## Usage


	  UIImageView* content = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"panda_bg"]];
	
	  MYFlowOverView* flowOverView = [[MYFlowOverView alloc]initWithTargetView:sender contentView:content];
	  
	  flowOverView.flowDirection =  MYFlowOverViewFlowDirectionDown;
	  
	  [flowOverView show];
