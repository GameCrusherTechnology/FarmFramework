package view.render
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.SpecController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.CropSpec;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class CropPickListRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var itemid:String;
		public function CropPickListRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				itemid = value.itemid;
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
					container = null;
				}
				configLayout();
			}
		}
		private function configLayout():void
		{
			var renderwidth:Number = width;
			var renderheight:Number = height;
			
			container = new Sprite;
			addChild(container);
			
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(1, 1, 62, 62));
			var skin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(skin);
			skin.width = renderwidth;
			skin.height = renderheight;
			
			var spec:CropSpec = SpecController.instance.getItemSpec(itemid) as CropSpec;
			var icon:Image = new Image(Game.assets.getTexture(spec.name +"Icon"));
			icon.width = icon.height = renderheight*0.8;
			icon.x = 10*scale;
			icon.y = renderheight*0.1;
			container.addChild(icon);
			
			var iconRight:Number = icon.x + icon.width + 10*scale;
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth - iconRight,30*scale,spec.name,0x000000,25,true);
			nameText.hAlign = HAlign.LEFT;
			container.addChild(nameText);
			nameText.x = iconRight;
			nameText.y = icon.y ;
			
		}
	}
}