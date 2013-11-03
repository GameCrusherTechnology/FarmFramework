package view.component.UIButton
{
	import controller.TextFieldFactory;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;

	public class MenuButton extends Sprite
	{
		public function MenuButton()
		{
			var icon:Image = new Image(Game.assets.getTexture("GiftIcon"));
			addChild(icon);
			icon.width = icon.height = 60 * Configrations.ViewScale;
			
			var menuText:TextField = TextFieldFactory.createSingleLineDynamicField(icon.width,21,LanguageController.getInstance().getString("menu"),0x000000,20);
			addChild(menuText);
			menuText.y = icon.y+icon.height - 10;
		}
	}
}