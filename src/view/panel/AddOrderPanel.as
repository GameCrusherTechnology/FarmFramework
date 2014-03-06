package view.panel
{
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.TextInput;
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.CropSpec;
	import model.gameSpec.ItemSpec;
	import model.player.GamePlayer;
	import model.task.TaskData;
	
	import service.command.task.CreatTaskCommand;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class AddOrderPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var listData:ListCollection;
		public function AddOrderPanel()
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Math.min(1800,Configrations.ViewPortWidth*0.8);
			panelheight = Math.min(1500,Configrations.ViewPortHeight*0.8);
			scale = Configrations.ViewScale;
			
			var cropSpecArr:Object = SpecController.instance.getGroup("Crop");
			listData = new ListCollection();
			var spec:CropSpec ;
			var specObj:Object;
			for each(spec in cropSpecArr){
				if(!spec.isTree){
					listData.push({text :spec.cname,item:spec});
				}
			}
			
			var darkSp:Shape = new Shape;
			darkSp.graphics.beginFill(0x000000,0.8);
			darkSp.graphics.drawRect(0,0,Configrations.ViewPortWidth,Configrations.ViewPortHeight);
			darkSp.graphics.endFill();
			addChild(darkSp);
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"),new Rectangle(20,20,24,24));
			var panelSkin:Scale9Image = new Scale9Image(skinTexture);
			panelSkin.width = panelwidth;
			panelSkin.height = panelheight;
			addChild(panelSkin);
			panelSkin.x = Configrations.ViewPortWidth/2  - panelSkin.width/2;
			panelSkin.y = Configrations.ViewPortHeight/2 - panelSkin.height/2;
		
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.8,40*scale,LanguageController.getInstance().getString("creat") +" "+LanguageController.getInstance().getString("order"),0x000000,35,true);
			nameText.hAlign = HAlign.CENTER;
			addChild(nameText);
			nameText.x = Configrations.ViewPortWidth/2  - nameText.width/2;
			nameText.y = (Configrations.ViewPortHeight - panelheight)/2 + 10*scale;
			
			var request:Sprite = configRequestContainer();
			addChild(request);
			request.x = Configrations.ViewPortWidth/2  - request.width/2;
			request.y = nameText.y + nameText.height ;
			
			var reward:Sprite = configRewardContainer();
			addChild(reward);
			reward.x = Configrations.ViewPortWidth/2  - reward.width/2;
			reward.y = request.y + request.height +10*scale;
			
			var button:Button = new Button();
			button.label = LanguageController.getInstance().getString("confirm");
			button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			button.paddingLeft =button.paddingRight =  20;
			button.paddingTop =button.paddingBottom =  5;
			addChild(button);
			button.validate();
			button.x = Configrations.ViewPortWidth/2 - button.width/2;
			button.y =  panelSkin.y + panelheight*0.9;
			button.addEventListener(Event.TRIGGERED,onTriggered);
			
			
			var cancelButton:Button = new Button();
			cancelButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			cancelButton.addEventListener(Event.TRIGGERED, onCloseTriggered);
			addChild(cancelButton);
			cancelButton.width = cancelButton.height = Configrations.ViewPortHeight*0.05;
			cancelButton.x = Configrations.ViewPortWidth/2 +panelwidth/2- cancelButton.width-5;
			cancelButton.y = Configrations.ViewPortHeight/2 -panelheight/2 + panelheight*0.02;
			
		}
		private var list1:PickerList;
		private var list2:PickerList;
		private var list3:PickerList;
		private var step1:NumericStepper;
		private var step2:NumericStepper;
		private var step3:NumericStepper;
		
		private function configRequestContainer():Sprite
		{
			
			var requestContainer:Sprite = new Sprite;
			var container1:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			requestContainer.addChild(container1);
			container1.width = panelwidth*0.8;
			container1.height = panelheight*0.5;
			
			var whiteSp:Shape = new Shape();
			requestContainer.addChild(whiteSp);
			
			var str:String = LanguageController.getInstance().getString("request")+" :";
			var textRequest:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.8,35*scale,str,0x000000,30,true);
			textRequest.hAlign = HAlign.LEFT;
			textRequest.vAlign = VAlign.BOTTOM;
			requestContainer.addChild(textRequest);
			textRequest.x = 10*scale;
			textRequest.y = 10*scale;
			
			var deep:Number = textRequest.y + textRequest.height+20*scale;
			list1 = creatPickList();
			requestContainer.addChild(list1);
			list1.y = deep;
			list1.x = panelwidth/4 -list1.width/2;
			
			step1 = creatSteper();
			requestContainer.addChild(step1);
			step1.y = deep+5;
			step1.x = panelwidth/2;
			
			whiteSp.graphics.lineStyle(2,0xEDCC97,1);
			whiteSp.graphics.moveTo(panelwidth*0.1,deep + panelheight*0.1);
			whiteSp.graphics.lineTo(panelwidth*0.7,deep + panelheight*0.1);
			whiteSp.graphics.endFill();
			
			deep  += panelheight*0.12+10*scale;
			
			list2 = creatPickList();
			requestContainer.addChild(list2);
			list2.y = deep;
			list2.x = panelwidth/4 -list2.width/2;
			step2 = creatSteper();
			requestContainer.addChild(step2);
			step2.y =deep+5;
			step2.x = panelwidth/2;
			
			whiteSp.graphics.lineStyle(2,0xEDCC97,1);
			whiteSp.graphics.moveTo(panelwidth*0.1,deep + panelheight*0.1);
			whiteSp.graphics.lineTo(panelwidth*0.7,deep + panelheight*0.1);
			whiteSp.graphics.endFill();
			
			deep  += panelheight*0.12+10*scale;
			
			list3 = creatPickList();
			requestContainer.addChild(list3);
			list3.y = deep;
			list3.x = panelwidth/4 -list3.width/2;
			step3 = creatSteper();
			requestContainer.addChild(step3);
			step3.y = deep+5;
			step3.x = panelwidth/2;
			
			step1.addEventListener(Event.CHANGE,onChange);
			list1.addEventListener(Event.CHANGE,onChange);
			step2.addEventListener(Event.CHANGE,onChange);
			list2.addEventListener(Event.CHANGE,onChange);
			step3.addEventListener(Event.CHANGE,onChange);
			list3.addEventListener(Event.CHANGE,onChange);
			return requestContainer;
		}
		private var coinText:TextField;
//		private var expText:TextField;
		private function configRewardContainer():Sprite
		{
			var reqwardContainer:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			reqwardContainer.width = panelwidth*0.8;
			reqwardContainer.height = panelheight*0.2;
			
			var str:String = LanguageController.getInstance().getString("reward")+" :";
			var textRequest:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.8,35*scale,str,0x000000,30,true);
			textRequest.hAlign = HAlign.LEFT;
			textRequest.vAlign = VAlign.BOTTOM;
			reqwardContainer.addChild(textRequest);
			textRequest.x = 10*scale;
			textRequest.y = 10*scale;
			
//			var expicon:Image = new Image(Game.assets.getTexture("expIcon"));
//			reqwardContainer.addChild(expicon);
//			expicon.width = expicon.height = panelheight*0.1;
//			expicon.x = panelwidth*0.1;
//			expicon.y = textRequest.y+textRequest.height;
//			
//			expText = FieldController.createSingleLineDynamicField(panelwidth*0.4,panelheight*0.1,"×"+String(0),0x000000,25,true);
//			expText.hAlign = HAlign.LEFT;
//			expText.vAlign = VAlign.CENTER;
//			reqwardContainer.addChild(expText);
//			expText.x = expicon.x + expicon.width;
//			expText.y = textRequest.y+textRequest.height;
			
			var coinicon:Image = new Image(Game.assets.getTexture("coinIcon"));
			reqwardContainer.addChild(coinicon);
			coinicon.width = coinicon.height = panelheight*0.1;
			coinicon.x = panelwidth*0.4 - coinicon.width - 10*scale;
			coinicon.y = textRequest.y+textRequest.height;
			
			coinText = FieldController.createSingleLineDynamicField(panelwidth*0.2,panelheight*0.1,"×"+String(0),0x000000,25,true);
			coinText.hAlign = HAlign.LEFT;
			coinText.vAlign = VAlign.CENTER;
			reqwardContainer.addChild(coinText);
			coinText.x = panelwidth*0.4 + 10*scale;
			coinText.y = textRequest.y+textRequest.height;
			
			
			return reqwardContainer;
		}
		private function creatPickList():PickerList
		{
			var _list:PickerList = new PickerList();
			_list.prompt = LanguageController.getInstance().getString("SelectItem");
			_list.dataProvider = listData;
			_list.selectedIndex = -1;
			const listLayoutData:AnchorLayoutData = new AnchorLayoutData();
			listLayoutData.horizontalCenter = 0;
			listLayoutData.verticalCenter = 0;
			_list.layoutData = listLayoutData;
			
			_list.typicalItem = { text:  LanguageController.getInstance().getString("SelectItem") };
			_list.labelField = "text";
			
			_list.buttonFactory = function():Button
			{
				var button:Button = new Button();
				button.height = panelheight*0.12;
				button.defaultSkin = new Image( Game.assets.getTexture("greenButtonSkin") );
				button.paddingTop = button.paddingBottom = 20*scale;
				button.paddingLeft = button.paddingRight = 40*scale;
				button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
				return button;
			};
			
			_list.popUpContentManager = new DropDownPopUpContentManager();
			_list.listFactory = function():List
			{
				var list:List = new List();
				list.height =200*scale;
				list.itemRendererFactory = function():IListItemRenderer
				{
					var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
					renderer.labelField = "text";
					renderer.iconFunction = function (spec:Object):Image{
						var img:Image = new Image(Game.assets.getTexture(spec.item.name + "Icon")) ;
						img.width = img.height = 50*scale;
						return img;
					};
					var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(1, 1, 62, 62));
					renderer.defaultSkin = new Scale9Image(skintextures);
					renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
					renderer.height=60*scale;
					return renderer;
				};
				return list;
			};
			return _list;
		}
		
		private function creatSteper():NumericStepper
		{
			var _stepper:NumericStepper = new NumericStepper();
			_stepper.minimum = 0;
			_stepper.maximum = 100;
			_stepper.value = 50;
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
				input.touchable=false;
				//skin the text input here
				input.backgroundSkin = new Image( Game.assets.getTexture("PanelRenderSkin") );
				Factory(input,{color:0x000000,fontSize:20*scale,maxChars:15,text:player.name,displayAsPassword:false});
				return input;
			}
			const stepperLayoutData:AnchorLayoutData = new AnchorLayoutData();
			stepperLayoutData.horizontalCenter = 0;
			stepperLayoutData.verticalCenter = 0;
			_stepper.layoutData = stepperLayoutData;
			return _stepper;
		}
		
		private function onChange(e:Event):void{
			refreshReward();
		}
		private function refreshReward():void
		{
			var coin:int ;
//			var exp :int;
			var spec:ItemSpec;
			if(list1.selectedItem && list1.selectedItem.item){
				spec =  list1.selectedItem.item ; 
				if(step1.value >0){
					coin += (step1.value*coin_s *spec.coinPrice);
//					exp+= (step1.value*exp_s *spec.exp);
				}
			}
			
			if(list2.selectedItem && list2.selectedItem.item){
				spec =  list2.selectedItem.item ; 
				if(step2.value >0){
					coin += (step2.value*coin_s *spec.coinPrice);
//					exp+= (step2.value*exp_s *spec.exp);
				}
			}
			if(list3.selectedItem && list3.selectedItem.item){
				spec =  list3.selectedItem.item ; 
				if(step3.value >0){
					coin += (step3.value*coin_s *spec.coinPrice);
//					exp+= (step3.value*exp_s *spec.exp);
				}
			}
			coinText.text = "×"+coin;
//			expText.text =  "×"+exp;
		}
		private function onCloseTriggered(e:Event):void
		{
			close();
		}
		
		private var lastCoin:int;
		private function onTriggered(e:Event):void
		{
			if(!isCommanding){
				var spec:ItemSpec;
				var coin:int;
	//			var exp:int;
				var requestArr:Array = [];
				var object:Object = {};
				if(list1.selectedItem && list1.selectedItem.item){
					spec =  list1.selectedItem.item ; 
					if(step1.value >0){
						coin += (step1.value*coin_s *spec.coinPrice);
	//					exp+= (step1.value*exp_s *spec.exp);
						object[spec.item_id] = {id:spec.item_id,count:step1.value};
					}
				}
				
				if(list2.selectedItem && list2.selectedItem.item){
					spec =  list2.selectedItem.item ; 
					if(step2.value >0){
						coin += (step2.value*coin_s *spec.coinPrice);
	//					exp+= (step2.value*exp_s *spec.exp);
						if(object[spec.item_id]){
							object[spec.item_id] = {id:spec.item_id,count:step2.value +object[spec.item_id].count};
						}else{
							object[spec.item_id] = {id:spec.item_id,count:step2.value};
						}
					}
				}
				if(list3.selectedItem && list3.selectedItem.item){
					spec =  list3.selectedItem.item ; 
					if(step3.value >0){
						coin += (step3.value*coin_s *spec.coinPrice);
	//					exp+= (step3.value*exp_s *spec.exp);
						if(object[spec.item_id]){
							object[spec.item_id] = {id:spec.item_id,count:step3.value +object[spec.item_id].count};
						}else{
							object[spec.item_id] = {id:spec.item_id,count:step3.value};
						}
					}
				}
				for each(var obj:Object in object){
					requestArr.push(obj.id+":"+obj.count);
				}
				lastCoin= coin;
				if(requestArr.length >= 1){
					var requestStr:String = requestArr.join("|");
					var rewardStr:String = Configrations.REWARD_COIN+":"+coin;
					var taskdata:TaskData = new TaskData();
					taskdata.requstStr = requestStr;
					taskdata.rewards = rewardStr;
					taskdata.npc = Configrations.NPC_NONE;
					new CreatTaskCommand(taskdata,onCreated);
					isCommanding = true;
				}else{
					close();
				}
			}
		}
		private var isCommanding:Boolean;
		private function onCreated():void
		{
			isCommanding = false;
			player.addCoin(-lastCoin);
			close();
		}
		private function close():void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
			if(parent){
				parent.removeChild(this);
			}
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
		
		private var coin_s:Number = 1;
		private var exp_s:Number = 1;
	}
}