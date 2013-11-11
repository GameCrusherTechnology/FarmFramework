package controller
{
	import flash.geom.Rectangle;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	import view.panel.TutorialPanel;
	
	public class TutorialController
	{
		private static var _controller:TutorialController;
		private var tutorialPanel:TutorialPanel;
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
		
		public function beginTutorial(container:Sprite):void
		{
			var scissorRect:Rectangle = new Rectangle(0, 0, 150, 150); 
			
			tutorialPanel = new TutorialPanel();
			container.addChild(tutorialPanel);
			tutorialPanel.addEventListener(TouchEvent.TOUCH,onTutorialTouch);
			tutorialPanel.addSpeechStep();
			
		}
		
		private function onTutorialTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(tutorialPanel,TouchPhase.BEGAN);
			if(touch){
				tutorialPanel.addSpeechStep();
			}
		}
		
		
		
	}
}