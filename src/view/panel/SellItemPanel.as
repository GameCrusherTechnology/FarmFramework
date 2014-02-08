package view.panel
{
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.NumericStepper;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.OwnedItem;
	import model.gameSpec.ItemSpec;
	import model.player.GamePlayer;
	
	import service.command.user.SellItemCommand;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.deg2rad;
	
	public class SellItemPanel extends PanelScreen
	{
		private var ownedItem:OwnedItem;
		private var panelwidth:Number;
		private var panelheight:Number;
		private var countStep:NumericStepper;
		private var bsSkin:Scale9Image;
		private var currentCount:int = 1;
		private var spec:ItemSpec;
		public function SellItemPanel(_item_id:String)
		{
			ownedItem  = player.getOwnedItem(_item_id);
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			var scale:Number = Configrations.ViewScale;
			
			spec = SpecController.instance.getItemSpec(ownedItem.itemid);
			currentCount = Math.ceil(ownedItem.count/2);
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			bsSkin = new Scale9Image(backgroundSkinTextures);
			addChild(bsSkin);
			bsSkin.width = panelwidth;bsSkin.height = panelheight;
			bsSkin.alpha = 0.4;
			bsSkin.addEventListener(TouchEvent.TOUCH,onSkinTouched);
			
			var skin1:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin1);
			skin1.width = panelwidth *.8;
			skin1.x = panelwidth/2 - skin1.width/2;
			skin1.y = panelheight*0.1;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth *.8,40*scale,LanguageController.getInstance().getString("smallshop"),0x000000,35,true);
			nameText.hAlign = HAlign.CENTER;
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			addChild(nameText);
			nameText.x = panelwidth *0.1;
			nameText.y = panelheight*0.12;
			
			
			backgroundSkinTextures =  new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			var skin2:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin2);
			skin2.width = panelwidth *.6;
			skin2.height = 120*scale;
			skin2.x = panelwidth/2 - skin2.width/2;
			skin2.y =  nameText.y + nameText.height + 10*scale;
			
			var iconSkin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			addChild(iconSkin);
			iconSkin.width = iconSkin.height = 110*scale; 
			iconSkin.x = panelwidth*0.35-iconSkin.width/2;
			iconSkin.y = skin2.y +5*scale;
			
			var icon:Image = new Image(Game.assets.getTexture(spec.name + "Icon"));
			addChild(icon);
			icon.width = icon.height =100*scale;
			icon.x = panelwidth*0.35-icon.width/2;
			icon.y = skin2.y+10*scale;
			
			countStep = creatSteper();
			addChild(countStep);
			countStep.x = panelwidth/2;
			countStep.y = skin2.y + icon.height/2;
			countStep.addEventListener(Event.CHANGE, step_changeHandler);
			
			var arrowIcon :Image = new Image(Game.assets.getTexture("rightArrowIcon"));
			arrowIcon.width = arrowIcon.height = 50*scale;
			arrowIcon.rotation = deg2rad(90);
			addChild(arrowIcon);
			arrowIcon.x = panelwidth/2 + 25*scale;
			arrowIcon.y = skin2.y + skin2.height + 5*scale;
			
			var skin3:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin3);
			skin3.width = panelwidth *.6;
			skin3.height = 120*scale;
			skin3.x = panelwidth/2 - skin2.width/2;
			skin3.y = arrowIcon.y + arrowIcon.height + 10*scale;
			
			var coinIcon:Image = new Image(Game.assets.getTexture("coinIcon"));
			addChild(coinIcon);
			coinIcon.width =coinIcon.height = 70*scale;
			coinIcon.x = panelwidth/2 - coinIcon.width - 10*scale;
			coinIcon.y = skin3.y + skin3.height/2 - coinIcon.height/2;
			
			coinText = FieldController.createSingleLineDynamicField(panelwidth *.5,coinIcon.height," ",0x000000,30,true);
			coinText.hAlign = HAlign.LEFT;
			addChild(coinText);
			coinText.x = panelwidth *0.5;
			coinText.y = coinIcon.y ;
			refreshValue();
			
			var button:Button = new Button();
			button.label = LanguageController.getInstance().getString("sell");
			button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			button.paddingLeft =button.paddingRight =  20;
			button.paddingTop =button.paddingBottom =  10;
			addChild(button);
			button.validate();
			button.x = Configrations.ViewPortWidth/2 - button.width/2;
			button.y =  skin3.y + skin3.height + 20*scale;
			button.addEventListener(Event.TRIGGERED,onTriggledSell);
			
			skin1.height =  button.y + button.height +20*scale- panelheight*0.1;
				
			var cancelButton:Button = new Button();
			cancelButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			cancelButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			addChild(cancelButton);
			cancelButton.width = cancelButton.height = 50*scale;
			cancelButton.x = panelwidth*0.9 -cancelButton.width -5;
			cancelButton.y = panelheight*0.1 +5;
			
		}
		
		private var coinText:TextField;
		private function refreshValue():void
		{
			coinText.text = "×" + spec.coinPrice*currentCount;
		}
		private function step_changeHandler(e:Event):void
		{
			currentCount = countStep.value;
			refreshValue();
		}
		
		private var isCommanding:Boolean;
		private function onTriggledSell(e:Event):void
		{
			if(!isCommanding){
				new SellItemCommand(spec.item_id,currentCount,onSelled);
				isCommanding = true;
			}
		}
		private function onSelled():void
		{
			isCommanding = false;
			player.deleteItem(new OwnedItem(spec.item_id,currentCount));
			player.addCoin(spec.coinPrice*currentCount);
			destroy();
		}
		private function closeButton_triggeredHandler(e:Event):void
		{
			destroy();
		}
		private function creatSteper():NumericStepper
		{
			var _stepper:NumericStepper = new NumericStepper();
			_stepper.minimum = 1;
			_stepper.maximum = ownedItem.count;
			_stepper.value =  currentCount;
			_stepper.step = 1;
			_stepper.width = panelwidth*.2;
			_stepper.height = panelheight*0.05;
			_stepper.decrementButtonLabel = "-";
			_stepper.incrementButtonLabel = "+";
			_stepper.decrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Image(Game.assets.getTexture("panelSkin") );
				button.width = panelheight*.05;
				button.height = panelheight*.05;
				button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
				return button;
			}
			_stepper.incrementButtonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Image(Game.assets.getTexture("panelSkin") );
				button.width = panelheight*.05;
				button.height = panelheight*.05;
				button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
				return button;
			}
			_stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.touchable = false;
				//skin the text input here
				input.backgroundSkin = new Image( Game.assets.getTexture("PanelRenderSkin") );
				Factory(input,{color:0x000000,fontSize:20,maxChars:15,text:"1",displayAsPassword:false});
				return input;
			}
			const stepperLayoutData:AnchorLayoutData = new AnchorLayoutData();
			stepperLayoutData.horizontalCenter = 0;
			stepperLayoutData.verticalCenter = 0;
			_stepper.layoutData = stepperLayoutData;
			return _stepper;
		}
		private function Factory(target:TextInput , inputParameters:Object ):void
		{
			var editor:StageTextTextEditor = new StageTextTextEditor;
			editor.textAlign = TextFormatAlign.CENTER;
			editor.color = (inputParameters.color == undefined) ? editor.color:inputParameters.color;
			editor.fontSize = (inputParameters.fontSize == undefined) ? editor.fontSize:inputParameters.fontSize;
			//			editor.editable =  (inputParameters.editable == undefined) ? editor.editable:inputParameters.editable;
			target.maxChars = (inputParameters.maxChars == undefined) ? editor.maxChars:inputParameters.maxChars;
			editor.displayAsPassword = (inputParameters.displayAsPassword == undefined)?editor.displayAsPassword:inputParameters.displayAsPassword;
			target.textEditorFactory = function textEditor():ITextEditor{return editor};
			target.text  = inputParameters.text;
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		private function onSkinTouched(e:TouchEvent):void
		{
			e.stopPropagation();
			var touch:Touch = e.getTouch(bsSkin,TouchPhase.BEGAN);
			if(touch){
				destroy();
			}
		}
		
		private function destroy():void
		{
			bsSkin.removeEventListener(TouchEvent.TOUCH,onSkinTouched);
			dispatchEvent(new Event(Event.CLOSE));
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}


