package view.panel
{
	import flash.geom.Rectangle;
	
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import starling.events.Event;

	public class CharacterChoosePanel extends PanelScreen
	{
		public function CharacterChoosePanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			var panelwidth:Number = Configrations.ViewPortWidth*0.86;
			var panelheight:Number = Configrations.ViewPortHeight*0.7;
			var scale:Number = Configrations.ViewScale;
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			var skin:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin);
			skin.width = panelwidth;skin.height = panelheight;
			skin.alpha = 0.3;
			
			
		}
	}
}