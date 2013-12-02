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
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import view.component.progressbar.CoinProgressBar;
	import view.component.progressbar.GreenProgressBar;
	import view.component.progressbar.LoveProgressBar;

	public class SkillPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var upgradeButton:Button;
		public function SkillPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.86;
			panelheight = Configrations.ViewPortHeight*0.7;
			scale = Configrations.ViewScale;
			configMesContainer();
			configSpeedPart();
			configHarvestPart();
		}
		private function configMesContainer():void
		{
			var container:Sprite = new Sprite();
			addChild(container);
			container.x = panelwidth*0.05;
			container.y = panelheight*0.05;
			
			var containerskin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(containerskin);
			containerskin.width = panelwidth*0.9;
			containerskin.height= panelheight*0.35;
			
			var icon:Image = new Image(Game.assets.getTexture("maleIcon"));
			container.addChild(icon);
			icon.height = panelheight*0.35 *.8;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = panelheight*0.35 *.2;
			
			var cdText:TextField = FieldController.createSingleLineDynamicField(panelwidth - icon.width,40,LanguageController.getInstance().getString("skill")+" "+
				LanguageController.getInstance().getString("upgrade")+" "+LanguageController.getInstance().getString("request")+":",0x000000,25,true);
			cdText.autoSize = TextFieldAutoSize.VERTICAL;
			cdText.hAlign = HAlign.LEFT;
			container.addChild(cdText);
			cdText.x = icon.x + icon.width;
			cdText.y = container.height *.1;
			
			
			var bar:LoveProgressBar = new LoveProgressBar(panelwidth*0.3,panelheight*0.05);
			container.addChild(bar);
			bar.x = panelwidth*0.5 - bar.width/2;
			bar.y = cdText.y + cdText.height + 10*scale;
				
				var okIcon:Image = new Image(Game.assets.getTexture("okIcon"));
				container.addChild(okIcon);
				okIcon.width = okIcon.height =bar.height*0.6;
				okIcon.x  =  bar.x +bar.width - okIcon.width;
				okIcon.y  =  bar.y;
			
			var coinbar:CoinProgressBar = new CoinProgressBar(panelwidth*0.3,panelheight*0.05,GreenProgressBar.LEFT_TO_RIGHT);
			container.addChild(coinbar);
			coinbar.x = panelwidth*0.5 - coinbar.width/2;
			coinbar.y = bar.y + bar.height + 10*scale;
			
			var okIcon1:Image = new Image(Game.assets.getTexture("okIcon"));
			container.addChild(okIcon1);
			okIcon1.width = okIcon1.height =okIcon1.height*0.6;
			okIcon1.x  =  coinbar.x +coinbar.width- okIcon.width;
			okIcon1.y  =  coinbar.y;
			
			upgradeButton = new Button();
			upgradeButton.label = LanguageController.getInstance().getString("upgrade");
			upgradeButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			upgradeButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			upgradeButton.paddingLeft =upgradeButton.paddingRight =  20;
			upgradeButton.paddingTop =upgradeButton.paddingBottom =  5;
			container.addChild(upgradeButton);
			upgradeButton.validate();
			upgradeButton.x = panelwidth*0.9 - upgradeButton.width - 10*scale;
			upgradeButton.y = panelheight*0.35 - upgradeButton.height -10*scale;
//			upgradeButton.addEventListener(Event.TRIGGERED,onTriggeredMale);
			
		}
		
		private function configSpeedPart():void
		{
			var container:Sprite = new Sprite();
			addChild(container);
			container.x = panelwidth*0.05;
			container.y = panelheight*0.45;
			
			var containerskin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(containerskin);
			containerskin.width = panelwidth*0.43;
			containerskin.height= panelheight*0.45;
			
			var icon:Image = new Image(Game.assets.getTexture("maleHeadIcon"));
			container.addChild(icon);
			icon.height = panelheight*0.2;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = 10*scale;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelheight*0.45 - icon.x - icon.width,icon.height,LanguageController.getInstance().getString("speed"),0x000000,35,true);
			nameText.vAlign = VAlign.CENTER;
			nameText.hAlign = HAlign.CENTER;
			container.addChild(nameText);
			nameText.x = icon.x + icon.width ;
			nameText.y = icon.y ;
			
			var fieldIcon:Image = new Image(Game.assets.getTexture("FieldLand"));
			container.addChild(fieldIcon);
			fieldIcon.height = panelheight*0.12;
			fieldIcon.scaleX = icon.scaleY;
			fieldIcon.x = panelwidth*0.2 - fieldIcon.width;
			fieldIcon.y = icon.y + icon.height + 10*scale;
			
			var fieldText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.23 - fieldIcon.width,fieldIcon.height,"×20",0x000000,40,true);
			nameText.vAlign = VAlign.CENTER;
			container.addChild(fieldText);
			fieldText.x = panelwidth*0.2 ;
			fieldText.y = icon.y + icon.height + 10*scale;
		}
		
		private function configHarvestPart():void
		{
			var container:Sprite = new Sprite();
			addChild(container);
			container.x = panelwidth*0.52;
			container.y = panelheight*0.45;
			
			var containerskin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(containerskin);
			containerskin.width = panelwidth*0.43;
			containerskin.height= panelheight*0.45;
			
			var icon:Image = new Image(Game.assets.getTexture("maleHeadIcon"));
			container.addChild(icon);
			icon.height = panelheight*0.2;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = 10*scale;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelheight*0.45 - icon.x - icon.width,icon.height,LanguageController.getInstance().getString("speed"),0x000000,35,true);
			nameText.vAlign = VAlign.CENTER;
			nameText.hAlign = HAlign.CENTER;
			container.addChild(nameText);
			nameText.x = icon.x + icon.width ;
			nameText.y = icon.y ;
			
			var fieldIcon:Image = new Image(Game.assets.getTexture("FieldLand"));
			container.addChild(fieldIcon);
			fieldIcon.height = panelheight*0.12;
			fieldIcon.scaleX = icon.scaleY;
			fieldIcon.x = panelwidth*0.2 - fieldIcon.width;
			fieldIcon.y = icon.y + icon.height + 10*scale;
			
			var fieldText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.23 - fieldIcon.width,fieldIcon.height,"×20",0x000000,40,true);
			nameText.vAlign = VAlign.CENTER;
			container.addChild(fieldText);
			fieldText.x = panelwidth*0.2 ;
			fieldText.y = icon.y + icon.height + 10*scale;
			
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
	}
}