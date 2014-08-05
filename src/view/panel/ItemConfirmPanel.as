package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.ItemSpec;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class ItemConfirmPanel extends PanelScreen
	{
		private var itemID:String;
		private var mes:String;
		public function ItemConfirmPanel(_itemID:String,MES:String)
		{
			itemID = _itemID;
			mes = MES;
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			
			var scale:Number = Configrations.ViewScale;
			
			var darkSp:Shape = new Shape;
			darkSp.graphics.beginFill(0x000000,0.8);
			darkSp.graphics.drawRect(0,0,Configrations.ViewPortWidth,Configrations.ViewPortHeight);
			darkSp.graphics.endFill();
			addChild(darkSp);
			
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			var bsSkin:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(bsSkin);
			
			var mesText:TextField = FieldController.createSingleLineDynamicField(Configrations.ViewPortWidth/2,Configrations.ViewPortHeight/2,
				LanguageController.getInstance().getString(mes),0x000000,35,true);
			addChild(mesText);
			mesText.autoSize = TextFieldAutoSize.VERTICAL;
			mesText.x = Configrations.ViewPortWidth*0.25;
			mesText.y = Configrations.ViewPortHeight/3 - mesText.height/2 ;
			mesText.touchable = false;
			
			
			var spec:ItemSpec = SpecController.instance.getItemSpec(itemID);
			
			var icon:Image = new Image(Game.assets.getTexture(spec.name+"Icon"));
			icon.width = icon.height = 100*scale;
			addChild(icon);
			icon.x = Configrations.ViewPortWidth/2 -icon.width/2;
			icon.y = mesText.y+mesText.height + 10*scale;
			
			
			var button:Button = new Button();
			button.label = LanguageController.getInstance().getString("confirm");
			button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			button.paddingLeft =button.paddingRight =  20;
			button.paddingTop =button.paddingBottom =  10;
			addChild(button);
			button.validate();
			button.x = Configrations.ViewPortWidth/2 -button.width/2;
			button.y =  icon.y+icon.height + 20*scale;
			button.addEventListener(Event.TRIGGERED,onTriggered);
			
			bsSkin.width = Math.max(mesText.width , button.x + button.width ) +30*scale;
			bsSkin.height = button.y +button.height - mesText.y + 30*scale;
			bsSkin.x = Configrations.ViewPortWidth/2 - bsSkin.width/2;
			bsSkin.y = mesText.y - 15*scale;
		}
		private function onTriggered(e:Event):void
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

