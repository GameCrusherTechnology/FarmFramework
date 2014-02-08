package view.panel
{
	import flash.geom.Rectangle;
	
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
	
	import model.player.GamePlayer;
	
	import service.command.user.UpgradeSkillCommand;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	import view.component.progressbar.SkillCoinBar;
	import view.component.progressbar.SkillLoveBar;

	public class SkillPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var upgradeButton:Button;
		private var needLove:int;
		private var needCoin:int;
		private var mesContainer:Sprite;
		private var speedContainer:Sprite;
		private var timeContainer:Sprite;
		public function SkillPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.86;
			panelheight = Configrations.ViewPortHeight*0.68;
			scale = Configrations.ViewScale;
			config();
		}
		
		private function config():void
		{
			configMesContainer();
			configSpeedPart();
			configHarvestPart();
		}
		
		private function configMesContainer():void
		{
			if(mesContainer && mesContainer.parent){
				mesContainer.parent.removeChild(mesContainer);
			}
			mesContainer = new Sprite();
			addChild(mesContainer);
			mesContainer.x = panelwidth*0.05;
			mesContainer.y = panelheight*0.05;
			
			var containerskin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			mesContainer.addChild(containerskin);
			containerskin.width = panelwidth*0.9;
			containerskin.height= panelheight*0.35;
			
			var icon:Image = new Image(Game.assets.getTexture("maleIcon"));
			mesContainer.addChild(icon);
			icon.height = panelheight*0.35 *.8;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = panelheight*0.35 *.2;
			
			var cdText:TextField = FieldController.createSingleLineDynamicField(panelwidth - icon.width,40,LanguageController.getInstance().getString("skill")+" "+
				LanguageController.getInstance().getString("upgrade")+" "+LanguageController.getInstance().getString("request")+":",0x000000,25,true);
			cdText.autoSize = TextFieldAutoSize.VERTICAL;
			cdText.hAlign = HAlign.LEFT;
			mesContainer.addChild(cdText);
			cdText.x = icon.x + icon.width;
			cdText.y = mesContainer.height *.1;
			
			
			needLove = Configrations.gradeToLove(player.skillLevel);
			var bar:SkillLoveBar = new SkillLoveBar(panelwidth*0.3,panelheight*0.05,needLove);
			mesContainer.addChild(bar);
			bar.x = panelwidth*0.5 - bar.width/2;
			bar.y = cdText.y + cdText.height + 10*scale;
			if(player.love >= needLove){
				var okIcon:Image = new Image(Game.assets.getTexture("okIcon"));
				mesContainer.addChild(okIcon);
				okIcon.width = okIcon.height =bar.height*0.6;
				okIcon.x  =  bar.x +bar.width - okIcon.width;
				okIcon.y  =  bar.y;
			}
			
			needCoin = (player.skillData.skillLevel+1) * 1000;
			var coinbar:SkillCoinBar = new SkillCoinBar(panelwidth*0.3,panelheight*0.05,needCoin);
			mesContainer.addChild(coinbar);
			coinbar.x = panelwidth*0.5 - coinbar.width/2;
			coinbar.y = bar.y + bar.height + 10*scale;
			
			if(player.coin >= needCoin){
				var okIcon1:Image = new Image(Game.assets.getTexture("okIcon"));
				mesContainer.addChild(okIcon1);
				okIcon1.width = okIcon1.height =okIcon1.height*0.6;
				okIcon1.x  =  coinbar.x +coinbar.width- okIcon1.width;
				okIcon1.y  =  coinbar.y;
			}
			
			upgradeButton = new Button();
			upgradeButton.label = LanguageController.getInstance().getString("upgrade");
			upgradeButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			upgradeButton.paddingLeft =upgradeButton.paddingRight =  20;
			upgradeButton.paddingTop =upgradeButton.paddingBottom =  5;
			mesContainer.addChild(upgradeButton);
			upgradeButton.validate();
			upgradeButton.x = panelwidth*0.9 - upgradeButton.width - 10*scale;
			upgradeButton.y = panelheight*0.35 - upgradeButton.height -10*scale;
			
			if(player.love >= needLove && player.coin >= needCoin){
				upgradeButton.addEventListener(Event.TRIGGERED,onTriggeredUpgrade);
				upgradeButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			}else{
				upgradeButton.defaultSkin = new Image(Game.assets.getTexture("cancelButtonSkin"));
			}
			
		}
		
		private function configSpeedPart():void
		{
			if(speedContainer && speedContainer.parent){
				speedContainer.parent.removeChild(speedContainer);
			}
			speedContainer = new Sprite();
			addChild(speedContainer);
			speedContainer.x = panelwidth*0.05;
			speedContainer.y = panelheight*0.45;
			
			var containerskin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			speedContainer.addChild(containerskin);
			containerskin.width = panelwidth*0.43;
			containerskin.height= panelheight*0.45;
			
			
			var fieldIcon:Image = new Image(Game.assets.getTexture("FieldLand"));
			speedContainer.addChild(fieldIcon);
			fieldIcon.height = panelheight*0.12;
			fieldIcon.scaleX = fieldIcon.scaleY;
			fieldIcon.x = panelwidth*0.2 - fieldIcon.width;
			fieldIcon.y =  10*scale;
			
			var fieldText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.4 ,fieldIcon.height,"×"+player.skillData.speedCount,0x000000,40,true);
			fieldText.hAlign = HAlign.LEFT;
			speedContainer.addChild(fieldText);
			fieldText.x = panelwidth*0.2 ;
			fieldText.y = 10*scale;
			
			
			var mesText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.43 ,panelheight*0.45 - fieldIcon.y - fieldIcon.height,LanguageController.getInstance().getString("skillTip01") + player.skillData.speedCount,0x000000,25,true);
			speedContainer.addChild(mesText);
			mesText.x = 0;
			mesText.y = fieldIcon.y +fieldIcon.height ;
			
		}
		
		private function configHarvestPart():void
		{
			if(timeContainer && timeContainer.parent){
				timeContainer.parent.removeChild(timeContainer);
			}
			timeContainer = new Sprite();
			addChild(timeContainer);
			timeContainer.x = panelwidth*0.52;
			timeContainer.y = panelheight*0.45;
			
			var containerskin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			timeContainer.addChild(containerskin);
			containerskin.width = panelwidth*0.43;
			containerskin.height= panelheight*0.45;
			
			
			var fieldIcon:Image = new Image(Game.assets.getTexture("skillTimeIcon"));
			timeContainer.addChild(fieldIcon);
			fieldIcon.height = panelheight*0.12;
			fieldIcon.scaleX = fieldIcon.scaleY;
			fieldIcon.x = panelwidth*0.2 - fieldIcon.width;
			fieldIcon.y =  10*scale;
			
			var fieldText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.4 ,fieldIcon.height,"×"+player.skillData.speedTime,0x000000,40,true);
			fieldText.hAlign = HAlign.LEFT;
			timeContainer.addChild(fieldText);
			fieldText.x = panelwidth*0.2 ;
			fieldText.y = 10*scale;
			
			var mesText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.43 ,panelheight*0.45 - fieldIcon.y - fieldIcon.height,LanguageController.getInstance().getString("skillTip02") + player.skillData.speedTime + LanguageController.getInstance().getString("m"),0x000000,25,true);
			timeContainer.addChild(mesText);
			mesText.x = 0;
			mesText.y = fieldIcon.y +fieldIcon.height ;
			
		}
		private var iscommanding:Boolean;
		private function onTriggeredUpgrade(e:Event):void
		{
			if(!iscommanding){
				iscommanding = true;
				new UpgradeSkillCommand(onUpgradeSuc);
			}
		}
		
		private function onUpgradeSuc():void
		{
			iscommanding = false;
			player.addCoin( - needCoin);
			player.addLove(-player.love);
			config();
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
	}
}