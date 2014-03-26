package view.component
{
	import gameconfig.Configrations;
	
	import model.gameSpec.ItemSpec;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class PackageIcon extends Sprite
	{
		public function PackageIcon(itemSpec:ItemSpec)
		{
			var icon:Image;
			if(Configrations.isPackaged(itemSpec)){
				var skin:Image = new Image(Game.assets.getTexture("BagIcon"));
				addChild(skin);
				if(itemSpec){
					icon = new Image(Game.assets.getTexture(itemSpec.name + "Icon"));
					addChild(icon);
					icon.width = icon.height = skin.width/2;
					icon.x = skin.width/5;
					icon.y = skin.height/3;
				}
			}else{
				icon = new Image(Game.assets.getTexture(itemSpec.name + "Icon"));
				addChild(icon);
			}
		}
	}
}