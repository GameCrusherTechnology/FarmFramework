package view.component.UIButton
{
	import controller.DialogController;
	import controller.UiController;
	import controller.VoiceController;
	
	import gameconfig.Configrations;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	import view.panel.PayActivitiesPanel;
	
	public class TreasureActivityButton extends Sprite
	{
		private var buttonText:TextField;
		public function TreasureActivityButton()
		{
			super();
			
			var skin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			addChild(skin);
			skin.width = skin.height = 70 * Configrations.ViewScale;
			
			var icon:Image = new Image(Game.assets.getTexture("GiftIcon"));
			icon.width = icon.height = 60 * Configrations.ViewScale;
			addChild(icon);
			icon.x = icon.y = 5 * Configrations.ViewScale;
			
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				VoiceController.instance.playSound(VoiceController.SOUND_BUTTON);
				DialogController.instance.showPanel(new PayActivitiesPanel());
				UiController.instance.removeActivityBut();
			}
		}
	}
}


