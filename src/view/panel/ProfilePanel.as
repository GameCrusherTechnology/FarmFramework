package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.GameController;
	import controller.TextFieldFactory;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;

	public class ProfilePanel extends PanelScreen
	{
		private var nameChangeButton:Button;
		private var panelwidth:Number;
		private var panelheight:Number;
		public function ProfilePanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.86;
			panelheight = Configrations.ViewPortHeight*0.7;
			var scale:Number = Configrations.ViewScale;
			
			var bgSkin:Shape = new Shape;
			bgSkin.graphics.lineStyle(2,0xEDCC97,1);
			bgSkin.graphics.moveTo(panelwidth*0.05,panelheight*0.1);
			bgSkin.graphics.lineTo(panelwidth*0.95,panelheight*0.1);
			bgSkin.graphics.endFill();
			addChild(bgSkin);
			this.layout = new AnchorLayout();
			
			var text1:TextField = TextFieldFactory.createSingleLineDynamicField(panelwidth,30,LanguageController.getInstance().getString("farmname")+":",0x000000,25);
			addChild(text1);
			text1.hAlign = HAlign.LEFT;
			text1.y = panelheight*0.1 - text1.height;
			text1.x = panelwidth*0.05;
			
			var text2:TextField = TextFieldFactory.createSingleLineDynamicField(panelwidth,40,player.farmName,0x000000,35);
			addChild(text2);
			text2.hAlign = HAlign.CENTER;
			text2.y = panelheight*0.1 - text2.height;
			nameChangeButton = new Button();
			nameChangeButton.label = LanguageController.getInstance().getString("change");
			nameChangeButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			nameChangeButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(TextFieldFactory.FONT_FAMILY, 30, 0xffffff);
			nameChangeButton.paddingLeft =nameChangeButton.paddingRight =  20;
			nameChangeButton.paddingTop =nameChangeButton.paddingBottom =  5;
			addChild(nameChangeButton);
			nameChangeButton.validate();
			nameChangeButton.x = panelwidth*0.95 - nameChangeButton.width;
			nameChangeButton.y = panelheight*0.1 - nameChangeButton.height;
			
			var picSkin:Image = new Image(Game.assets.getTexture("picBackSkin"));
			addChild(picSkin);
			picSkin.width = 200*scale;
			picSkin.height = 260*scale;
			picSkin.x = panelwidth*0.25 - picSkin.width/2;
			picSkin.y = panelheight*0.5 - picSkin.height/2;
			
			var photo:Image = new Image(Game.assets.getTexture("boyIcon"));
			addChild(photo);
			photo.width = 150*scale;
			photo.height = 200*scale;
			photo.x = panelwidth*0.25 - photo.width/2;
			photo.y = panelheight*0.5 - photo.height/2;
			
			var whiteSp:Shape = new Shape();
			whiteSp.graphics.beginFill(0xffffff,0.9);
			whiteSp.graphics.drawRoundRect(0,0,panelwidth/2-20,panelheight *0.7,50);
			whiteSp.graphics.endFill();
			addChild(whiteSp);
			whiteSp.x = panelwidth*0.5+10;
			whiteSp.y = panelheight*0.15 ;
				
		}
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}