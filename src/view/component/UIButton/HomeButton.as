package view.component.UIButton
{
	import controller.FieldController;
	import controller.GameController;
	import controller.VoiceController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class HomeButton extends Sprite
	{
		public function HomeButton()
		{
			super();
			var icon:Image = new Image(Game.assets.getTexture("homeIcon"));
			icon.width = icon.height = 60 * Configrations.ViewScale;
			addChild(icon);
			var nameText:TextField = FieldController.createSingleLineDynamicField(1000,30*Configrations.ViewScale,LanguageController.getInstance().getString("home"),0x000000,25);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(nameText);
			nameText.y = icon.y+icon.height - 10*Configrations.ViewScale;
			
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				VoiceController.instance.playSound(VoiceController.SOUND_BUTTON);
				GameController.instance.visitFriend();
			}
		}
	}
}

