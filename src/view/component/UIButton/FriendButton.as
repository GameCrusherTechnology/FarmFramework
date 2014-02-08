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

	public class FriendButton extends Sprite
	{
		public function FriendButton()
		{
			super();
			var icon:Image = new Image(Game.assets.getTexture("homeIcon"));
			icon.width = icon.height = 60 * Configrations.ViewScale;
			addChild(icon);
			var menuText:TextField = FieldController.createSingleLineDynamicField(icon.width,21,LanguageController.getInstance().getString("home"),0x000000,20);
			addChild(menuText);
			menuText.y = icon.y+icon.height - 10;
			
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