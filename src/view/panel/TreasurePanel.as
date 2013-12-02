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
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;

	public class TreasurePanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var bsSkin:Scale9Image;
		private var scale:Number;
		private var littleCoin:Sprite;
		private var largeCoin:Sprite;
		private var littleGem:Sprite;
		private var largeGem:Sprite;
		public function TreasurePanel()
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			scale = Configrations.ViewScale;
			
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
			
			backgroundSkinTextures =  new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(20, 20, 20, 20));
			var skin2:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin2);
			skin2.width = panelwidth *.7;
			skin2.height = panelheight * 0.32;
			skin2.x = panelwidth *.15;
			skin2.y = panelheight *.2;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth *.6,panelheight * 0.1,LanguageController.getInstance().getString("qucickshop"),0x000000,35,true);
			nameText.hAlign = HAlign.CENTER;
			addChild(nameText);
			nameText.x = panelwidth*0.2;
			nameText.y = panelheight*0.1;
			
			
			littleCoin = creatTreasureRender(Configrations.LITTLECOIN);
			addChild(littleCoin);
			littleCoin.x = panelwidth *.18;
			littleCoin.y = panelheight *.21;
			
			largeCoin = creatTreasureRender(Configrations.LARGECOIN);
			addChild(largeCoin);
			largeCoin.x = panelwidth *.52;
			largeCoin.y = panelheight *.21;
			
			
			var skin3:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin3);
			skin3.width = panelwidth *.7;
			skin3.height = panelheight * 0.32;
			skin3.x = panelwidth *.15;
			skin3.y = panelheight *.55;
			
			littleGem = creatTreasureRender(Configrations.LITTLEGEM);
			addChild(littleGem);
			littleGem.x = panelwidth *.18;
			littleGem.y = panelheight *.56;
			
			largeGem = creatTreasureRender(Configrations.LARGEGEM);
			addChild(largeGem);
			largeGem.x = panelwidth *.52;
			largeGem.y = panelheight *.56;
			
		}
		
		private function creatTreasureRender(name:String):Sprite
		{
			var container:Sprite = new Sprite();
			var textureName:String;
			var buyCount:int;
			var paycount:int;
			var buyarr:Array  = Configrations.treasures[name];
			buyCount = buyarr[0];
			paycount = buyarr[1];
			if(name == Configrations.LITTLECOIN || name == Configrations.LARGECOIN){
				textureName = "coinIcon";
			}else{
				textureName  = "gemIcon";
			}
			
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			var skin:Scale9Image = new Scale9Image(backgroundSkinTextures);
			container.addChild(skin);
			skin.width = panelwidth*0.3;
			skin.height = panelheight*0.3;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth *.3,40*scale,LanguageController.getInstance().getString("qucickshop"),0x000000,35,true);
			nameText.hAlign = HAlign.CENTER;
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(nameText);
			
			var icon:Image = new Image(Game.assets.getTexture(textureName));
			container.addChild(icon);
			icon.width = icon.height =60*scale;
			icon.x = panelwidth*0.08 - icon.width/2;
			icon.y = nameText.y + nameText.height+30*scale;
			
			var countText:TextField = FieldController.createSingleLineDynamicField(panelwidth *.15,40*scale,"×"+buyCount,0x000000,35,true);
			countText.hAlign = HAlign.LEFT;
			countText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(countText);
			countText.x = panelwidth*0.15;
			countText.y = icon.y + icon.height/2 - countText.height/2;
			
			
			var buyButton:Button = new Button();
			buyButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			buyButton.label = String(paycount);
			buyButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			buyButton.width = panelwidth*0.2;
			buyButton.height = 50*scale;
			container.addChild(buyButton);
			buyButton.validate();
			buyButton.x = panelwidth*0.05;
			buyButton.y = panelheight*0.3 - buyButton.height-10*scale;
			
			var gemIcon :Image = new Image(Game.assets.getTexture("gemIcon"));
			buyButton.addChild(gemIcon);
			gemIcon.width =gemIcon.height = buyButton.height*1.2;
			gemIcon.x = - gemIcon.width/2;
			gemIcon.y = -buyButton.height*0.1;
			
			
			return container;
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