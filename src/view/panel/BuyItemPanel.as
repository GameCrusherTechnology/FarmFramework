package view.panel
{
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import controller.DialogController;
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
	
	import service.command.shop.BuyItemCommand;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;

	public class BuyItemPanel extends PanelScreen
	{
		private var item_id:String;
		private var panelwidth:Number;
		private var panelheight:Number;
		private var countStep:NumericStepper;
		private var bsSkin:Scale9Image;
		private var currentCount:int = 1;
		private var gemButton:Button;
		private var coinButton:Button ;
		private var spec:ItemSpec;
		public function BuyItemPanel(_id:String)
		{
			item_id  = _id;
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			var scale:Number = Configrations.ViewScale;
			
			spec = SpecController.instance.getItemSpec(item_id);
			
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			bsSkin = new Scale9Image(backgroundSkinTextures);
			addChild(bsSkin);
			bsSkin.width = panelwidth;bsSkin.height = panelheight;
			bsSkin.alpha = 0.3;
			bsSkin.addEventListener(TouchEvent.TOUCH,onSkinTouched);
			
			var skin1:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin1);
			skin1.width = panelwidth *.8;
			skin1.height =panelheight*.8;
			skin1.x = panelwidth/2 - skin1.width/2;
			skin1.y = panelheight/2 - skin1.height/2;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth *.8,40*scale,LanguageController.getInstance().getString("qucickshop"),0x000000,35,true);
			nameText.hAlign = HAlign.CENTER;
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			addChild(nameText);
			nameText.x = panelwidth *0.1;
			nameText.y = panelheight*0.12;
			
			var tipText:TextField = FieldController.createSingleLineDynamicField(panelwidth *.8,80*scale,LanguageController.getInstance().getString("shopTip01"),0x000000,30,true);
			addChild(tipText);
			tipText.x = panelwidth *0.1;
			tipText.y = panelheight*0.15;
			
			backgroundSkinTextures =  new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			var skin2:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin2);
			skin2.width = panelwidth *.6;
			skin2.height = 120*scale;
			skin2.x = panelwidth/2 - skin2.width/2;
			skin2.y =  tipText.y + tipText.height;
			
			var iconSkin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			addChild(iconSkin);
			iconSkin.width = iconSkin.height = 110*scale; 
			iconSkin.x = panelwidth*0.35-iconSkin.width/2;
			iconSkin.y = tipText.y + tipText.height+5*scale;
			
			var icon:Image = new Image(Game.assets.getTexture(spec.name + "Icon"));
			addChild(icon);
			icon.width = icon.height =100*scale;
			icon.x = panelwidth*0.35-icon.width/2;
			icon.y = tipText.y + tipText.height+10*scale;
			
			countStep = creatSteper();
			addChild(countStep);
			countStep.x = panelwidth/2;
			countStep.y = tipText.y + tipText.height + icon.height/2;
			countStep.addEventListener(Event.CHANGE, step_changeHandler);
			
			
			var tip2Text:TextField = FieldController.createSingleLineDynamicField(panelwidth *.6,80*scale,LanguageController.getInstance().getString("cost")+" "+LanguageController.getInstance().getString("you")+" :",0x000000,30,true);
			tip2Text.hAlign = HAlign.LEFT;
			addChild(tip2Text);
			tip2Text.x = panelwidth *0.2;
			tip2Text.y = skin2.y + skin2.height + 10*scale;
			
			var deep:Number = tip2Text.y+tip2Text.height + 10*scale;
			
			if(spec.coinPrice >0){
				coinButton = new Button();
				coinButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
				//			coinButton.label = LanguageController.getInstance().getString("coin")+4464613;
				coinButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				coinButton.addEventListener(Event.TRIGGERED, coinButton_triggeredHandler);
				coinButton.width = panelwidth*0.2;
				coinButton.height = 50*scale;
				//			coinButton.paddingLeft = coinButton.paddingRight = 20*scale;
				//			coinButton.paddingTop = coinButton.paddingBottom = 10*scale;
				addChild(coinButton);
				//			coinButton.validate();
				coinButton.x = panelwidth/2 -coinButton.width/2;
				coinButton.y = deep;
				
				
				var coinIcon :Image = new Image(Game.assets.getTexture("coinIcon"));
				coinButton.addChild(coinIcon);
				coinIcon.width =coinIcon.height = coinButton.height*1.2;
				coinIcon.x = - coinIcon.width/2;
				coinIcon.y = -coinButton.height*0.1;
				
				deep = coinButton.y + coinButton.height + 10*scale;
				
			}
			if(spec.coinPrice >0 && spec.gemPrice >0){
				var tip3Text:TextField = FieldController.createSingleLineDynamicField(panelwidth *.6,40*scale,LanguageController.getInstance().getString("or"),0x000000,30,true);
				addChild(tip3Text);
				tip3Text.x = panelwidth *0.2;
				tip3Text.y = deep;
				deep = tip3Text.y+tip3Text.height + 10*scale;
			}
			if(spec.gemPrice >0){
				gemButton = new Button();
				gemButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
	//			gemButton.label = LanguageController.getInstance().getString("gem");
				gemButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				gemButton.addEventListener(Event.TRIGGERED, gemButton_triggeredHandler);
				gemButton.width = panelwidth*0.2;
				gemButton.height = 50*scale;
	//			gemButton.paddingLeft = gemButton.paddingRight = 20*scale;
	//			gemButton.paddingTop = gemButton.paddingBottom = 10*scale;
				addChild(gemButton);
	//			gemButton.validate();
				gemButton.x = panelwidth/2 -gemButton.width/2;
				gemButton.y = deep;
				
				var gemIcon :Image = new Image(Game.assets.getTexture("gemIcon"));
				gemButton.addChild(gemIcon);
				gemIcon.width =gemIcon.height = gemButton.height*1.2;
				gemIcon.x = - gemIcon.width/2;
				gemIcon.y = -gemButton.height*0.1;
			}
			refreshValue();
			
			var cancelButton:Button = new Button();
			cancelButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			cancelButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			addChild(cancelButton);
			cancelButton.width = cancelButton.height = 50*scale;
			cancelButton.x = panelwidth*0.9 -cancelButton.width -5;
			cancelButton.y = panelheight*0.1 +5;
			
		}
		
		private function refreshValue():void
		{
			if(coinButton){
				coinButton.label = String(currentCount*spec.coinPrice*10);
				coinButton.validate();
			}
			if(gemButton){
				gemButton.label =  String(currentCount*spec.gemPrice);
				gemButton.validate();
			}
		}
		private function step_changeHandler(e:Event):void
		{
			currentCount = countStep.value;
			refreshValue();
		}
		
		private var isCommanding:Boolean;
		private function coinButton_triggeredHandler(e:Event):void
		{
			if(!isCommanding){
				if(player.coin>= currentCount*spec.coinPrice*10){
					isCommanding = true;
					new BuyItemCommand(item_id,currentCount,Configrations.METHOD_COIN,onBuyCoin);
				}else{
					DialogController.instance.showPanel(new TreasurePanel);
				}
			}
		}
		private function gemButton_triggeredHandler(e:Event):void
		{
			if(!isCommanding){
				if(player.gem>= currentCount*spec.gemPrice){
					isCommanding = true;
					new BuyItemCommand(item_id,currentCount,Configrations.METHOD_MONEY,onBuy);
				}else{
					DialogController.instance.showPanel(new TreasurePanel);
				}
			}
		}
		
		private function onBuy():void
		{
			isCommanding = false;
			player.addItem(new OwnedItem(item_id,currentCount));
			player.changeGem(- int(currentCount*spec.gemPrice));
			destroy();
		}
		
		private function onBuyCoin():void
		{
			isCommanding = false;
			player.addItem(new OwnedItem(item_id,currentCount));
			player.addCoin(- int(currentCount*spec.coinPrice*10));
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
			_stepper.maximum = 100;
			_stepper.value = 1;
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
				Factory(input,{color:0x000000,fontSize:20*Configrations.ViewScale,maxChars:15,text:player.name,displayAsPassword:false});
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
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}