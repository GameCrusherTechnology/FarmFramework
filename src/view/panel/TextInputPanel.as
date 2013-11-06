package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.GameController;
	import controller.TextFieldFactory;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showSettings",type="starling.events.Event")]

	public class TextInputPanel extends PanelScreen
	{
		public static const SHOW_SETTINGS:String = "showSettings";

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
			
			this.layout = new AnchorLayout();
			this._input = new TextInput();
			var _inputSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			this._input.backgroundSkin = new Scale9Image(_inputSkinTextures);
			this._input.prompt = player.farmName;
			this._input.maxChars = 15;
			_input.paddingLeft = 10;
			const inputLayoutData:AnchorLayoutData = new AnchorLayoutData();
			inputLayoutData.horizontalCenter = 0;
			inputLayoutData.verticalCenter = 0;
			this._input.layoutData = inputLayoutData;
			_input.width = 300 *scale;
			_input.height = 45 *scale;
			_input.promptFactory = function():ITextRenderer
			{
				var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
				textRenderer.textFormat = new BitmapFontTextFormat(TextFieldFactory.FONT_FAMILY, 40, 0x000000);
				return textRenderer;
			}
			_input.addEventListener(Event.CHANGE,onTextChange);
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
			_okButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
			addChild(_okButton);
			_okButton.width = 100*scale;
			_okButton.height = 40*scale;
			_okButton.x = panelwidth/2 +10;
			_okButton.y =_input.y+_input.height + 50;
		}

		private function onTextChange(e:Event):void
		{
			_input.validate();
			trace(e);
		}
		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}
