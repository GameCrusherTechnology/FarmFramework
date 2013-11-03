package view.component.UIButton
{
	import controller.TextFieldFactory;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;

	public class EditButton extends Sprite
	{
		public function EditButton()
		{
			var icon:Image = new Image(Game.assets.getTexture("GiftIcon"));
			addChild(icon);
			icon.width = icon.height = 60 * Configrations.ViewScale;
			
			var editText:TextField = TextFieldFactory.createSingleLineDynamicField(icon.width,21,LanguageController.getInstance().getString("edit"),0x000000,20);
			addChild(editText);
			editText.y = icon.y+icon.height -10;
		}
	}
}