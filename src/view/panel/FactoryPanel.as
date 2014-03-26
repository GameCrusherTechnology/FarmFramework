package view.panel
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	import controller.VoiceController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.ScrollBar;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.SystemDate;
	
	import model.OwnedItem;
	import model.gameSpec.FormulaItemSpec;
	import model.gameSpec.ItemSpec;
	import model.player.GamePlayer;
	
	import service.command.factory.HarvestFacCommand;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	
	import view.TweenEffectLayer;
	import view.component.PackageIcon;
	import view.render.FormulaRender;
	import view.render.WorkingRender;

	public class FactoryPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		public function FactoryPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			scale = Configrations.ViewScale;
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"),new Rectangle(20,20,24,24));
			var panelSkin:Scale9Image = new Scale9Image(skinTexture);
			panelSkin.width = panelwidth;
			panelSkin.height = panelheight;
			addChild(panelSkin);
			
			configWorkingList();
//			configSpeedContainer();
			configFormulasList();
			configTabBar();
			var cancelButton:Button = new Button();
			cancelButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			cancelButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			addChild(cancelButton);
			cancelButton.width = cancelButton.height = panelheight*0.05;
			cancelButton.x = Configrations.ViewPortWidth*0.99 -cancelButton.width ;
			cancelButton.y = Configrations.ViewPortHeight*0.01 ;
		}
		public function refresh():void
		{
			refreshWorkingList();
			refreshFormulaList();
			refreshHarvestButEnable();
		}
		
		private function configSpeedContainer():void
		{
			var container:Sprite = new Sprite();
			addChild(container);
			var skin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(skin);
			skin.width = panelwidth*0.2;
			skin.height= panelheight*0.3;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.2,panelheight*0.1,"working speed",0x000000,30,true);
			container.addChild(nameText);
			
			var speedText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.2,panelheight*0.05,"100%",0x000000,30);
			container.addChild(speedText);
			speedText.y = nameText.y + nameText.height;
			
			var speedTimeText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.2,panelheight*0.05,"00:00:00",0x000000,30);
			container.addChild(speedTimeText);
			speedTimeText.y = speedText.y + speedText.height;
			
			var speedBut:Button = new Button();
			speedBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			speedBut.label = LanguageController.getInstance().getString("add");
			speedBut.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			speedBut.paddingLeft =speedBut.paddingRight =  20;
			speedBut.paddingTop =speedBut.paddingBottom =  5;
			container.addChild(speedBut);
			speedBut.validate();
			speedBut.x = panelwidth*0.1 - speedBut.width/2;
			speedBut.y = speedTimeText.y + speedTimeText.height + 10*scale ;
			
			container.x = panelwidth*0.75;
			container.y = panelheight*0.05;
		}
		private var workingList:List;
		private var harvestBut:Button;
		private var expandText:TextField;
		private var expandBut:Button;
		private function configWorkingList():void
		{
			var container:Sprite = new Sprite();
			addChild(container);
			var skin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(skin);
			skin.width = panelwidth*0.9;
			skin.height= panelheight*0.3;
			
			var titleSkin:Image = new Image(Game.assets.getTexture("titleSkin"));
			container.addChild(titleSkin);
			titleSkin.width = panelwidth *.4;
			titleSkin.height = panelheight *0.1;
			titleSkin.x = panelwidth*0.3;
			titleSkin.y = - panelheight*0.05;
			
			var titleText:TextField = FieldController.createSingleLineDynamicField(titleSkin.width,titleSkin.height,LanguageController.getInstance().getString("mill"),0x000000,35,true);
			container.addChild(titleText);
			titleText.autoSize = TextFieldAutoSize.VERTICAL;
			titleText.x = titleSkin.x;
			titleText.y = titleSkin.y +titleSkin.height/2 -  titleText.height;
			
			var workingText:TextField = FieldController.createSingleLineDynamicField(400,panelheight*0.05,LanguageController.getInstance().getString("workingList"),0x000000,30,true);
			workingText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(workingText);
			workingText.x = panelwidth*0.02;
			
			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.manageVisibility = true;
			listLayout.horizontalGap = panelwidth *0.01;
			
			workingList = new List();
			workingList.layout = listLayout;
			workingList.dataProvider = getWorkingList();
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("talkSkin"), new Rectangle(1, 1, 62, 62));
			workingList.backgroundSkin = new Scale9Image(skintextures);
			workingList.itemRendererFactory =function tileListItemRendererFactory():WorkingRender
			{
				var renderer:WorkingRender = new WorkingRender();
				renderer.width = renderer.height =panelheight*0.15;
				return renderer;
			}
			workingList.horizontalScrollBarFactory = function():ScrollBar
			{
				var scrollBar:ScrollBar = new ScrollBar();
				scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_MIN_MAX;
				scrollBar.thumbFactory = function():Button
				{
					var button:Button = new Button();
					//skin the thumb here
					var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("okButtonSkin"),new Rectangle(20,10,60,30));
					button.defaultSkin = new Scale9Image(skinTexture);
					button.height = panelheight*0.05;
					return button;
				}
				return scrollBar;
			}
			workingList.width =  panelwidth*0.84;
			workingList.height =  panelheight *0.15;
			container.addChild(workingList);
			workingList.x = panelwidth*0.02;
			workingList.y = panelheight*0.06;
			
			var expandNameText:TextField = FieldController.createSingleLineDynamicField(400,panelheight*0.05,LanguageController.getInstance().getString("queueLen")+" : ",0x000000,30,true);
			expandNameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(expandNameText);
			expandNameText.x = panelwidth*0.02;
			expandNameText.y = panelheight*0.23;
			
			expandText = FieldController.createSingleLineDynamicField(400,panelheight*0.05," ",0x000000,30,true);
			expandText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(expandText);
			expandText.x = expandNameText.x + expandNameText.width+5*scale;
			expandText.y = panelheight*0.23;
			
			expandBut = new Button();
			expandBut.defaultSkin = new Image(Game.assets.getTexture("addIcon"));
			container.addChild(expandBut);
			expandBut.addEventListener(Event.TRIGGERED,onExpandTrigger);
			expandBut.width = expandBut.height = panelheight*0.05;
			refreshExpand();
			
			harvestBut = new Button();
			harvestBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			harvestBut.label = LanguageController.getInstance().getString("harvest");
			harvestBut.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			harvestBut.paddingLeft =harvestBut.paddingRight =  20;
			harvestBut.height = panelheight*0.05;
			container.addChild(harvestBut);
			harvestBut.validate();
			harvestBut.x = panelwidth*0.88 - harvestBut.width;
			harvestBut.y = panelheight*0.23;
			harvestBut.addEventListener(Event.TRIGGERED,onHarvestHandle);
			refreshHarvestButEnable();
			
			container.x = panelwidth*0.05;
			container.y = panelheight*0.05;
		}
		private var formulasList:List;
		private function configFormulasList():void
		{
			var container:Sprite = new Sprite();
			addChild(container);
			var skin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(1, 1, 62, 62)));
			container.addChild(skin);
			skin.width = panelwidth*0.9;
			skin.height= panelheight*0.55;
			
			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.manageVisibility = true;
			listLayout.horizontalGap = panelwidth *0.05;
			
			formulasList = new List();
			formulasList.layout = listLayout;
			
			formulasList.horizontalScrollBarFactory = function():ScrollBar
			{
				var scrollBar:ScrollBar = new ScrollBar();
				scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_MIN_MAX;
				scrollBar.thumbFactory = function():Button
				{
					var button:Button = new Button();
					//skin the thumb here
					var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelTitleBoard"),new Rectangle(20,10,60,30));
					button.defaultSkin = new Scale9Image(skinTexture);
					button.height = panelheight*0.05;
					return button;
				}
				return scrollBar;
			}
			formulasList.dataProvider = getFomulasList();
			formulasList.itemRendererFactory =function tileListItemRendererFactory():FormulaRender
			{
				var renderer:FormulaRender = new FormulaRender();
				renderer.width = panelwidth *0.25;
				renderer.height =panelheight*0.5;
				return renderer;
			}
			formulasList.width =  panelwidth*0.86;
			formulasList.height =  panelheight *0.51;
			container.addChild(formulasList);
			formulasList.x = panelwidth*0.02;
			formulasList.y = panelheight*0.02;
			
			container.x = panelwidth*0.05;
			container.y = panelheight*0.35;
		}
		private var tabBar:TabBar;
		private function configTabBar():void
		{
			tabBar = new TabBar();
			var tabList:ListCollection = new ListCollection(
				[
					{ label: LanguageController.getInstance().getString("package")},
					{ label: LanguageController.getInstance().getString("special")},
					{ label: LanguageController.getInstance().getString("enough")}
				]);
			tabBar.dataProvider = tabList;
			tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			tabBar.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			tabBar.tabFactory = function():Button
			{
				var tab:Button = new Button();
				var buttxtures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20));
				tab.defaultSelectedSkin = new Scale9Image(buttxtures) ;
				buttxtures = new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(20, 20, 20, 20));
				tab.defaultSkin = new Scale9Image(buttxtures) ;
				tab.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
				return tab;
			}
			addChild(this.tabBar);
			tabBar.width = panelwidth*0.9;
			tabBar.height = panelheight*0.08;
			tabBar.x = panelwidth*0.05;
			tabBar.y = panelheight*0.92;
		}
		
		public function refreshWorkingList(isLast:Boolean=false):void
		{
			workingList.dataProvider = getWorkingList();
			workingList.validate();
			
			refreshExpand();
			
			if(isLast){
				var count:int;
				if(player.formulas){
					var i:int = workingList.horizontalScrollStep;
					var formulas:Array = player.formulas.split(":");
					count = formulas.length;
				}
				workingList.scrollToDisplayIndex(count-1);
			}
		}
		
		public function refreshFormulaList():void
		{
			formulasList.dataProvider = new ListCollection([]);
			formulasList.dataProvider = getFomulasList();
			formulasList.validate();
		}
		
		public function refreshExpand():void
		{
			var listLength:int = player.factory_expand + Configrations.Factory_Tile;
			expandText.text = String(listLength);
			
			if(Configrations.getFacTotalTile() <= listLength){
				if(expandBut.parent){
					expandBut.parent.removeChild(expandBut);
				}
			}else{
				expandBut.x = expandText.x +expandText.width + 10*scale;
				expandBut.y = expandText.y ;
			}
		}
		public function refreshHarvestButEnable():void
		{
			var hasFinished:Boolean = false;
			var startIndex:int = player.workTimeIndex;
			if(player.formulas){
				if(startIndex >0){
					hasFinished = true;
				}else{
					var formulasArr:Array = player.formulas.split(":");
					var id:String;
					var formulaSpec:FormulaItemSpec;
					var formulaTime:Number = player.workTime;
					id = formulasArr[startIndex];
					formulaSpec = SpecController.instance.getItemSpec(id) as FormulaItemSpec;
					formulaTime += formulaSpec.workTime;
					if(formulaTime <= SystemDate.systemTimeS){
						hasFinished = true;
					}
				}
			}
			if(hasFinished){
				harvestBut.filter = null;
				harvestBut.touchable = true;
			}else{
				var grayscaleFilter:ColorMatrixFilter = new ColorMatrixFilter();
				grayscaleFilter.adjustSaturation(-1);
				harvestBut.filter = grayscaleFilter;
				harvestBut.touchable = false;
			}
		}
		private function onExpandTrigger():void
		{
			DialogController.instance.showPanel(new ExpandFactoryPanel());
		}
		
		private var currentTabIndex:int;
		private function tabBar_changeHandler(event:Event):void
		{
			formulasList.stopScrolling();
			if(tabBar.selectedIndex != currentTabIndex){
				currentTabIndex = tabBar.selectedIndex;
				refreshFormulaList();
				
				formulasList.scrollToPageIndex(0, 0, formulasList.pageThrowDuration);
			}
		}
		private var isHarvesting:Boolean  = false;
		private function onHarvestHandle(e:Event):void
		{
			if(!isHarvesting){
				VoiceController.instance.playSound(VoiceController.SOUND_BUTTON);
				new HarvestFacCommand(onHarvestBack);
				isHarvesting = true;
			}
		}
		private function onHarvestBack(addItems:Object,addExp:int):void
		{
			showHarvestAnimation(addItems,addExp);
			refresh();
			isHarvesting = false;
		}
		private function getWorkingList():ListCollection
		{
			var listC:ListCollection = new ListCollection();
			var length:int = Configrations.Factory_Tile + player.factory_expand;
			var index:int = 0;
			
			var array:Array  = [];
			var formulas:Array = [];
			if(player.formulas){
				formulas = player.formulas.split(":");
			}
			while (index<length){
				if(formulas[index]){
					listC.push({index:index,id:formulas[index]});
				}else{
					listC.push({index:index,id:"null"});
				}
				index ++;
			}
			return listC;
		}
		private function getFomulasList():ListCollection
		{
			var goupe:Object = SpecController.instance.getGroup("Formula");
			var spec:FormulaItemSpec;
			var array:Array = [];
			var speArr:Array = [];
			var canArr:Array = [];
			for each(spec in goupe){
				if(spec.type == "special"){
					speArr.push(spec);
				}else{
					array.push(spec);
				}
				if(checkItemCanFinish(spec)){
					canArr.push(spec);
				}
			}
			
			array.sortOn("item_id",Array.NUMERIC);
			speArr.sortOn("item_id",Array.NUMERIC);
			canArr.sortOn("item_id",Array.NUMERIC);
			if(currentTabIndex == 0){
				return new ListCollection(array);
			}else if(currentTabIndex == 1){
				return new ListCollection(speArr);
			}else{
				return new ListCollection(canArr);
			}
		}
		
		private function checkItemCanFinish(itemSpec:FormulaItemSpec):Boolean
		{
			var canFinish:Boolean = true;
			var requestS:String = itemSpec.material;
			var requestArr:Array = requestS.split("|");
			var reqSpec:ItemSpec;
			var requestId:String ;
			var requestNum:String ;
			var ownedItem:OwnedItem;
			for each(var str:String in requestArr){
				requestId = str.split(":")[0];
				requestNum = str.split(":")[1];
				reqSpec =SpecController.instance.getItemSpec(requestId);
				ownedItem = player.getOwnedItem(requestId);
				
				if(ownedItem.count < int(requestNum)){
					canFinish = false;
				}
			}
			return canFinish;
			
		}
		
		private function showHarvestAnimation(addItems:Object,addExp:int):void
		{
			var texture:Texture;
			var count:int;
			var index:int = 0;
			var stagePoint:Point ;
			var spec:ItemSpec;
			if(addItems){
				for each(var obj:Object in addItems){
					index = 0;
					count = obj.count;
					spec = SpecController.instance.getItemSpec(obj.id);
					if(spec){
						while(index <count){
							stagePoint = new Point(panelwidth*0.05 + Math.random()*panelwidth*0.9,panelheight*0.2 + Math.random()*panelheight*0.1);
							stageEffectLayer.addTweenFacItem(new PackageIcon(spec),stagePoint,0.1*index);
							index++;
						}
					}
				}
			}
			
			index = 0;
			count = addExp;
			if(spec){
				while(index <count){
					stagePoint = new Point(panelwidth*0.05 + Math.random()*panelwidth*0.9,panelheight*0.1 + Math.random()*panelheight*0.15);
					stageEffectLayer.addTweenFacItem(new Image(Game.assets.getTexture("expIcon")),stagePoint,0.1*index);
					index++;
				}
			}
		}
		
		private function closeButton_triggeredHandler(e:Event):void
		{
			destroy();
		}
		private function destroy():void
		{
			if(parent){
				parent.removeChild(this);
			}
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		protected function get stageEffectLayer():TweenEffectLayer
		{
			return GameController.instance.effectLayer;
		}
	}
}