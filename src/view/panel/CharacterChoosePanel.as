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
	
	import model.player.GamePlayer;
	
	import service.command.user.ChangeSexCommand;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;

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
		private var bsSkin:Scale9Image;
		
		protected function initializeHandler(event:Event):void
		{
			selectType = player.sex;
			var panelwidth:Number = Configrations.ViewPortWidth*0.86;
			var panelheight:Number = Configrations.ViewPortHeight*0.7;
			var scale:Number = Configrations.ViewScale;
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			bsSkin = new Scale9Image(backgroundSkinTextures);
			addChild(bsSkin);
			bsSkin.width = panelwidth;
			bsSkin.height = panelheight;
			bsSkin.alpha = 0.3;
			bsSkin.addEventListener(TouchEvent.TOUCH,onSkinTouched);
			
			var skin1:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin1);
			skin1.width = panelwidth *.8;
			skin1.height =panelheight*.9;
			skin1.x = panelwidth/2 - skin1.width/2;
			skin1.y = panelheight/2 - skin1.height/2;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth ,50*scale,LanguageController.getInstance().getString("shopTip04"),0x000000,35,true);
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			addChild(nameText);
			nameText.y = skin1.y+20*scale;
			
			var icon:Image = new Image(Game.assets.getTexture("gemIcon"));
			addChild(icon);
			icon.width = icon.height =60*scale;
			icon.x = panelwidth*0.5 - icon.width - 10*scale;
			icon.y = nameText.y + nameText.height+10*scale;
			
			var countText:TextField = FieldController.createSingleLineDynamicField(panelwidth *.5,40*scale,"×"+Configrations.CHANGE_SEX_COST,0x000000,35,true);
			countText.hAlign = HAlign.LEFT;
			countText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(countText);
			countText.x = panelwidth*0.5 + 10*scale;
			countText.y = icon.y + icon.height/2 - nameText.height/2;
			
			var picSkin:Image = new Image(Game.assets.getTexture("picBackSkin"));
			addChild(picSkin);
			picSkin.width = 200*scale;
			picSkin.height = 260*scale;
			picSkin.x = panelwidth*0.5 - picSkin.width-20;
			picSkin.y = icon.y + icon.height + 20*scale;
			
			photo = new Image(Game.assets.getTexture("boyIcon"));
			addChild(photo);
			photo.width = 150*scale;
			photo.height = 200*scale;
			photo.x = panelwidth*0.5 - photo.width-20;
			photo.y = icon.y + icon.height + 50*scale;
			photo.addEventListener(TouchEvent.TOUCH,onTouchBoy);

			var picSkin1:Image = new Image(Game.assets.getTexture("picBackSkin"));
			addChild(picSkin1);
			picSkin1.width = 200*scale;
			picSkin1.height = 260*scale;
			picSkin1.x = panelwidth*0.5 +20;
			picSkin1.y = icon.y + icon.height + 20*scale;
			
			photo1 = new Image(Game.assets.getTexture("girlIcon"));
			addChild(photo1);
			photo1.width = 150*scale;
			photo1.height = 200*scale;
			photo1.scaleX = -photo1.scaleX;
			photo1.x = panelwidth*0.5 +20 + photo1.width;
			photo1.y = icon.y + icon.height + 50*scale;
			photo1.addEventListener(TouchEvent.TOUCH,onTouchGirl);
			
			var _okButton:Button = new Button();
			_okButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			_okButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			_okButton.label = LanguageController.getInstance().getString("confirm");
			_okButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			_okButton.addEventListener(Event.TRIGGERED, okButton_triggeredHandler);
			_okButton.paddingLeft =_okButton.paddingRight =  20;
			_okButton.paddingTop =_okButton.paddingBottom =  5;
			addChild(_okButton);
			_okButton.validate();
			_okButton.x = panelwidth/2 +10*scale;
			_okButton.y =picSkin1.y+picSkin1.height + 30*scale;
			
			var _backButton:Button = new Button();
			_backButton.defaultSkin = new Image(Game.assets.getTexture("cancelButtonSkin"));
			_backButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			_backButton.label = LanguageController.getInstance().getString("cancel");
			_backButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
			_backButton.paddingLeft =_backButton.paddingRight =  20;
			_backButton.paddingTop =_backButton.paddingBottom =  5;
			addChild(_backButton);
			_backButton.validate();
			_backButton.x = panelwidth/2 -_backButton.width-10*scale;
			_backButton.y = picSkin1.y+picSkin1.height + 30*scale;
			
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
				okImage.x = photo1.x  - okImage.width/2;
				okImage.y = photo1.y + photo1.height -okImage.height;
			}else{
				okImage.x = photo.x + 150*Configrations.ViewScale/2 - okImage.width/2;
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
			var touch:Touch = e.getTouch(bsSkin,TouchPhase.BEGAN);
			if(touch){
				selectType = player.sex;
				dispatchEventWith(Event.COMPLETE);
				bsSkin.removeEventListener(TouchEvent.TOUCH,onSkinTouched);
			}
		}
		private function okButton_triggeredHandler(e:Event):void
		{
			if(!isCommanding){
				if(selectType == player.sex){
					dispatchEventWith(Event.COMPLETE);
				}else{
					if(player.gem>= Configrations.CHANGE_SEX_COST){
						new ChangeSexCommand(selectType,onChangeSuccess);
						isCommanding = true;
					}else{
						DialogController.instance.showPanel(new TreasurePanel());
					}
				}
			}
		}
		private var isCommanding:Boolean;
		private function onChangeSuccess():void
		{
			isCommanding = false;
			player.sex = selectType;
			player.changeGem(-Configrations.CHANGE_NAME_COST);
			dispatchEventWith(Event.COMPLETE);
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}