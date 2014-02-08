package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.UiController;
	
	import feathers.controls.Button;
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
	
	import service.command.user.ChangeNameCommand;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;

	[Event(name="complete",type="starling.events.Event")]
	public class TextInputPanel extends PanelScreen
	{

		public function TextInputPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _backButton:Button;
		private var _okButton:Button;
		private var _input:TextInput;
		private var skin:Scale9Image;
		protected function initializeHandler(event:Event):void
		{
			var panelwidth:Number = Configrations.ViewPortWidth*0.86;
			var panelheight:Number = Configrations.ViewPortHeight*0.7;
			var scale:Number = Configrations.ViewScale;
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(20, 20, 20, 20));
			skin = new Scale9Image(backgroundSkinTextures);
			addChild(skin);
			skin.width = panelwidth;skin.height = panelheight;
			skin.alpha = 0.5;
			skin.addEventListener(TouchEvent.TOUCH,onSkinTouched);
			
			var skin1:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin1);
			skin1.width = 400*scale;
			skin1.height = 400*scale;
			skin1.x = panelwidth/2 - skin1.width/2;
			skin1.y = panelheight/2 - skin1.height/2;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth ,50*scale,LanguageController.getInstance().getString("shopTip02"),0x000000,25,true);
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			addChild(nameText);
			nameText.y = skin1.y+30*scale;
			
			var icon:Image = new Image(Game.assets.getTexture("gemIcon"));
			addChild(icon);
			icon.width = icon.height =60*scale;
			icon.x = panelwidth*0.5 - icon.width - 10*scale;
			icon.y = nameText.y + nameText.height+30*scale;
			
			var countText:TextField = FieldController.createSingleLineDynamicField(panelwidth *.5,40*scale,"×"+Configrations.CHANGE_NAME_COST,0x000000,35,true);
			countText.hAlign = HAlign.LEFT;
			countText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(countText);
			countText.x = panelwidth*0.5 + 10*scale;
			countText.y = icon.y + icon.height/2 - nameText.height/2;
			
			
			this.layout = new AnchorLayout();
			this._input = new TextInput();
			var _inputSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			this._input.backgroundSkin = new Scale9Image(_inputSkinTextures);
			_input.paddingLeft = 10;
			_input.width = 300 *scale;
			_input.height = 50 *scale;
			Factory(_input,{color:0x000000,fontSize:30,maxChars:15,text:player.name,displayAsPassword:false});
			this.addChild(this._input);
			_input.x = panelwidth/2 - _input.width/2;
			_input.y = icon.y + icon.height + 20*scale;
			
			this._backButton = new Button();
			_backButton.defaultSkin = new Image(Game.assets.getTexture("cancelButtonSkin"));
			this._backButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			this._backButton.label = LanguageController.getInstance().getString("cancel");
			_backButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0xffffff);
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
			_backButton.width = 100*scale;
			_backButton.height = 40*scale;
			addChild(_backButton);
			_backButton.x = panelwidth/2 -_backButton.width-10;
			_backButton.y = _input.y+_input.height + 50;
			

			_okButton = new Button();
			_okButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			_okButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			_okButton.label = LanguageController.getInstance().getString("confirm");
			_okButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0xffffff);
			_okButton.addEventListener(Event.TRIGGERED, okButton_triggeredHandler);
			addChild(_okButton);
			_okButton.width = 100*scale;
			_okButton.height = 40*scale;
			_okButton.x = panelwidth/2 +10;
			_okButton.y =_input.y+_input.height + 50;
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
		
		public var currentText:String;
		private function onBackButton():void
		{
			skin.removeEventListener(TouchEvent.TOUCH,onSkinTouched);
			_okButton.removeEventListener(Event.TRIGGERED, okButton_triggeredHandler);
			_backButton.removeEventListener(Event.TRIGGERED, backButton_triggeredHandler);
			this.dispatchEventWith(Event.COMPLETE);
		}
		private function onSkinTouched(e:TouchEvent):void
		{
			e.stopPropagation();
			var touch:Touch = e.getTouch(skin,TouchPhase.BEGAN);
			if(touch){
				currentText = player.name;
				onBackButton();
			}
		}
		private function backButton_triggeredHandler(event:Event):void
		{
			currentText = player.name;
			this.onBackButton();
		}

		private function okButton_triggeredHandler(e:Event):void
		{
			if(!isCommanding){
				if(_input.text == player.name){
					currentText = _input.text;
					this.onBackButton();
				}else{
					if(player.gem>= Configrations.CHANGE_NAME_COST){
						new ChangeNameCommand(_input.text,onChangeSuccess);
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
			currentText = _input.text;
			player.name = currentText;
			player.changeGem(-Configrations.CHANGE_NAME_COST);
			UiController.instance.configNameText();
			this.onBackButton();
		}
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}
