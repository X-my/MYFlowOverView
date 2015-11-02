# MYFlowOverView
![MYFlowOverView](http://7xjt4p.com1.z0.glb.clouddn.com/flow.gif)
## Usage


	  UIImageView* content = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"panda_bg"]];
	
	  MYFlowOverView* flowOverView = [[MYFlowOverView alloc]initWithTargetView:sender contentView:content];
	  
	  flowOverView.flowDirection =  MYFlowOverViewFlowDirectionDown;
	  
	  [flowOverView show];
