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
	import starling.textures.Texture;

	public class RewardPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var id:String;
		private var count:int;
		public function RewardPanel(item_id:String,c:int)
		{
			id = item_id;
			count = c;
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Math.min(1800,Configrations.ViewPortWidth*0.8);
			panelheight = Math.min(1500,Configrations.ViewPortHeight*0.5);
			scale = Configrations.ViewScale;
			
			var darkSp:Shape = new Shape;
			darkSp.graphics.beginFill(0x000000,0.8);
			darkSp.graphics.drawRect(0,0,Configrations.ViewPortWidth,Configrations.ViewPortHeight);
			darkSp.graphics.endFill();
			addChild(darkSp);
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(20,20,24,24));
			var panelSkin:Scale9Image = new Scale9Image(skinTexture);
			panelSkin.width = panelwidth;
			panelSkin.height = panelheight;
			addChild(panelSkin);
			panelSkin.x = Configrations.ViewPortWidth/2  - panelSkin.width/2;
			panelSkin.y = Configrations.ViewPortHeight/2 - panelSkin.height/2;
			
			var titleText:TextField = FieldController.createSingleLineDynamicField(panelwidth,200,LanguageController.getInstance().getString("seachTip01"),0x000000,35,true);
			titleText.autoSize = TextFieldAutoSize.VERTICAL;
			addChild(titleText);
			titleText.x = panelSkin.x;
			titleText.y = panelSkin.y + 30*scale;
			
			
			var spec:ItemSpec
			var nameS:String;
			if(id == "gem" || id == "coin"|| id == "exp"){
				nameS = LanguageController.getInstance().getString(id);
			}else{
				spec = SpecController.instance.getItemSpec(id);
				if(spec){
					nameS = spec.cname;
				}
			}
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth,200,nameS,0x000000,30,true);
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			addChild(nameText);
			nameText.x = panelSkin.x;
			nameText.y = titleText.y +titleText.height+ 30*scale;
			
			var texture:Texture;
			if(id == "gem" || id == "coin"|| id == "exp"){
				texture = Game.assets.getTexture(id+"Icon");
			}else{
				if(spec){
					texture = Game.assets.getTexture(spec.name+"Icon");
					if(!texture){
						texture = Game.assets.getTexture(spec.name);
					}
				}
			}
			var icon:Image = new Image(texture);
			icon.height  = 60*scale;
			icon.scaleX = icon.scaleY;
			addChild(icon);
			icon.x = Configrations.ViewPortWidth/2 -icon.width - 10*scale;
			icon.y = nameText.y + nameText.height + 30*scale;
			
			var countText:TextField = FieldController.createSingleLineDynamicField(panelwidth,200,"×"+count,0x000000,35,true);
			countText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			addChild(countText);
			countText.x = Configrations.ViewPortWidth/2 + 10*scale;
			countText.y = icon.y + icon.height/2 - countText.height/2;
			
			var button:Button = new Button();
			button.label = LanguageController.getInstance().getString("confirm");
			button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			button.paddingLeft =button.paddingRight =  20;
			button.paddingTop =button.paddingBottom =  5;
			addChild(button);
			button.validate();
			button.x = Configrations.ViewPortWidth/2 - button.width/2;
			button.y =  panelSkin.y +panelSkin.height - 30*scale - button.height;
			button.addEventListener(Event.TRIGGERED,onTriggered);
		}
		
		private function onTriggered(e:Event):void
		{
			if(parent){
				parent.removeChild(this);
			}
			dispose();
		}
	}
}