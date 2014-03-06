package view.component.UIButton
{
	import controller.FieldController;
	import controller.GameController;
	import controller.VoiceController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	
	import service.command.friend.InviteFriend;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class InviteButton extends Sprite
	{
		public function InviteButton()
		{
			super();
			var icon:Image = new Image(Game.assets.getTexture("socialIcon"));
			icon.width = icon.height = 60 * Configrations.ViewScale;
			addChild(icon);
			var nameText:TextField = FieldController.createSingleLineDynamicField(1000,30*Configrations.ViewScale,LanguageController.getInstance().getString("invite"),0x000000,25);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(nameText);
			nameText.y = icon.y+icon.height - 10*Configrations.ViewScale;
			
			if(nameText.width >= icon.width){
				nameText.x = icon.width - nameText.width ;
			}else{
				nameText.x = icon.width/2- nameText.width/2;
			}
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		private var isCommanding:Boolean;
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				VoiceController.instance.playSound(VoiceController.SOUND_BUTTON);
				if(!isCommanding){
					player.cur_mes_dataid++;
					new InviteFriend(player.gameuid,player.cur_mes_dataid,onInvite);
					isCommanding = true;
				}
			}
		}
		private function onInvite():void{
			isCommanding = false;
		}
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}
