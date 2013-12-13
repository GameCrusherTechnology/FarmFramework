package view.component.UIButton
{
	import controller.DialogController;
	import controller.GameController;
	import controller.TaskController;
	
	import gameconfig.Configrations;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import view.panel.CommunicationPanel;
	
	public class CommunicationButton extends Sprite
	{
		private var length:Number =  70;
		
		public function CommunicationButton()
		{
			super();
			length = length * Configrations.ViewScale;
			addEventListener(TouchEvent.TOUCH, onTouch);
			
//			var skin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
//			addChild(skin);
//			skin.width = skin.height = length ;
//			skin.x = skin.y = skin.pivotX =skin.pivotY = length/2;
			
			icon = new Image(Game.assets.getTexture("WallIcon"));
			addChild(icon);
			icon.width = icon.height = length;
		}
		private var icon:Image ;
		
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
				TaskController.instance.checkCurrentOrder(GameController.instance.currentPlayer);
				DialogController.instance.showPanel(new CommunicationPanel());
			}
		}
		
		
	}
}


