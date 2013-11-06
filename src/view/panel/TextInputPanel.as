package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.GameController;
	import controller.TextFieldFactory;
	
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
	
	import starling.display.Image;
	import starling.events.Event;

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

		protected function initializeHandler(event:Event):void
		{
			var panelwidth:Number = Configrations.ViewPortWidth*0.86;
			var panelheight:Number = Configrations.ViewPortHeight*0.7;
			var scale:Number = Configrations.ViewScale;
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			var skin:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin);
			skin.width = panelwidth;skin.height = panelheight;
			skin.alpha = 0.3;
			
			var skin1:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin1);
			skin1.width = 400*scale;
			skin1.height = 400*scale;
			skin1.x = panelwidth/2 - skin1.width/2;
			skin1.y = panelheight/2 - skin1.height/2;
			
			this.layout = new AnchorLayout();
			this._input = new TextInput();
			var _inputSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			this._input.backgroundSkin = new Scale9Image(_inputSkinTextures);
			_input.paddingLeft = 10;
			_input.width = 300 *scale;
			_input.height = 50 *scale;
			Factory(_input,{color:0x000000,fontSize:30,maxChars:15,text:player.farmName,displayAsPassword:false});
			this.addChild(this._input);
			_input.x = panelwidth/2 - _input.width/2;
			_input.y = panelheight/2 - _input.height-20;
			
			this._backButton = new Button();
			_backButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			this._backButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			this._backButton.label = LanguageController.getInstance().getString("cancel");
			_backButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(TextFieldFactory.FONT_FAMILY, 20, 0xffffff);
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
			_okButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(TextFieldFactory.FONT_FAMILY, 20, 0xffffff);
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
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			currentText = _input.text;
			this.onBackButton();
		}

		private function okButton_triggeredHandler(e:Event):void
		{
			currentText = _input.text;
			this.onBackButton();
		}
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}
