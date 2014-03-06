package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.TutorialController;
	import controller.UiController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	
	import service.command.user.CreatPerson;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;

	public class CreatPersonPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var _input:TextInput;
		private var list:List;
		private var okImage:Image;
		public var selectType:int = 0;
		private var photo:Image;
		private var photo1:Image;
		
		public function CreatPersonPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			scale = Configrations.ViewScale;
			
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			var bsSkin:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(bsSkin);
			bsSkin.width = panelwidth;
			bsSkin.height = panelheight;
			bsSkin.alpha = 0.3;
			
			var skin1:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin1);
			skin1.width = panelwidth *.8;
			skin1.height =panelheight*.9;
			skin1.x = panelwidth/2 - skin1.width/2;
			skin1.y = panelheight/2 - skin1.height/2;
			
			var container:Sprite = configNpcContainer();
			container.touchable = false;
			addChild(container);
			container.x = panelwidth *.15;
			container.y = panelheight*.07;
			
			var nameContainer:Sprite = configNameContainer();
			addChild(nameContainer);
			nameContainer.x = panelwidth *.15;
			nameContainer.y = panelheight*.23;
			
			var sexContainer:Sprite = configSexContainer();
			addChild(sexContainer);
			sexContainer.x = panelwidth *.15;
			sexContainer.y = panelheight*.40;
			
			
			var _okButton:Button = new Button();
			_okButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			_okButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			_okButton.label = LanguageController.getInstance().getString("confirm");
			_okButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
			_okButton.addEventListener(Event.TRIGGERED, okButton_triggeredHandler);
			_okButton.paddingLeft =_okButton.paddingRight =  20;
			_okButton.paddingTop =_okButton.paddingBottom =  10;
			addChild(_okButton);
			_okButton.validate();
			_okButton.x = panelwidth/2 - _okButton.width/2;
			_okButton.y =panelheight*.95 - _okButton.height - 20*scale;
			
			
			
		}
		
		private function configNpcContainer():Scale9Image
		{
			var container:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			container.width = panelwidth*0.7;
			container.height= panelheight*0.15;
			
			var iconName:String = "femaleIcon";
			var icon:Image = new Image(Game.assets.getTexture(iconName));
			container.addChild(icon);
			icon.height = container.height *.8;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = container.height *.1;
			
			var speechSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("speechBackSkin"), new Rectangle(30, 10, 150, 80)));
			container.addChild(speechSkin);
			speechSkin.width = container.width - icon.width - 10*scale*2;
			speechSkin.height = container.height *.8;
			speechSkin.x = icon.x + icon.width;
			speechSkin.y = container.height *.1;
			
			var speechText:TextField = FieldController.createSingleLineDynamicField(speechSkin.width - 10*scale,container.height *.8,LanguageController.getInstance().getString("tutorialTip02"),0x000000,30,true);
			container.addChild(speechText);
			speechText.x =  icon.x + icon.width + 10*scale;
			speechText.y = container.height *.1;
			return container;
		}
		
		private function configNameContainer():Sprite
		{
			var container:Sprite = new Sprite;
			
			var skin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			skin.width = panelwidth*0.7;
			skin.height= panelheight*0.15;
			container.addChild(skin);
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(container.width,container.height,LanguageController.getInstance().getString("farmname") +" : ",0x000000,30,true);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(nameText);
			nameText.x = 10*scale;
			
			this.layout = new AnchorLayout();
			this._input = new TextInput();
			var _inputSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			this._input.backgroundSkin = new Scale9Image(_inputSkinTextures);
			_input.paddingLeft = 10;
			_input.width = 300 *scale;
			_input.height = 50 *scale;
			Factory(_input,{color:0x000000,fontSize:30*scale,maxChars:15,text:"",displayAsPassword:false});
			container.addChild(this._input);
			_input.x = nameText.x + nameText.width + 20*scale;
			_input.y = panelheight*0.15/2- 25 *scale
			return container;
		}
		private function configSexContainer():Sprite
		{
			
			var container:Sprite = new Sprite;
			
			var skin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			skin.width = panelwidth*0.7;
			skin.height= panelheight*0.45;
			container.addChild(skin);
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(container.width ,50*scale,LanguageController.getInstance().getString("tutorialTip01"),0x000000,30,true);
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			nameText.hAlign = HAlign.LEFT;
			container.addChild(nameText);
			nameText.y = panelheight*0.01;
			
			var picSkin:Image = new Image(Game.assets.getTexture("picBackSkin"));
			container.addChild(picSkin);
			picSkin.width = 200*scale;
			picSkin.height = 260*scale;
			picSkin.x = panelwidth*0.35 - picSkin.width-20;
			picSkin.y = nameText.y + nameText.height + 20*scale;
			
			photo = new Image(Game.assets.getTexture("boyIcon"));
			container.addChild(photo);
			photo.width = 150*scale;
			photo.height = 200*scale;
			photo.x = panelwidth*0.35 - photo.width-20;
			photo.y = nameText.y + nameText.height + 50*scale;
			photo.addEventListener(TouchEvent.TOUCH,onTouchBoy);
			
			var picSkin1:Image = new Image(Game.assets.getTexture("picBackSkin"));
			container.addChild(picSkin1);
			picSkin1.width = 200*scale;
			picSkin1.height = 260*scale;
			picSkin1.x = panelwidth*0.35 +20;
			picSkin1.y = nameText.y + nameText.height + 20*scale;
			
			photo1 = new Image(Game.assets.getTexture("girlIcon"));
			container.addChild(photo1);
			photo1.width = 150*scale;
			photo1.height = 200*scale;
			photo1.scaleX = -photo1.scaleX;
			photo1.x = panelwidth*0.35 +20 + photo1.width;
			photo1.y = nameText.y + nameText.height + 50*scale;
			photo1.addEventListener(TouchEvent.TOUCH,onTouchGirl);
			
			okImage = new Image(Game.assets.getTexture("okIcon"));
			okImage.touchable = false;
			container.addChild(okImage);
			okImage.width =  60*scale;
			okImage.height = 60*scale;
			configOkIcon();
			
			return container;
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
		private var isCommanding:Boolean;
		private function okButton_triggeredHandler(e:Event):void
		{
			if(!isCommanding){
				var name:String = _input.text;
				if(name  && name!=""){
					new CreatPerson(name,selectType,onChangeSuccess);
					isCommanding = true;
				}else{
					DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warnintTip03")));
				}
			}
		}
		private function Factory(target:TextInput , inputParameters:Object ):void
		{
			var editor:StageTextTextEditor = new StageTextTextEditor;
			editor.color = (inputParameters.color == undefined) ? editor.color:inputParameters.color;
			editor.fontSize = (inputParameters.fontSize == undefined) ? editor.fontSize:inputParameters.fontSize;
			//			editor.editable =  (inputParameters.editable == undefined) ? editor.editable:inputParameters.editable;
			target.maxChars = (inputParameters.maxChars == undefined) ? editor.maxChars:inputParameters.maxChars;
			editor.displayAsPassword = (inputParameters.displayAsPassword == undefined)?editor.displayAsPassword:inputParameters.displayAsPassword;
			target.textEditorFactory = function textEditor():ITextEditor{return editor};
			target.text  = inputParameters.text;
		}
		private function onChangeSuccess():void
		{
			isCommanding = false;
			player.sex = selectType;
			player.name = _input.text;
			UiController.instance.configNameText();
			
			if(parent){
				parent.removeChild(this);
			}
			TutorialController.instance.beginTutorial();
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
	}
}