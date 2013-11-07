package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.GameController;
	import controller.TextFieldFactory;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class CharacterChoosePanel extends PanelScreen
	{
		public function CharacterChoosePanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		private var okImage:Image;
		public var selectType:int = 0;
		private var photo:Image;
		private var photo1:Image;
		
		protected function initializeHandler(event:Event):void
		{
			selectType = player.sex;
			var panelwidth:Number = Configrations.ViewPortWidth*0.86;
			var panelheight:Number = Configrations.ViewPortHeight*0.7;
			var scale:Number = Configrations.ViewScale;
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			var skin:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin);
			skin.width = panelwidth;skin.height = panelheight;
			skin.alpha = 0.3;
			skin.addEventListener(TouchEvent.TOUCH,onSkinTouched);
			
			var skin1:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin1);
			skin1.width = panelwidth *.8;
			skin1.height =panelheight*.8;
			skin1.x = panelwidth/2 - skin1.width/2;
			skin1.y = panelheight/2 - skin1.height/2;
			
			var picSkin:Image = new Image(Game.assets.getTexture("picBackSkin"));
			addChild(picSkin);
			picSkin.width = 200*scale;
			picSkin.height = 260*scale;
			picSkin.x = panelwidth*0.5 - picSkin.width-20;
			picSkin.y = panelheight*0.5 - picSkin.height/2;
			
			photo = new Image(Game.assets.getTexture("boyIcon"));
			addChild(photo);
			photo.width = 150*scale;
			photo.height = 200*scale;
			photo.x = panelwidth*0.5 - photo.width-20;
			photo.y = panelheight*0.5 - photo.height/2;
			photo.addEventListener(TouchEvent.TOUCH,onTouchBoy);

			var picSkin1:Image = new Image(Game.assets.getTexture("picBackSkin"));
			addChild(picSkin1);
			picSkin1.width = 200*scale;
			picSkin1.height = 260*scale;
			picSkin1.x = panelwidth*0.5 +20;
			picSkin1.y = panelheight*0.5 - picSkin1.height/2;
			
			photo1 = new Image(Game.assets.getTexture("girlIcon"));
			addChild(photo1);
			photo1.width = 150*scale;
			photo1.height = 200*scale;
			photo1.x = panelwidth*0.5 +20;
			photo1.y = panelheight*0.5 - photo1.height/2;
			photo1.addEventListener(TouchEvent.TOUCH,onTouchGirl);
			
			var _okButton:Button = new Button();
			_okButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			_okButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			_okButton.label = LanguageController.getInstance().getString("confirm");
			_okButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(TextFieldFactory.FONT_FAMILY, 20, 0xffffff);
			_okButton.addEventListener(Event.TRIGGERED, okButton_triggeredHandler);
			addChild(_okButton);
			_okButton.width = 100*scale;
			_okButton.height = 40*scale;
			_okButton.x = panelwidth/2 +10;
			_okButton.y =picSkin1.y+picSkin1.height + 30;
			
			var _backButton:Button = new Button();
			_backButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			_backButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			_backButton.label = LanguageController.getInstance().getString("cancel");
			_backButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(TextFieldFactory.FONT_FAMILY, 20, 0xffffff);
			_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
			_backButton.width = 100*scale;
			_backButton.height = 40*scale;
			addChild(_backButton);
			_backButton.x = panelwidth/2 -_backButton.width-10;
			_backButton.y = picSkin1.y+picSkin1.height + 30;
			
			okImage = new Image(Game.assets.getTexture("okIcon"));
			okImage.touchable = false;
			addChild(okImage);
			okImage.width =  60*scale;
			okImage.height = 60*scale;
			configOkIcon();
		}
		
		private function configOkIcon():void
		{
			if(selectType == Configrations.CHARACTER_GIRL){
				okImage.x = photo1.x + photo1.width/2 - okImage.width/2;
				okImage.y = photo1.y + photo1.height -okImage.height;
			}else{
				okImage.x = photo.x + photo.width/2 - okImage.width/2;
				okImage.y = photo.y + photo.height -okImage.height;
			}
		}
		private function onTouchBoy(e:TouchEvent):void
		{
			e.stopPropagation();
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject,TouchPhase.BEGAN);
			if(touch){
				selectType = Configrations.CHARACTER_BOY;
				configOkIcon();
			}
		}
		private function onTouchGirl(e:TouchEvent):void
		{
			e.stopPropagation();
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject,TouchPhase.BEGAN);
			if(touch){
				selectType = Configrations.CHARACTER_GIRL;
				configOkIcon();
			}
		}
		
		private function backButton_triggeredHandler(event:Event):void
		{
			selectType = player.sex;
			dispatchEventWith(Event.COMPLETE);
		}
		
		private function onSkinTouched(e:TouchEvent):void
		{
			e.stopPropagation();
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject,TouchPhase.BEGAN);
			if(touch){
				selectType = player.sex;
				dispatchEventWith(Event.COMPLETE);
			}
		}
		private function okButton_triggeredHandler(e:Event):void
		{
			dispatchEventWith(Event.COMPLETE);
		}
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}