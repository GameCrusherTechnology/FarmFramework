package view.component.UIButton
{
	import controller.DialogController;
	
	import gameconfig.Configrations;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import view.panel.FindTaskPanel;
	import view.panel.TaskPanel;
	
	public class TaskButton extends Sprite
	{
		private var length:Number =  70;
		
		public function TaskButton()
		{
			super();
			length = length * Configrations.ViewScale;
			addEventListener(TouchEvent.TOUCH, onTouch);
			icon = new Image(Game.assets.getTexture("maleHeadIcon"));
			addChild(icon);
			icon.width = icon.height = length ;
			icon.x = icon.y = icon.pivotX =icon.pivotY = length/2;
		}
		private var icon:Image ;
		public function refresh():void
		{
		}
		
		private function destroy():void
		{
			if(icon && icon.parent){
				icon.parent.removeChild(icon);
			}
		}
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				DialogController.instance.showPanel(new FindTaskPanel());
			}
		}
		
		
	}
}


