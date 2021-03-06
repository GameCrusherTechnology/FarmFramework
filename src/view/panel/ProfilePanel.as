package view.panel
{
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.text.BitmapFontTextFormat;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class ProfilePanel extends PanelScreen
	{
		private var nameChangeButton:Button;
		private var nameText:TextField;
		private var panelwidth:Number;
		private var panelheight:Number;
		private var currentSex:int;
		private var photo:Image ;
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
			
			var text1:TextField = FieldController.createSingleLineDynamicField(panelwidth,30,LanguageController.getInstance().getString("farmname")+":",0x000000,25);
			addChild(text1);
			text1.autoSize = TextFieldAutoSize.HORIZONTAL;
			text1.hAlign = HAlign.LEFT;
			text1.y = panelheight*0.1 - text1.height;
			text1.x = panelwidth*0.05;
			
			nameText = FieldController.createNoFontField(panelwidth,30,player.name,0x000000,25);
			addChild(nameText);
			nameText.hAlign = HAlign.LEFT;
			nameText.y = panelheight*0.1 - nameText.height;
			nameText.x = text1.x + text1.width + 10*scale;
			
			nameChangeButton = new Button();
			nameChangeButton.label = LanguageController.getInstance().getString("change");
			nameChangeButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			nameChangeButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			nameChangeButton.paddingLeft =nameChangeButton.paddingRight =  20;
			nameChangeButton.paddingTop =nameChangeButton.paddingBottom =  5;
			addChild(nameChangeButton);
			nameChangeButton.validate();
			nameChangeButton.x = panelwidth*0.95 - nameChangeButton.width;
			nameChangeButton.y = panelheight*0.1 - nameChangeButton.height;
			nameChangeButton.addEventListener(Event.TRIGGERED,onNameTrigger);
			
			var idtext:TextField = FieldController.createSingleLineDynamicField(panelwidth*.4,30,"ID"+": " + player.gameuid,0x000000,25);
			addChild(idtext);
			idtext.y = panelheight*0.1 +10*scale;
			idtext.x = panelwidth*0.05;
			
			var picSkin:Image = new Image(Game.assets.getTexture("picBackSkin"));
			addChild(picSkin);
			picSkin.width = 200*scale;
			picSkin.height = 260*scale;
			picSkin.x = panelwidth*0.25 - picSkin.width/2;
			picSkin.y = panelheight*0.5 - picSkin.height/2;
			currentSex = player.sex;
			photo= new Image(Game.assets.getTexture((currentSex==Configrations.CHARACTER_BOY)?"boyIcon":"girlIcon"));
			addChild(photo);
			photo.width = 150*scale;
			photo.height = 200*scale;
			photo.x = panelwidth*0.25 - photo.width/2;
			photo.y = panelheight*0.5 - photo.height/2;
			
			var picChangeButton:Button = new Button();
			picChangeButton.label = LanguageController.getInstance().getString("change");
			picChangeButton.defaultSkin =  new Image(Game.assets.getTexture("greenButtonSkin"));
//			picChangeButton.defaultSkin =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("greenButtonSkin"),new Rectangle(20,10,80,15)));
			picChangeButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			picChangeButton.paddingLeft =picChangeButton.paddingRight =  20;
			picChangeButton.paddingTop =picChangeButton.paddingBottom =  5;
			addChild(picChangeButton);
			picChangeButton.addEventListener(Event.TRIGGERED,onChooseChaTrigger);
			picChangeButton.validate();
			picChangeButton.x = picSkin.x+picSkin.width - picChangeButton.width;
			picChangeButton.y = picSkin.y+picSkin.height ;
			
			
			var whiteSp:Shape = new Shape();
			whiteSp.graphics.beginFill(0xffffff,0.5);
			whiteSp.graphics.drawRect(0,0,panelwidth/2,panelheight *0.7);
			whiteSp.graphics.endFill();
			addChild(whiteSp);
			whiteSp.x = panelwidth*0.4+10*scale;
			whiteSp.y = panelheight*0.15 ;
			
			var hightLength:Number = 30*scale;
			var bar:Sprite = creatBar("exp");
			whiteSp.addChild(bar);
			bar.y = hightLength;
			bar.x = panelwidth/2*0.1;
			
			hightLength  += (10*scale +bar.height);
			whiteSp.graphics.lineStyle(2,0xEDCC97,1);
			whiteSp.graphics.moveTo(panelwidth/2*0.1,hightLength);
			whiteSp.graphics.lineTo(panelwidth/2*0.9,hightLength);
			whiteSp.graphics.endFill();
			hightLength += 10*scale;
			
			bar = creatBar("love");
			whiteSp.addChild(bar);
			bar.y = hightLength;
			bar.x = panelwidth/2*0.1;
			
			hightLength  += (10*scale +bar.height);
			whiteSp.graphics.lineStyle(2,0xEDCC97,1);
			whiteSp.graphics.moveTo(panelwidth/2*0.1,hightLength);
			whiteSp.graphics.lineTo(panelwidth/2*0.9,hightLength);
			whiteSp.graphics.endFill();
			hightLength += 10;
			
			bar = creatBar("coin");
			whiteSp.addChild(bar);
			bar.y = hightLength;
			bar.x = panelwidth/2*0.1;
			
			hightLength  += (10*scale +bar.height);
			whiteSp.graphics.lineStyle(2,0xEDCC97,1);
			whiteSp.graphics.moveTo(panelwidth/2*0.1,hightLength);
			whiteSp.graphics.lineTo(panelwidth/2*0.9,hightLength);
			whiteSp.graphics.endFill();
			hightLength += 10*scale;
			
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
			var nameStr:String = LanguageController.getInstance().getString(name);
			var mesStr:String;
			if(name == "coin"){
				mesStr  = "" +player.coin;
			}else if(name == "gem"){
				mesStr  = "" +player.gem;
			}else if(name == "love"){
				mesStr  = String(Math.max(0,Configrations.gradeToLove(player.skillLevel) - player.love)) +"  "+LanguageController.getInstance().getString("tofull");
			}else{
				nameStr = LanguageController.getInstance().getString("level")+" "+ player.level;
				mesStr  = String(Configrations.gradeToExp(player.level+1) - player.exp) +"  "+LanguageController.getInstance().getString("levelup");
			}
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(w,35,nameStr,0x00000,30,true);
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			nameText.hAlign = HAlign.LEFT;
			nameText.vAlign = VAlign.TOP;
			barContainer.addChild(nameText);
			nameText.x = icon.x + icon.width + 10;
			nameText.y = 5*Configrations.ViewScale;
			var mesText:TextField = FieldController.createSingleLineDynamicField(w,25,mesStr,0x00000,22,true);
			mesText.hAlign = HAlign.LEFT;
			barContainer.addChild(mesText);
			mesText.autoSize = TextFieldAutoSize.VERTICAL;
			mesText.x = icon.x + icon.width + 10;
			mesText.y = nameText.y + mesText.height+10*Configrations.ViewScale;
			return barContainer;
		}
		
		private var chooseChaPanel:CharacterChoosePanel;
		private function showCharacterPanel():void
		{
			chooseChaPanel = new CharacterChoosePanel();
			addChild(chooseChaPanel);
			chooseChaPanel.addEventListener(Event.COMPLETE,onChangeCharacter);
		}
		private function onChangeCharacter(e:Event):void
		{
			if(chooseChaPanel){
				if(currentSex != chooseChaPanel.selectType){
					currentSex = chooseChaPanel.selectType;
					photo.texture = Game.assets.getTexture((currentSex==Configrations.CHARACTER_BOY)?"boyIcon":"girlIcon");
					addChild(photo);
				}
				if(chooseChaPanel.parent){
					chooseChaPanel.parent.removeChild(chooseChaPanel);
				}
				chooseChaPanel = null;
			}
		}
		
		public function onChooseChaTrigger(e:Event):void
		{
			showCharacterPanel();
		}
		
		
		private var inputTextScreen:TextInputPanel;
		private function showNameInputText():void
		{
			inputTextScreen = new TextInputPanel();
			addChild(inputTextScreen);
			inputTextScreen.addEventListener(Event.COMPLETE,onChangeName);
		}
		private function onChangeName(e:Event):void
		{
			if(inputTextScreen){
				nameText.text = inputTextScreen.currentText ;
				if(inputTextScreen.parent){
					inputTextScreen.parent.removeChild(inputTextScreen);
				}
				inputTextScreen = null;
			}
		}
		public function onNameTrigger(e:Event):void
		{
			showNameInputText();
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
	}
}