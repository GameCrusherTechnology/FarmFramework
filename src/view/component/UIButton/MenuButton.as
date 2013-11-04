package view.component.UIButton
{
	import controller.DialogController;
	import controller.GameController;
	import controller.TextFieldFactory;
	import controller.UiController;
	
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	import view.panel.MenuPanel;

	public class MenuButton extends Sprite
	{
		public function MenuButton()
		{
			super();
			var icon:Image = new Image(Game.assets.getTexture("GiftIcon"));
			icon.width = icon.height = 60 * Configrations.ViewScale;
			addChild(icon);
			var menuText:TextField = TextFieldFactory.createSingleLineDynamicField(icon.width,21,LanguageController.getInstance().getString("menu"),0x000000,20);
			addChild(menuText);
			menuText.y = icon.y+icon.height - 10;
			
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				GameController.instance.resetTools();
				DialogController.instance.showPanel(new MenuPanel(),true);
			}
		}
	}
}