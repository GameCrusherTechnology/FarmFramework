package view.component.UIButton
{
	import controller.FieldController;
	import controller.UiController;
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

	public class FriendButton extends Sprite
	{
		private var length:Number =  70;
		
		public function FriendButton()
		{
			super();
			length = length * Configrations.ViewScale;
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			var icon:Image = new Image(Game.assets.getTexture("socialIcon"));
			addChild(icon);
			icon.width = icon.height = length;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(1000,30*Configrations.ViewScale,LanguageController.getInstance().getString("friend"),0x000000,25);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(nameText);
			nameText.y = icon.y + icon.height - 10*Configrations.ViewScale;
			if(nameText.width >= icon.width){
				nameText.x = 0;
			}else{
				nameText.x = icon.width/2- nameText.width/2;
			}
			
		}
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				VoiceController.instance.playSound(VoiceController.SOUND_BUTTON);
				UiController.instance.resetFriendsBut();
			}
		}
	}
}