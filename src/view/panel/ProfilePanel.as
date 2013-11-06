package view.panel
{
	import controller.GameController;
	import controller.TextFieldFactory;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.text.BitmapFontTextFormat;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

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
			bgSkin.graphics.moveTo(panelwidth*.4,panelheight*.1);
			bgSkin.graphics.lineTo(panelwidth*.4,panelheight*0.9);
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
			nameChangeButton.addEventListener(Event.TRIGGERED,onNameTrigger);
			
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
			
			var picChangeButton:Button = new Button();
			picChangeButton.label = LanguageController.getInstance().getString("change");
			picChangeButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			picChangeButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(TextFieldFactory.FONT_FAMILY, 30, 0xffffff);
			picChangeButton.paddingLeft =picChangeButton.paddingRight =  20;
			picChangeButton.paddingTop =picChangeButton.paddingBottom =  5;
			addChild(picChangeButton);
			picChangeButton.validate();
			picChangeButton.x = picSkin.x+picSkin.width - picChangeButton.width;
			picChangeButton.y = picSkin.y+picSkin.height ;
			
			
			var whiteSp:Shape = new Shape();
			whiteSp.graphics.beginFill(0xffffff,0.5);
			whiteSp.graphics.drawRect(0,0,panelwidth/2,panelheight *0.7);
			whiteSp.graphics.endFill();
			addChild(whiteSp);
			whiteSp.x = panelwidth*0.4+10;
			whiteSp.y = panelheight*0.15 ;
			
			var hightLength:Number = 10;
			var bar:Sprite = creatBar("coin");
			whiteSp.addChild(bar);
			bar.y = hightLength;
			bar.x = panelwidth/2*0.1;
			
			hightLength  += 10 +bar.height;
			whiteSp.graphics.lineStyle(2,0xEDCC97,1);
			whiteSp.graphics.moveTo(panelwidth/2*0.1,hightLength);
			whiteSp.graphics.lineTo(panelwidth/2*0.9,hightLength);
			whiteSp.graphics.endFill();
			hightLength += 10;
			
			bar = creatBar("exp");
			whiteSp.addChild(bar);
			bar.y = hightLength;
			bar.x = panelwidth/2*0.1;
			
			hightLength  += 10 +bar.height;
			whiteSp.graphics.lineStyle(2,0xEDCC97,1);
			whiteSp.graphics.moveTo(panelwidth/2*0.1,hightLength);
			whiteSp.graphics.lineTo(panelwidth/2*0.9,hightLength);
			whiteSp.graphics.endFill();
			hightLength += 10;
			
			bar = creatBar("love");
			whiteSp.addChild(bar);
			bar.y = hightLength;
			bar.x = panelwidth/2*0.1;
			
			hightLength  += 10 +bar.height;
			whiteSp.graphics.lineStyle(2,0xEDCC97,1);
			whiteSp.graphics.moveTo(panelwidth/2*0.1,hightLength);
			whiteSp.graphics.lineTo(panelwidth/2*0.9,hightLength);
			whiteSp.graphics.endFill();
			hightLength += 10;
			
			bar = creatBar("gem");
			whiteSp.addChild(bar);
			bar.y = hightLength;
			bar.x = panelwidth/2*0.1;
		}
		
		private function creatBar(name:String):Sprite
		{
			var w:Number = panelwidth/2;
			var h:Number = panelheight*.15;
			var texture:Texture = Game.assets.getTexture(name+"Icon");
			var barContainer:Sprite = new Sprite;
			
			var icon :Image = new Image(texture);
			icon.width = icon.height = h*0.8;
			barContainer.addChild(icon);
			
			var nameText:TextField = TextFieldFactory.createSingleLineDynamicField(w,35,LanguageController.getInstance().getString(name),0x00000,30,true);
			nameText.hAlign = HAlign.LEFT;
			nameText.vAlign = VAlign.TOP;
			barContainer.addChild(nameText);
			nameText.x = icon.x + icon.width + 10;
			
			var mesText:TextField = TextFieldFactory.createSingleLineDynamicField(w,35,LanguageController.getInstance().getString(name),0x00000,30,true);
			mesText.hAlign = HAlign.LEFT;
			mesText.vAlign = VAlign.TOP;
			barContainer.addChild(mesText);
			mesText.x = icon.x + icon.width + 10;
			mesText.y = nameText.y + mesText.height+2;
			return barContainer;
		}
		private var inputTextScreen:PanelScreen;
		private function showNameInputText():void
		{
			inputTextScreen = new TextInputPanel();
			addChild(inputTextScreen);
		}
		public function onNameTrigger(e:Event):void
		{
			showNameInputText();
		}
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}