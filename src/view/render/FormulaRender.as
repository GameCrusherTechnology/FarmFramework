package view.render
{
	import flash.geom.Rectangle;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.FormulaItemSpec;
	
	import starling.display.Sprite;
	
	public class FormulaRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var itemSpec:FormulaItemSpec;
		public function FormulaRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				itemSpec = FormulaItemSpec(value);
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				
				configLayout();
			}
		}
		private var renderwidth:Number;
		private var renderheight:Number;
		private function configLayout():void
		{
			renderwidth = width;
			renderheight = height;
			
			container = new Sprite;
			addChild(container);
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(20, 20, 20, 20));
			var panelSkin:Scale9Image = new Scale9Image(skinTexture);
			panelSkin.width = renderwidth;
			panelSkin.height = renderheight;
			container.addChild(panelSkin);
			
			
		}
		
	}
}

