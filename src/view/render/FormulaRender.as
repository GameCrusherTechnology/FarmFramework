package view.render
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	import controller.VoiceController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.SystemDate;
	
	import model.OwnedItem;
	import model.gameSpec.FormulaItemSpec;
	import model.gameSpec.ItemSpec;
	import model.player.GamePlayer;
	
	import service.command.factory.AddFormulaCommand;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.deg2rad;
	
	import view.component.PackageIcon;
	import view.panel.OpenFormulaPanel;
	import view.panel.WarnnigTipPanel;
	
	public class FormulaRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var itemSpec:FormulaItemSpec;
		public function FormulaRender()
		{
			super();
			scale = Configrations.ViewScale;
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		private var container:Sprite;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				itemSpec = FormulaItemSpec(value);
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				
				configLayout();
			}
		}
		private function onAddToStage(e:Event):void
		{
			if(itemSpec){
				configRequest();
				checkButton();
				refreshCount();
			}
		}
		private var addBut:Button;
		private var renderwidth:Number;
		private var renderheight:Number;
		private var countText:TextField;
		private function configLayout():void
		{
			renderwidth = width;
			renderheight = height;
			isComanding= false;
			container = new Sprite;
			addChild(container);
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(20, 20, 20, 20));
			var panelSkin:Scale9Image = new Scale9Image(skinTexture);
			panelSkin.width = renderwidth;
			panelSkin.height = renderheight;
			container.addChild(panelSkin);
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderheight*0.1,itemSpec.cname,0x000000,25,true);
			container.addChild(nameText);
			
			countText = FieldController.createSingleLineDynamicField(renderwidth ,renderheight*0.1,"("+")",0x000000,25,true);
			countText.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(countText);
			countText.y = renderheight*0.1;
			
			configRequest();
			
			var arrowIcon :Image = new Image(Game.assets.getTexture("rightArrowIcon"));
			arrowIcon.width = arrowIcon.height = renderheight*0.1;
			arrowIcon.rotation = deg2rad(90);
			container.addChild(arrowIcon);
			arrowIcon.x = renderwidth/2 ;
			arrowIcon.y = requestContainer.y + requestContainer.height + 5*scale;
			
			
			var timeicon:Image = new Image(Game.assets.getTexture("skillTimeIcon"));
			timeicon.width = timeicon.height = renderheight*0.1;
			container.addChild(timeicon);
			timeicon.y = arrowIcon.y;
			timeicon.x =  renderwidth/2 ;
			
			var timeText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderheight*0.1,SystemDate.getSTimeLeftString(itemSpec.workTime),0x00ff00,20,true);
			timeText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(timeText);
			timeText.y = arrowIcon.y;
			timeText.x = timeicon.x + timeicon.width + 5*scale;
			
			var rewardC:Sprite = configReward();
			container.addChild(rewardC);
			rewardC.x = renderwidth*0.2;
			rewardC.y = arrowIcon.y + arrowIcon.height + 5*scale;
			
			addBut = new Button();
			addBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			addBut.label = LanguageController.getInstance().getString("creat");
			addBut.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			addBut.paddingLeft =addBut.paddingRight =  20;
			addBut.paddingTop =addBut.paddingBottom =  10;
			container.addChild(addBut);
			addBut.validate();
			addBut.x = renderwidth/2 - addBut.width/2;
			addBut.y = renderheight - addBut.height;
			addBut.addEventListener(Event.TRIGGERED,onClick);
			checkButton();
			refreshCount();
		}
		private function checkButton():void
		{
			if(isOwned){
				addBut.label = LanguageController.getInstance().getString("creat");
				if(canFinish >=1){
					addBut.filter = null;
					addBut.touchable = true;
				}else{
					var grayscaleFilter:ColorMatrixFilter = new ColorMatrixFilter();
					grayscaleFilter.adjustSaturation(-1);
					addBut.filter = grayscaleFilter;
					addBut.touchable = false;
				}
			}else{
				addBut.label = LanguageController.getInstance().getString("unlock");
			}
			addBut.validate();
			addBut.x = renderwidth/2 - addBut.width/2;
		}
		private var canFinish:int ;
		private var requestContainer:Sprite;
		private function configRequest():void
		{
			if(requestContainer && requestContainer.parent){
				requestContainer.parent.removeChild(requestContainer);
			}
			canFinish = -1;
			requestContainer = new Sprite;
			var backgroundSkinTextures:Scale9Textures =  new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			var skin:Scale9Image = new Scale9Image(backgroundSkinTextures);
			requestContainer.addChild(skin);
			skin.width = renderwidth *.6;
			
			var requestS:String = itemSpec.material;
			var requestArr:Array = requestS.split("|");
			var reqSpec:ItemSpec;
			var requestId:String ;
			var requestNum:String ;
			var deepth:Number =0;
			var iconText:TextField;
			var icon:PackageIcon;
			var ownedItem:OwnedItem;
			var expandBut :Button;
			for each(var str:String in requestArr){
				requestId = str.split(":")[0];
				requestNum = str.split(":")[1];
				reqSpec =SpecController.instance.getItemSpec(requestId);
				ownedItem = player.getOwnedItem(requestId);
				
				icon = new PackageIcon(reqSpec);
				requestContainer.addChild(icon);
				icon.width = icon.height =renderheight*0.1;
				icon.y = deepth;
				icon.x = renderwidth *.3 - icon.width - 5*scale;
				
				var color:uint = 0x000000;
				var i:int =int(ownedItem.count/int(requestNum));
				if(i==0){
					color = 0xff0000;
				}
				if(canFinish == -1){
					canFinish = i;
				}else{
					canFinish = Math.min(canFinish,i);
				}
				iconText = FieldController.createSingleLineDynamicField(200,renderheight*0.1,"×"+requestNum,color,25,true);
				iconText.autoSize = TextFieldAutoSize.HORIZONTAL;
				requestContainer.addChild(iconText);
				iconText.x = renderwidth *.3 + 5*scale;
				iconText.y = deepth;
				if(i==0 && isFormula(requestId)){
					expandBut = new Button();
					expandBut.defaultSkin = new Image(Game.assets.getTexture("addIcon"));
					requestContainer.addChild(expandBut);
					expandBut.name = requestId;
					expandBut.addEventListener(Event.TRIGGERED,onAddTrigger);
					expandBut.width = expandBut.height = icon.height*0.8;
					expandBut.x = renderwidth*0.6 - expandBut.width/2;
					expandBut.y = deepth+icon.height*0.1;
				}
				deepth += icon.height+5*scale;
			}
			
			skin.height=deepth+5*scale;
			countText.text = "("+canFinish+")";
			container.addChild(requestContainer);
			requestContainer.x = renderwidth*0.2;
			requestContainer.y = countText.y+countText.height + 5*scale;
		}
		
		private function get isOwned():Boolean
		{
			if(itemSpec.type == "special"){
				if(player.ownedFormulas){
					var formulasArr:Array = player.ownedFormulas.split(":");
					for each(var id:String in formulasArr){
						if((int(id)+72000) == int(itemSpec.item_id)){
							return true;
						}
					}
				}
			}else{
				return true;
			}
			return false;
		}
		private function isFormula(id:String):Boolean
		{
			var goupe:Object = SpecController.instance.getGroup("Formula");
			var spec:FormulaItemSpec;
			for each(spec in goupe){
				var proId:String = spec.product.split(":")[0];
				if(id == proId){
					return true;
				}
			}
			return false;
		}
		private function configReward():Sprite
		{
			var rewardContainer:Sprite = new Sprite;
			
			var backgroundSkinTextures:Scale9Textures =  new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			var skin:Scale9Image = new Scale9Image(backgroundSkinTextures);
			rewardContainer.addChild(skin);
			skin.width = renderwidth *.6;
			
			var rewardS:String = itemSpec.product;
			var rewardArr:Array = rewardS.split("|");
			var rewardSpec:ItemSpec;
			var rewardId:String ;
			var rewardNum:String ;
			var deepth:Number = 5*scale;
			var iconText:TextField;
			var icon:Sprite;
			for each(var str:String in rewardArr){
				rewardId = str.split(":")[0];
				rewardNum = str.split(":")[1];
				rewardSpec =SpecController.instance.getItemSpec(rewardId);
				
				icon = new PackageIcon(rewardSpec);
				rewardContainer.addChild(icon);
				icon.width = icon.height =renderheight*0.1;
				icon.y = deepth;
				icon.x = renderwidth *.3 - icon.width - 5*scale;
				
				iconText = FieldController.createSingleLineDynamicField(200,renderheight*0.1,"×"+rewardNum,0x000000,25,true);
				iconText.autoSize = TextFieldAutoSize.HORIZONTAL;
				rewardContainer.addChild(iconText);
				iconText.x = renderwidth *.3 + 5*scale;
				iconText.y = deepth;
				
				deepth += icon.height+5*scale;
			}
			
			skin.height=deepth+5*scale;
			
			return rewardContainer;
		}
		private var openFormulaPanel:OpenFormulaPanel;
		private var isComanding:Boolean = false;
		private function onClick(e:Event):void{
			VoiceController.instance.playSound(VoiceController.SOUND_BUTTON);
			if(isOwned){
				if(!isComanding){
					if(canAdd){
						player.addWorkingFormula(itemSpec.item_id);
						new AddFormulaCommand(itemSpec.item_id,onADDHandle);
						isComanding = true;
					}else{
						DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningFacFull")));
					}
				}
			}else{
				if(!openFormulaPanel){
					openFormulaPanel = new OpenFormulaPanel(itemSpec);
				}
				openFormulaPanel.addEventListener(Event.CLOSE,onOpenFormulaClosed);
				DialogController.instance.showPanel(openFormulaPanel);
			}
		}
		private function onOpenFormulaClosed(e:Event):void
		{
			openFormulaPanel.removeEventListener(Event.CLOSE,onOpenFormulaClosed);
			checkButton();
		}
		private function onADDHandle():void
		{
			var requestS:String = itemSpec.material;
			var requestArr:Array = requestS.split("|");
			var requestId:String ;
			var requestNum:int ;
			var ownedItem:OwnedItem;
			for each(var str:String in requestArr){
				requestId = str.split(":")[0];
				requestNum = str.split(":")[1];
				player.deleteItem(new OwnedItem(requestId,requestNum));
			}
				
			DialogController.instance.factoryPanel.refreshWorkingList(true);
			configRequest();
			checkButton();
			refreshCount();
			isComanding = false;
		}
		
		private function refreshCount():void
		{
			countText.text = "("+canFinish+")";
		}
		private function onAddTrigger(e:Event):void
		{
			if(e.target is Button){
				DialogController.instance.showFacPanel((e.target as Button).name);
			}
		}
		private function get canAdd():Boolean
		{
			var listC:ListCollection = new ListCollection();
			var length:int = Configrations.Factory_Tile + player.factory_expand;
			
			var index:int = 0;
			var array:Array  = [];
			var formulas:Array = [];
			if(player.formulas){
				formulas = player.formulas.split(":");
			}
			return formulas.length < length;
		}
			
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		
	}
}

