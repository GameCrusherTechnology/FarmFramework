package controller
{
	import flash.geom.Rectangle;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import view.panel.CreatPersonPanel;
	
	public class TutorialController
	{
		private static var _controller:TutorialController;
		private var tutorialPanel:CreatPersonPanel;
		public static function get instance():TutorialController
		{
			if(!_controller){
				_controller = new TutorialController();
			}
			return _controller;
		}
		public function TutorialController()
		{
			
		}
		
		public function beginTutorial():void
		{
			var scissorRect:Rectangle = new Rectangle(0, 0, 150, 150); 
			
			tutorialPanel = new CreatPersonPanel();
			DialogController.instance.showPanel(tutorialPanel);
			
		}
		
		private function onTutorialTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(tutorialPanel,TouchPhase.BEGAN);
			if(touch){
			}
		}
		
		
		
	}
}