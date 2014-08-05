package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.SpecController;
	import controller.TutorialController;
	import controller.UiController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.SystemDate;
	
	import model.gameSpec.ItemSpec;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	
	public class PayActivitiesPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		
		private var timeText:TextField;
		public function PayActivitiesPanel()
		{
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
			
			var titleText:TextField = FieldController.createSingleLineDynamicField(panelwidth,200,LanguageController.getInstance().getString("treasureshop"),0x000000,35,true);
			titleText.autoSize = TextFieldAutoSize.VERTICAL;
			addChild(titleText);
			titleText.x = panelSkin.x;
			titleText.y = panelSkin.y + 30*scale;
			
			
			timeText = FieldController.createSingleLineDynamicField(panelwidth,30," ",0xff00ff,25,true);
			addChild(timeText);
			timeText.x = panelSkin.x;
			timeText.y =  titleText.y +titleText.height + 5*scale;
			
			var littlePart:Sprite = configLittlePart();
			addChild(littlePart);
			littlePart.x = Configrations.ViewPortWidth*0.1 + panelwidth*0.1;
			littlePart.y = timeText.y + timeText.height + 10*scale;
			
			var largePart:Sprite = configLargePart();
			addChild(largePart);
			largePart.x = Configrations.ViewPortWidth*0.1 + panelwidth*0.1;
			largePart.y = littlePart.y + littlePart.height + 20*scale;
			
			
			var cancelButton:Button = new Button();
			cancelButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			addChild(cancelButton);
			cancelButton.width = cancelButton.height = 50*scale;
			cancelButton.x = panelSkin.x +panelSkin.width - cancelButton.width -5;
			cancelButton.y = panelSkin.y +5;
			
			cancelButton.addEventListener(Event.TRIGGERED,onTriggered);
			
			panelSkin.height = largePart.y + largePart.height + 20*scale - Configrations.ViewPortHeight*0.15;
			
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
		}
		
		private var sysTime:Number;
		private function onEnterFrame(e:Event):void
		{
			if(timeText && Configrations.treasuresActivity.time){
				sysTime = SystemDate.systemTimeS;
				
				if(Configrations.treasuresActivity.time > sysTime){
					timeText.text = LanguageController.getInstance().getString("lefttime")+" : "+SystemDate.getTimeLeftString(Configrations.treasuresActivity.time - SystemDate.systemTimeS);
				}else{
					dispose();
				}
			}
		}
		private function configLittlePart():Sprite
		{
			var container:Sprite = new Sprite;
			var items:Object = Configrations.treasuresActivity.littleFarmGem;
			var deep:Number = 0;
			var index:int = 0;
			var render:Sprite;
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"),new Rectangle(20,20,24,24));
			var panelSkin:Scale9Image = new Scale9Image(skinTexture);
			panelSkin.width = panelwidth*0.6;
			container.addChild(panelSkin);
			
			render = configItem("gem",200);
			container.addChild(render);
			render.x =  panelwidth*0.3*(index%2);
			render.y =  deep;
			deep += (index%2)*render.height;
			index++;
			
			for each(var obj:Object in items){
				render = configItem(obj.id,obj.count);
				container.addChild(render);
				render.x =  panelwidth*0.3*(index%2);
				render.y =  deep;
				deep += (index%2)*render.height;
				index++;
			}
			
			deep += (index%2)*render.height+5*scale;
			
			var arrowIcon :Image = new Image(Game.assets.getTexture("rightArrowIcon"));
			arrowIcon.width = arrowIcon.height = 50*scale;
			container.addChild(arrowIcon);
			arrowIcon.x = panelwidth*0.6 ;
			arrowIcon.y = deep/2 - 20*scale;
			
			var buyButton:Button = new Button();
			buyButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			if(Configrations.treasureDetails[Configrations.LITTLEGEM]){
				buyButton.label = String(Configrations.treasureDetails[Configrations.LITTLEGEM]["suffer"] +" "+ Configrations.treasureDetails[Configrations.LITTLEGEM]["price"]);
			}else{
				buyButton.label = String("US$ 2 ");
			}
			buyButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			container.addChild(buyButton);
			buyButton.paddingLeft = buyButton.paddingRight = 25 ;
			buyButton.paddingTop = buyButton.paddingBottom = 10 ;
			buyButton.validate();
			buyButton.x = arrowIcon.x +arrowIcon.width + 10*scale;
			buyButton.y = arrowIcon.y;
			buyButton.addEventListener(Event.TRIGGERED,onBuyLittleTriggered);
			panelSkin.height = deep;
			return container;
		}
		private function configLargePart():Sprite
		{
			var container:Sprite = new Sprite;
			var items:Object = Configrations.treasuresActivity.largeFarmGem;
			var deep:Number = 0;
			var index:int = 0;
			var render:Sprite;
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"),new Rectangle(20,20,24,24));
			var panelSkin:Scale9Image = new Scale9Image(skinTexture);
			panelSkin.width = panelwidth*0.6;
			container.addChild(panelSkin);
			
			render = configItem("gem",1100);
			container.addChild(render);
			render.x =  panelwidth*0.3*(index%2);
			render.y =  deep;
			deep += (index%2)*render.height;
			index++;
			
			for each(var obj:Object in items){
				render = configItem(obj.id,obj.count);
				container.addChild(render);
				render.x =  panelwidth*0.3*(index%2);
				render.y =  deep;
				deep += (index%2)*render.height;
				index++;
			}
			
			deep += (index%2)*render.height+5*scale;
			
			var arrowIcon :Image = new Image(Game.assets.getTexture("rightArrowIcon"));
			arrowIcon.width = arrowIcon.height = 50*scale;
			container.addChild(arrowIcon);
			arrowIcon.x = panelwidth*0.6 ;
			arrowIcon.y = deep/2 - 20*scale;
			
			var buyButton:Button = new Button();
			buyButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			if(Configrations.treasureDetails[Configrations.LARGEGEM]){
				buyButton.label = String(Configrations.treasureDetails[Configrations.LARGEGEM]["suffer"] +" "+ Configrations.treasureDetails[Configrations.LARGEGEM]["price"]);
			}else{
				buyButton.label = String("US$ 10 ");
			}
			buyButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			container.addChild(buyButton);
			buyButton.paddingLeft = buyButton.paddingRight = 25 ;
			buyButton.paddingTop = buyButton.paddingBottom = 10 ;
			buyButton.validate();
			buyButton.x = arrowIcon.x +arrowIcon.width + 10*scale;
			buyButton.y = arrowIcon.y;
			buyButton.addEventListener(Event.TRIGGERED,onBuyLargeTriggered);
			panelSkin.height = deep;
			return container;
		}
		private function configItem(id:String,count:int):Sprite
		{
			var container:Sprite = new Sprite;
			
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
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.3,200,nameS,0x000000,25,true);
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
			icon.height  = 45*scale;
			icon.scaleX = icon.scaleY;
			container.addChild(icon);
			icon.x = panelwidth*.15 -icon.width - 5*scale;
			icon.y = nameText.y + nameText.height + 10*scale;
			
			var countText:TextField = FieldController.createSingleLineDynamicField(panelwidth,200,"×"+count,0x000000,25,true);
			countText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			container.addChild(countText);
			countText.x = panelwidth*.15 + 5*scale;
			countText.y = icon.y + icon.height/2 - countText.height/2;
			
			return container;
		}
		private function onBuyLargeTriggered(e:Event):void
		{
			PlatForm.FormBuyGems("largeFarmGem");
		}
		private function onBuyLittleTriggered(e:Event):void
		{
			PlatForm.FormBuyGems("littleFarmGem");
		}
		private function onTriggered(e:Event):void
		{
			dispose();
		}
		
		override public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			if(TutorialController.instance.inTutorial){
				TutorialController.instance.playNextStep();
			}
			if(parent){
				parent.removeChild(this);
			}
			super.dispose();
		}
	}
}