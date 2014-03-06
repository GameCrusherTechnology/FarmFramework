package view.component.UIButton
{
	import controller.FieldController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	public class EditButton extends Sprite
	{
		public function EditButton()
		{
			var icon:Image = new Image(Game.assets.getTexture("editIcon"));
			addChild(icon);
			icon.width = icon.height = 60 * Configrations.ViewScale;
			
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(1000,35*Configrations.ViewScale,LanguageController.getInstance().getString("edit"),0xFFFFFF,30);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(nameText);
			nameText.y = icon.y+icon.height - 10*Configrations.ViewScale;
			
			if(nameText.width >= icon.width){
				nameText.x = 0;
			}else{
				nameText.x = icon.width/2- nameText.width/2;
			}
		}
	}
}