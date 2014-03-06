package view.component.UIButton
{
	import controller.DialogController;
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
	
	import view.panel.MenuPanel;

	public class MenuButton extends Sprite
	{
		public function MenuButton()
		{
			super();
			var icon:Image = new Image(Game.assets.getTexture("menuIcon"));
			icon.width = icon.height = 60 * Configrations.ViewScale;
			addChild(icon);
			var menuText:TextField = FieldController.createSingleLineDynamicField(1000,30*Configrations.ViewScale,LanguageController.getInstance().getString("menu"),0x000000,25);
			menuText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(menuText);
			menuText.y = icon.y+icon.height - 10*Configrations.ViewScale;
			if(menuText.width >= icon.width){
				menuText.x = 0;
			}else{
				menuText.x = icon.width/2- menuText.width/2;
			}
			
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				GameController.instance.resetTools();
				DialogController.instance.showPanel(new MenuPanel(),true);
				VoiceController.instance.playSound(VoiceController.SOUND_BUTTON);
			}
		}
	}
}