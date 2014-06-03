package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	import controller.UiController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.entity.EntityItem;
	import model.gameSpec.ItemSpec;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.events.Event;
	
	import view.entity.RanchEntity;

	public class CreatRanchPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var animalSpec:ItemSpec;
		private var ranchSpec:ItemSpec;
		public function CreatRanchPanel(sEntity:ItemSpec)
		{
			animalSpec = sEntity;
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			ranchSpec = SpecController.instance.getItemSpec(animalSpec.boundId);
			panelwidth = Configrations.ViewPortWidth*0.8;
			panelheight = Configrations.ViewPortHeight*0.8;
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
			panelSkin.x =  panelwidth*0.1;
			panelSkin.y =  panelheight*0.1;
			
			var button:Button = new Button();
			button.label = LanguageController.getInstance().getString("confirm");
			button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			button.paddingLeft =button.paddingRight =  20;
			button.paddingTop =button.paddingBottom =  10;
			addChild(button);
			button.validate();
			button.x = Configrations.ViewPortWidth*0.5 - button.width/2;
			button.y = panelheight*0.95+20*scale;
			button.addEventListener(Event.TRIGGERED,onTriggered);
		}
		
		private function onTriggered(e:Event):void
		{
			if(parent){
				parent.removeChild(this);
				var length:int = int(GameController.instance.localPlayer.wholeSceneLength/2 - ranchSpec.bound_x/2);
				GameController.instance.currentFarm.addMoveEntity(new RanchEntity(new EntityItem({"item_id":ranchSpec.item_id,"positionx":length,"positiony":length})));
				dispose();
			}
		}
	}
}