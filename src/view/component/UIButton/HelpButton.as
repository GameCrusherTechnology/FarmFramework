package view.component.UIButton
{
	import controller.FieldController;
	import controller.GameController;
	import controller.VoiceController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.SystemDate;
	
	import model.MessageData;
	import model.player.GamePlayer;
	
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class HelpButton extends Sprite
	{
		private var buttonText:TextField;
		public function HelpButton()
		{
			super();
			
			var skin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			addChild(skin);
			skin.width = skin.height = 70 * Configrations.ViewScale;
			
			var icon:Image = new Image(Game.assets.getTexture("skillRainIcon"));
			icon.width = icon.height = 60 * Configrations.ViewScale;
			addChild(icon);
			icon.x = icon.y = 5 * Configrations.ViewScale;
			
			buttonText = FieldController.createSingleLineDynamicField(400,30*Configrations.ViewScale,LanguageController.getInstance().getString("click"),0x000000,25);
			buttonText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(buttonText);
			buttonText.y = icon.y+icon.height - 10;
			
			addEventListener(TouchEvent.TOUCH,onTouch);
			checkSkill();
		}
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			super.render(support,parentAlpha);
			checkSkill();
		}
		private var canHelp:Boolean = true;
		private function checkSkill():void
		{
			var leftTime:int =  SystemDate.systemTimeS - player.lastHelpedTime - Configrations.HELP_CD ;
			
			if(leftTime < 0){
				buttonText.text = SystemDate.getTimeLeftString(-leftTime);
				canHelp = false;
			}else{
				canHelp = true;
				buttonText.text = LanguageController.getInstance().getString("click");
			}
			if(buttonText.width >=  70 * Configrations.ViewScale){
				buttonText.x =  70 * Configrations.ViewScale - buttonText.width ;
			}else{
				buttonText.x =  70 * Configrations.ViewScale/2- buttonText.width/2;
			}
		}
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				if(canHelp){
					VoiceController.instance.playSound(VoiceController.SOUND_BUTTON);
					GameController.instance.currentFarm.playSkill();
				}
			}
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}
