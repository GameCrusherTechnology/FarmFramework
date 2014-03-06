package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.SystemDate;
	
	import model.player.GamePlayer;
	
	import service.command.user.BuySkillCDCommand;
	
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	public class BuySkillCdPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var bsSkin:Scale9Image;
		private var gemButton:Button;
		private var gemPrice:int;
		private var currentText:TextField;
		public function BuySkillCdPanel()
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			var scale:Number = Configrations.ViewScale;
			
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			bsSkin = new Scale9Image(backgroundSkinTextures);
			addChild(bsSkin);
			bsSkin.width = panelwidth;bsSkin.height = panelheight;
			bsSkin.alpha = 0.3;
			bsSkin.addEventListener(TouchEvent.TOUCH,onSkinTouched);
			
			var skin1:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin1);
			skin1.width = panelwidth *.8;
			skin1.height =panelheight*.6;
			skin1.x = panelwidth/2 - skin1.width/2;
			skin1.y = panelheight/2 - skin1.height/2;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth *.8,40*scale,LanguageController.getInstance().getString("cleanSkillCD"),0x000000,35,true);
			nameText.hAlign = HAlign.CENTER;
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			addChild(nameText);
			nameText.x = panelwidth *0.1;
			nameText.y = panelheight*0.22;
			
			
			backgroundSkinTextures =  new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			var skin2:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin2);
			skin2.width = panelwidth *.6;
			skin2.height = 120*scale;
			skin2.x = panelwidth/2 - skin2.width/2;
			skin2.y =  nameText.y + nameText.height +10*scale;
			
			var iconSkin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			addChild(iconSkin);
			iconSkin.width = iconSkin.height = 110*scale; 
			iconSkin.x = panelwidth*0.35-iconSkin.width/2;
			iconSkin.y = skin2.y+5*scale;
			
			var icon:Image = new Image(Game.assets.getTexture("skillRainIcon"));
			addChild(icon);
			icon.width = icon.height =100*scale;
			icon.x = panelwidth*0.35-icon.width/2;
			icon.y = skin2.y +10*scale;
			
			var currentT:int =  (Configrations.SKILL_CD - (SystemDate.systemTimeS - player.skill_time));
			currentText = FieldController.createSingleLineDynamicField(panelwidth *.6,100*scale,SystemDate.getTimeLeftString(currentT),0x000000,30,true);
			currentText.hAlign = HAlign.LEFT;
			addChild(currentText);
			currentText.x = icon.x +icon.width +40*scale;
			currentText.y = icon.y ;
			
			gemPrice = Configrations.getSkillCDPrice(currentT);
			
			var tip2Text:TextField = FieldController.createSingleLineDynamicField(panelwidth *.6,80*scale,LanguageController.getInstance().getString("cost")+" "+LanguageController.getInstance().getString("you")+" :",0x000000,30,true);
			tip2Text.hAlign = HAlign.LEFT;
			addChild(tip2Text);
			tip2Text.x = panelwidth *0.2;
			tip2Text.y = skin2.y + skin2.height + 10*scale;
			
			var deep:Number = tip2Text.y+tip2Text.height + 10*scale;
			
			gemButton = new Button();
			gemButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			gemButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			gemButton.addEventListener(Event.TRIGGERED, gemButton_triggeredHandler);
			gemButton.width = panelwidth*0.2;
			gemButton.height = 50*scale;
			addChild(gemButton);
			gemButton.x = panelwidth/2 -gemButton.width/2;
			gemButton.y = deep;
			
			var gemIcon :Image = new Image(Game.assets.getTexture("gemIcon"));
			gemButton.addChild(gemIcon);
			gemIcon.width =gemIcon.height = gemButton.height*1.2;
			gemIcon.x = - gemIcon.width/2;
			gemIcon.y = -gemButton.height*0.1;
			
			refreshValue();
			
			var cancelButton:Button = new Button();
			cancelButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			cancelButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			addChild(cancelButton);
			cancelButton.width = cancelButton.height = 50*scale;
			cancelButton.x = panelwidth*0.9 -cancelButton.width -5;
			cancelButton.y = panelheight*0.2 +5;
			
		}
		
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			super.render(support,parentAlpha);
			refreshValue();
		}
		
		private function refreshValue():void
		{
			if(gemButton){
				var currentT:int =  (Configrations.SKILL_CD - (SystemDate.systemTimeS - player.skill_time));
				currentText.text = SystemDate.getTimeLeftString(currentT);
				gemPrice = Configrations.getSkillCDPrice(currentT);
				gemButton.label =  String(gemPrice);
				gemButton.validate();
			}
		}
		private var isCommanding:Boolean;
		private function gemButton_triggeredHandler(e:Event):void
		{
			if(!isCommanding){
				if(player.gem>= gemPrice){
					new BuySkillCDCommand(gemPrice,onBuy);
				}else{
					DialogController.instance.showPanel(new TreasurePanel);
					destroy();
				}
				isCommanding = true;
			}
		}
		private function onBuy():void
		{
			isCommanding = false;
			player.skill_time -= Configrations.SKILL_CD;
			player.changeGem(-gemPrice);
			destroy();
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

