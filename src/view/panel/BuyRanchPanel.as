package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
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
	import model.gameSpec.RanchSpec;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	import view.entity.RanchEntity;
	
	public class BuyRanchPanel extends PanelScreen
	{
		private var item_id:String;
		private var panelwidth:Number;
		private var panelheight:Number;
		private var bsSkin:Scale9Image;
		private var buyButton:Button ;
		private var spec:RanchSpec;
		private var animalspec:ItemSpec;
		private var addMoreBut:Button;
		
		private var costType:String;
		private var costNumber:int;
		public function BuyRanchPanel(animalItemSpec:ItemSpec)
		{
			animalspec  = animalItemSpec;
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			item_id = animalspec.boundId;
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			var scale:Number = Configrations.ViewScale;
			
			spec = SpecController.instance.getItemSpec(item_id) as RanchSpec;
			var costArr:Array = spec.buyCost.split("|");
			var index:int = 0;
			for each(var entityItem:EntityItem in player.userRanchItems){
				if(entityItem.item_id == item_id){
					index++;
				}
			}
			var costStr:String = costArr[Math.min(index,costArr.length-1)];
			costType = costStr.split(":")[0];
			costNumber = costStr.split(":")[1];
			
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			bsSkin = new Scale9Image(backgroundSkinTextures);
			addChild(bsSkin);
			bsSkin.width = panelwidth;bsSkin.height = panelheight;
			bsSkin.alpha = 0.3;
			bsSkin.addEventListener(TouchEvent.TOUCH,onSkinTouched);
			
			var skin1:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin1);
			skin1.width = panelwidth *.8;
			skin1.height =panelheight*.8;
			skin1.x = panelwidth/2 - skin1.width/2;
			skin1.y = panelheight/2 - skin1.height/2;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth *.8,40*scale,LanguageController.getInstance().getString("qucickshop"),0x000000,35,true);
			nameText.hAlign = HAlign.CENTER;
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			addChild(nameText);
			nameText.x = panelwidth *0.1;
			nameText.y = panelheight*0.12;
			
			backgroundSkinTextures =  new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			var skin2:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin2);
			skin2.width = panelwidth *.6;
			skin2.height = 120*scale;
			skin2.x = panelwidth/2 - skin2.width/2;
			skin2.y =  nameText.y + nameText.height + 10*scale;
			
			var iconSkin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			addChild(iconSkin);
			iconSkin.width = iconSkin.height = 110*scale; 
			iconSkin.x = panelwidth*0.35-iconSkin.width/2;
			iconSkin.y = skin2.y +5*scale;
			
			var icon:Image = new Image(Game.assets.getTexture(spec.name));
			addChild(icon);
			icon.width = icon.height =100*scale;
			icon.x = panelwidth*0.35-icon.width/2;
			icon.y = skin2.y +10*scale;
			
			var houseText:TextField = FieldController.createSingleLineDynamicField(panelwidth *.8,icon.height,spec.cname,0x000000,35,true);
			houseText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(houseText);
			houseText.x = icon.x + icon.width + 20*scale;
			houseText.y = icon.y;
			
			
			var tip2Text:TextField = FieldController.createSingleLineDynamicField(panelwidth *.6,80*scale,LanguageController.getInstance().getString("cost")+" "+LanguageController.getInstance().getString("you")+" :",0x000000,30,true);
			tip2Text.hAlign = HAlign.LEFT;
			addChild(tip2Text);
			tip2Text.x = panelwidth *0.2;
			tip2Text.y = skin2.y + skin2.height + 10*scale;
			
		
			buyButton = new Button();
			buyButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			buyButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			buyButton.addEventListener(Event.TRIGGERED, coinButton_triggeredHandler);
			buyButton.width = panelwidth*0.2;
			buyButton.height = 50*scale;
			addChild(buyButton);
			buyButton.x = panelwidth/2 -buyButton.width/2;
			buyButton.y = tip2Text.y+tip2Text.height + 10*scale;
			
			var coinIcon :Image = new Image(Game.assets.getTexture(costType == "coin"?"coinIcon":"gemIcon"));
			buyButton.addChild(coinIcon);
			coinIcon.width =coinIcon.height = buyButton.height*1.2;
			coinIcon.x = - coinIcon.width/2;
			coinIcon.y = -buyButton.height*0.1;
				
				
			
			buyButton.label = String(costNumber);
			
			skin1.height = buyButton.y + buyButton.height + 20*scale - skin1.y;
			
			var cancelButton:Button = new Button();
			cancelButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			cancelButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			addChild(cancelButton);
			cancelButton.width = cancelButton.height = 50*scale;
			cancelButton.x = panelwidth*0.9 -cancelButton.width -5;
			cancelButton.y = panelheight*0.1 +5;
			
		}
		
		
		
		private function coinButton_triggeredHandler(e:Event):void
		{
			if((costType == "coin" && player.coin < costNumber)||(costType == "gem" && player.gem < costNumber)){
				DialogController.instance.showPanel(new TreasurePanel);
			}else{
				var length:int = int(GameController.instance.localPlayer.wholeSceneLength/2 - spec.bound_x/2);
				GameController.instance.currentFarm.addMoveEntity(new RanchEntity(new EntityItem({"item_id":spec.item_id,"positionx":length,"positiony":length})));
				UiController.instance.showUiTools(UiController.TOOL_CANCEL);
				destroy();
			}
		}
		
		
		private function closeButton_triggeredHandler(e:Event):void
		{
			destroy();
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		private function onSkinTouched(e:TouchEvent):void
		{
			e.stopPropagation();
			var touch:Touch = e.getTouch(bsSkin,TouchPhase.BEGAN);
			if(touch){
				destroy();
			}
		}
		
		private function destroy():void
		{
			bsSkin.removeEventListener(TouchEvent.TOUCH,onSkinTouched);
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}