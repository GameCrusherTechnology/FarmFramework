package view.render
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.display.Scale9Image;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.SystemDate;
	
	import model.MessageData;
	import model.player.SimplePlayer;
	
	import service.command.user.UpdateMessagesCommand;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MessageListRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		public function MessageListRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var mesData:MessageData;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				mesData = value as MessageData;
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
					container = null;
				}
				if(mesData.gameuid){
					configLayout();
				}else{
					configLayout1();
				}
			}
		}
		private function configLayout():void
		{
			var renderwidth:Number = width;
			var renderheight:Number = height;
			
			container = new Sprite;
			addChild(container);
			var playerData:SimplePlayer = mesData.player; 
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20,20,24,24));
			var skin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(skin);
			skin.width = renderwidth;
			skin.height = renderheight;
			
			var icon:Image= new Image(Game.assets.getTexture((playerData.sex==Configrations.CHARACTER_BOY)?"boyIcon":"girlIcon"));
			icon.height = 40*scale;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = renderheight*0.1;
			container.addChild(icon);
			
			var iconRight:Number = icon.x + icon.width + 10*scale;
			
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth - iconRight,40*scale,playerData.name,0x000000,35,true);
			nameText.hAlign = HAlign.LEFT;
			container.addChild(nameText);
			nameText.x = iconRight;
			nameText.y = icon.y ;
			
			
			var titleText:TextField = FieldController.createSingleLineDynamicField(renderwidth *0.8,renderheight - 40*scale,mesData.message,0x000000,25,true);
			container.addChild(titleText);
			titleText.vAlign = VAlign.TOP;
			titleText.x = renderwidth *0.1;
			titleText.y = nameText.y + nameText.height ;
			
			var leftTimeStr:String = "("+SystemDate.getTimeLeftString(SystemDate.systemTimeS - mesData.updatetime) +" "+ LanguageController.getInstance().getString("ago")+")";
			var timeText:TextField = FieldController.createSingleLineDynamicField(renderwidth - iconRight,25*scale,leftTimeStr,0x000000,20,true);
			container.addChild(timeText);
			timeText.x = iconRight;
			timeText.y =  renderheight - timeText.height ;
			
			if(mesData.gameuid != GameController.instance.localPlayer.gameuid){
			var visitButton:Button = new Button();
			visitButton.label = LanguageController.getInstance().getString("visit");
			visitButton.addEventListener(Event.TRIGGERED,onTriggeredVisit);
			visitButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			visitButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			visitButton.paddingLeft =visitButton.paddingRight =  20;
			visitButton.paddingTop =visitButton.paddingBottom =  5;
			container.addChild(visitButton);
			visitButton.validate();
			visitButton.x = renderwidth - visitButton.width-10*scale;
			visitButton.y =  renderheight*0.1;
			}
			
			if(GameController.instance.isHomeModel){
				var removeButton:Button = new Button();
				removeButton.addEventListener(Event.TRIGGERED,onTriggeredRemove);
				removeButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
				removeButton.width = removeButton.height = 30*scale;
				container.addChild(removeButton);
				removeButton.validate();
				removeButton.x = renderwidth - removeButton.width-10*scale;
				removeButton.y =  renderheight*0.95 - removeButton.height;
			}
		}
		
		private function configLayout1():void
		{
			var renderwidth:Number = width;
			var renderheight:Number = height;
			
			container = new Sprite;
			addChild(container);
			
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20,20,24,24));
			var skin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(skin);
			skin.width = renderwidth;
			skin.height = renderheight;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth ,40*scale,LanguageController.getInstance().getString("leaveMessage"),0x000000,35,true);
			nameText.hAlign = HAlign.LEFT;
			container.addChild(nameText);
			nameText.x = 20*scale;
			
			var postBut:Button = new Button();
			postBut.label = LanguageController.getInstance().getString("send");
			postBut.addEventListener(Event.TRIGGERED,onTriggeredSend);
			postBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			postBut.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			postBut.paddingLeft =postBut.paddingRight =  20*scale;
			postBut.paddingTop =postBut.paddingBottom =  5*scale;
			container.addChild(postBut);
			postBut.validate();
			postBut.x = renderwidth - postBut.width-10*scale;
			postBut.y =  nameText.y + nameText.height+ 10*scale;
			
			_input = new TextInput();
			var _inputSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			_input.backgroundSkin = new Scale9Image(_inputSkinTextures);
			_input.paddingLeft = 10;
			_input.width = postBut.x - nameText.x - 20*scale;
			_input.height = postBut.height;
			Factory(_input,{color:0x000000,fontSize:30,maxChars:100,text:"",displayAsPassword:false});
			container.addChild(_input);
			_input.y = nameText.y + nameText.height + 10*scale;
			_input.x = nameText.x;
			
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
		
		private var _input:TextInput;
		private var newmessageData:MessageData;
		private function onTriggeredSend(e:Event):void
		{
			if(_input && _input.text){
				newmessageData = new MessageData({gameuid:GameController.instance.localPlayer.gameuid,f_gameuid:GameController.instance.currentPlayer.gameuid,
					message:_input.text,type:Configrations.MESSTYPE_MES,data_id:GameController.instance.currentPlayer.cur_mes_dataid+1});
				new UpdateMessagesCommand([newmessageData],[],onUpdated);
			}
		}
		private function onUpdated():void
		{
			newmessageData.updatetime = SystemDate.systemTimeS;
			GameController.instance.currentPlayer.addMessage(newmessageData);
		}
		private function onTriggeredVisit(e:Event):void
		{
			GameController.instance.visitFriend(mesData.gameuid);
		}
		private function onTriggeredRemove(e:Event):void
		{
			new UpdateMessagesCommand([],[{f_gameuid:mesData.f_gameuid,data_id:mesData.data_id}],onDeleted);
		}
		private function onDeleted():void
		{
			GameController.instance.currentPlayer.delMessage(mesData);
		}
	}
}

