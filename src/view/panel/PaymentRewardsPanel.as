package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.SpecController;
	import controller.TutorialController;
	
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
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	
	public class PaymentRewardsPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var items:Object;
		private var gems:int;
		public function PaymentRewardsPanel(gem:int,data:Object)
		{
			items = data;
			gems = gem;
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Math.min(1800,Configrations.ViewPortWidth*0.8);
			scale = Configrations.ViewScale;
			
			var darkSp:Shape = new Shape;
			darkSp.graphics.beginFill(0x000000,0.8);
			darkSp.graphics.drawRect(0,0,Configrations.ViewPortWidth,Configrations.ViewPortHeight);
			darkSp.graphics.endFill();
			addChild(darkSp);
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(20,20,24,24));
			var panelSkin:Scale9Image = new Scale9Image(skinTexture);
			panelSkin.width = panelwidth;
			addChild(panelSkin);
			panelSkin.x = Configrations.ViewPortWidth/2  - panelSkin.width/2;
			panelSkin.y = Configrations.ViewPortHeight*0.15;
			
			var titleText:TextField = FieldController.createSingleLineDynamicField(panelwidth,200,LanguageController.getInstance().getString("buyTip01"),0x000000,35,true);
			titleText.autoSize = TextFieldAutoSize.VERTICAL;
			addChild(titleText);
			titleText.x = panelSkin.x;
			titleText.y = panelSkin.y + 30*scale;
			
			
			var render:Sprite;
			var deep:Number = titleText.y + titleText.height +20*scale;
			var index:int = 0;
			render = configItem("gem",gems);
			addChild(render);
			render.x =  ((index%2) == 0)?(panelSkin.x+panelwidth*0.5-render.width-10*scale):(panelSkin.x+panelwidth*0.5+10*scale);
			render.y = 	deep;
			
			deep += (index%2)*(render.height+10*scale);
			index++;
			
			for each(var obj:Object in items){
				render = configItem(obj.id,obj.count);
				addChild(render);
				render.x =  ((index%2) == 0)?(panelSkin.x+panelwidth*0.5-render.width-10*scale):(panelSkin.x+panelwidth*0.5+10*scale);
				render.y = deep;
				
				deep += (index%2)*(render.height+10*scale);
				index++;
			}
			
			
			var button:Button = new Button();
			button.label = LanguageController.getInstance().getString("confirm");
			button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			button.paddingLeft =button.paddingRight =  20;
			button.paddingTop =button.paddingBottom =  5;
			addChild(button);
			button.validate();
			button.x = Configrations.ViewPortWidth/2 - button.width/2;
			button.y =  deep+20*scale;
			button.addEventListener(Event.TRIGGERED,onTriggered);
			
			panelSkin.height = button.y + button.height + 20*scale - Configrations.ViewPortHeight*0.15;
			
		}
		private function configItem(id:String,count:int):Sprite
		{
			var container:Sprite = new Sprite;
			
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			var skin:Scale9Image = new Scale9Image(backgroundSkinTextures);
			container.addChild(skin);
			skin.width = panelwidth*0.35;
			
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
			var nameText:TextField = FieldController.createSingleLineDynamicField(skin.width,200,nameS,0x000000,30,true);
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(nameText);
			
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
			container.addChild(icon);
			icon.x = panelwidth*.2 -icon.width - 10*scale;
			icon.y = nameText.y + nameText.height + 10*scale;
			
			var countText:TextField = FieldController.createSingleLineDynamicField(panelwidth,200,"×"+count,0x000000,35,true);
			countText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			container.addChild(countText);
			countText.x = panelwidth*.2 + 10*scale;
			countText.y = icon.y + icon.height/2 - countText.height/2;
			
			skin.height = icon.y + icon.height + 5*scale;
			return container;
		}
		private function onTriggered(e:Event):void
		{
			if(TutorialController.instance.inTutorial){
				TutorialController.instance.playNextStep();
			}
			if(parent){
				parent.removeChild(this);
			}
			dispose();
		}
	}
}

