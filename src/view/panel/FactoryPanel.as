package view.panel
{
	import flash.geom.Rectangle;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.events.Event;
	import starling.events.TouchEvent;

	public class FactoryPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		public function FactoryPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.9;
			panelheight = Configrations.ViewPortHeight*0.9;
			scale = Configrations.ViewScale;
			
			var darkSp:Shape = new Shape;
			darkSp.graphics.beginFill(0x000000,0.8);
			darkSp.graphics.drawRect(0,0,Configrations.ViewPortWidth,Configrations.ViewPortHeight);
			darkSp.graphics.endFill();
			addChild(darkSp);
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"),new Rectangle(20,20,24,24));
			var panelSkin:Scale9Image = new Scale9Image(skinTexture);
			panelSkin.width = panelwidth;
			panelSkin.height = panelheight;
			addChild(panelSkin);
			panelSkin.x =  Configrations.ViewPortWidth*0.05;
			panelSkin.y =  Configrations.ViewPortHeight*0.05;
			
			var cancelButton:Button = new Button();
			cancelButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			cancelButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			addChild(cancelButton);
			cancelButton.width = cancelButton.height = 50*scale;
			cancelButton.x = Configrations.ViewPortWidth*0.95 -cancelButton.width -10*scale;
			cancelButton.y = Configrations.ViewPortHeight*0.05 + 10*scale;
		}
		private function closeButton_triggeredHandler(e:Event):void
		{
			destroy();
		}
		private function destroy():void
		{
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}