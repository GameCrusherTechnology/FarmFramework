package view.render
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.FriendInfoController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.SimplePlayer;
	
	import service.command.friend.FindFriendCommand;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	import view.panel.WarnnigTipPanel;
	
	public class FindFriendRender extends PanelScreen
	{
		private var scale:Number;
		public function FindFriendRender(w:Number,h:Number)
		{
			renderwidth = w;
			renderheight = h;
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			scale = Configrations.ViewScale;
		}
		protected function initializeHandler(event:Event):void
		{
			configLayout();
		}
		private var container:Sprite;
		private var playerData:SimplePlayer;
		
		private var renderwidth:Number ;
		private var renderheight:Number
		private function configLayout():void
		{
			container = new Sprite;
			addChild(container);
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20));
			var panelSkin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(panelSkin);
			panelSkin.width = renderwidth;
			panelSkin.height = renderheight;
			configFindContainer();
		}
		private var _findContainer:Sprite ;
		private var _input:TextInput;
		private function configFindContainer():void
		{
			if(_findContainer&& _findContainer.parent){
				_findContainer.parent.removeChild(_findContainer);
			}
			_findContainer = new Sprite;
			container.addChild(_findContainer);
			_findContainer.y = renderheight*0.05;
			
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			var skin:Scale9Image = new Scale9Image(skintextures);
			_findContainer.addChild(skin);
			skin.width = renderwidth*0.8;
			skin.height = renderheight*0.4;
			skin.x = renderwidth*0.1;
			skin.y = renderheight*0.05;
			
			var idtext:TextField = FieldController.createSingleLineDynamicField(renderwidth,skin.height,"ID"+": " ,0x000000,25);
			_findContainer.addChild(idtext);
			idtext.autoSize = TextFieldAutoSize.HORIZONTAL;
			idtext.y = skin.y;
			idtext.x = skin.x + renderwidth*0.1;
			
			var findBut:Button = new Button();
			findBut.label = LanguageController.getInstance().getString("find");
			findBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			findBut.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			findBut.paddingLeft =findBut.paddingRight =  20;
			findBut.paddingTop =findBut.paddingBottom =  5;
			_findContainer.addChild(findBut);
			findBut.validate();
			findBut.x = skin.x + skin.width - findBut.width-20*scale;
			findBut.y = skin.y + skin.height/2 - findBut.height/2;
			findBut.addEventListener(Event.TRIGGERED,onTriggeredFind);
			
			
			_input = new TextInput();
			var _inputSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			_input.backgroundSkin = new Scale9Image(_inputSkinTextures);
			_input.paddingLeft = 10;
			_input.width = 250 *scale;
			_input.height = 50 *scale;
			Factory(_input,{color:0x000000,fontSize:30*scale,maxChars:15,text:"111",displayAsPassword:false});
			_findContainer.addChild(this._input);
			_input.x = idtext.x+idtext.width +10*scale;
			_input.y = skin.y + skin.height/2 -  _input.height/2;
			
		}
		private var _playerContainer:Sprite ;
		private function configPlayerContainer():void
		{
			if(playerData){
				if(_playerContainer&& _playerContainer.parent){
					_playerContainer.parent.removeChild(_playerContainer);
					_playerContainer.dispose();
				}
				_playerContainer = new Sprite;
				container.addChild(_playerContainer);
				_playerContainer.y = renderheight*0.55;
					
				var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("talkSkin"), new Rectangle(1, 1, 62, 62));
				var skin:Scale9Image = new Scale9Image(skintextures);
				_playerContainer.addChild(skin);
				skin.width = renderwidth*0.6;
				skin.height = renderheight*0.3;
				skin.x = renderwidth*0.2;
				
				var icon:Image= new Image(Game.assets.getTexture(playerData.headIconName));
				icon.height = renderheight*0.25;
				icon.scaleX = icon.scaleY;
				icon.x = skin.x + 10*scale;
				icon.y = renderheight*0.05;
				_playerContainer.addChild(icon);
				
				var iconRight:Number = icon.x + icon.width + 10*scale;
				
				var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
				expIcon.width = expIcon.height = 40*scale;
				_playerContainer.addChild(expIcon);
				expIcon.x = iconRight;
				expIcon.y = icon.y ;
				
				var levelText:TextField = FieldController.createSingleLineDynamicField(expIcon.width,40*scale,String(Configrations.expToGrade(playerData.exp)),0x000000,20,true);
				_playerContainer.addChild(levelText);
				levelText.x = iconRight;
				levelText.y = icon.y ;
				
				
				var nameText:TextField = FieldController.createNoFontField(renderwidth - iconRight,40*scale,playerData.name,0x000000,25);
				nameText.hAlign = HAlign.LEFT;
				_playerContainer.addChild(nameText);
				nameText.x = iconRight+expIcon.width+10*scale;
				nameText.y = icon.y ;
				
				var achIcon:Image = new Image(Game.assets.getTexture("achieveIcon"));
				achIcon.width = achIcon.height = 40*scale;
				_playerContainer.addChild(achIcon);
				achIcon.x =  iconRight+expIcon.width+10*scale;
				achIcon.y = nameText.y + nameText.height;
				
				var totalP:int = Configrations.getTotalAchievePoint(playerData.achieve);
				var countText:TextField = FieldController.createSingleLineDynamicField(300,300,"×"+totalP,0x000000,25,true);
				countText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				_playerContainer.addChild(countText);
				countText.x = achIcon.x + achIcon.width + 10*scale;
				countText.y = achIcon.y + achIcon.height/2 - countText.height/2;
				
				var visitButton:Button = new Button();
				visitButton.label = LanguageController.getInstance().getString("visit");
				visitButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
				visitButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				visitButton.paddingLeft =visitButton.paddingRight =  20;
				visitButton.paddingTop =visitButton.paddingBottom =  5;
				_playerContainer.addChild(visitButton);
				visitButton.validate();
				visitButton.x = renderwidth*0.8 - visitButton.width - 10*scale ;
				visitButton.y =  renderheight*0.15 - visitButton.height/2;
				visitButton.addEventListener(Event.TRIGGERED,onTriggeredMale);
			}
		}
		private var isFinding:Boolean;
		private function onTriggeredFind(e:Event):void
		{
			if(!isFinding ){
				if(playerData && playerData.gameuid == _input.text){
					
				}else{
					new FindFriendCommand(int(_input.text),onFinded,onError);
					isFinding = true;
				}
			}
		}
		private function onFinded(data:Object):void
		{
			isFinding = false;
			if(data){
				playerData = new SimplePlayer(data);
				configPlayerContainer();
			}else{
				onError();
			}
		}
		private function onError():void
		{
			isFinding = false;	
			DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warnintTip05")));
		}
		private function onTriggeredMale(e:Event):void
		{
			GameController.instance.visitFriend(playerData.gameuid);
		}
		private function Factory(target:TextInput , inputParameters:Object ):void
		{
			var editor:StageTextTextEditor = new StageTextTextEditor;
			editor.restrict = "0-9";
			editor.color = (inputParameters.color == undefined) ? editor.color:inputParameters.color;
			editor.fontSize = (inputParameters.fontSize == undefined) ? editor.fontSize:inputParameters.fontSize;
			//			editor.editable =  (inputParameters.editable == undefined) ? editor.editable:inputParameters.editable;
			target.maxChars = (inputParameters.maxChars == undefined) ? editor.maxChars:inputParameters.maxChars;
			editor.displayAsPassword = (inputParameters.displayAsPassword == undefined)?editor.displayAsPassword:inputParameters.displayAsPassword;
			target.textEditorFactory = function textEditor():ITextEditor{return editor};
//			target.text  = inputParameters.text;
		}
	}
}

