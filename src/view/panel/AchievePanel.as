package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.ItemSpec;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.render.AchieveListRender;
	import view.render.AchieveTabListRender;

	public class AchievePanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var list:List;
		private var tabList:List;
		private var currentTab:String = "crop";
		private var scale:Number;
		public function AchievePanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.86;
			panelheight = Configrations.ViewPortHeight*0.68;
			scale = Configrations.ViewScale;

			
			const listLayout: VerticalLayout= new VerticalLayout();
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.scrollPositionVerticalAlign  = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.paddingTop =listLayout.paddingBottom =  30*scale;
			listLayout.gap = 10*scale;
			
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20));
			var backG:Scale9Image = new Scale9Image(skintextures);
			this.addChild(backG);
			backG.width =  panelwidth*0.8;
			backG.height = panelheight *0.95 ;
			backG.x = panelwidth*0.1;
			backG.y =  10*scale;
			
			list = new List();
			list.layout = listLayout;
			list.width =  panelwidth*0.8;
			list.height = panelheight *0.95 -20*scale;
			list.itemRendererFactory = 
				function tileListItemRendererFactory():AchieveListRender
			{
				const renderer:AchieveListRender = new AchieveListRender()
				renderer.width = panelwidth *0.7;
				renderer.height = Math.min(panelheight *0.2,100);
				return renderer;
			};
			list.verticalScrollPolicy = SCROLL_POLICY_ON;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			this.addChild(list);
			list.x = panelwidth*0.1;
			list.y = 20*scale;
			
			var achIcon:Image = new Image(Game.assets.getTexture("achieveIcon"));
			achIcon.width = achIcon.height = 80*scale;
			addChild(achIcon);
			achIcon.x =  achIcon.y = 0;
			
			var totalP:int = Configrations.getTotalAchievePoint(GameController.instance.currentPlayer.achieve);
			var countText:TextField = FieldController.createSingleLineDynamicField(300,300,"×"+totalP,0x000000,25,true);
			countText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			addChild(countText);
			countText.x = achIcon.x + achIcon.width - countText.width/2;
			countText.y = achIcon.y + achIcon.height - countText.height;
			
			var listLayout1:TiledRowsLayout = new TiledRowsLayout();
			listLayout1.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout1.useSquareTiles = false;
			listLayout1.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout1.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout1.manageVisibility = true;
			listLayout1.horizontalGap = 4;
			listLayout1.verticalGap = Configrations.ViewPortHeight*0.01;
			
			
			tabList = new List();
			tabList.layout = listLayout1;
			tabList.dataProvider = new ListCollection([{name:"crop"},{name:"tree"},{name:"animal"}]);
			tabList.width = panelwidth*0.1 - 10*scale;
			tabList.height = 500*scale;
			
			tabList.itemRendererFactory = tileListItemRendererFactory;
			this.addChild(tabList);
			tabList.x = 5*scale;
			tabList.y = achIcon.y + achIcon.height+10*scale;
			tabList.addEventListener(Event.CHANGE, list_changeHandler);
			
			configList();
		}
		private function list_changeHandler(event:Event):void
		{
			if(tabList && tabList.selectedItem){
				currentTab =tabList.selectedItem.name as String;
			}
			configList();
		}
		private function configList():void
		{
			if(currentTab == "crop"){
				tabList.selectedIndex = 0;
				list.dataProvider = getMenuArr(0);
			}else if(currentTab == "tree"){
				tabList.selectedIndex =1;
				list.dataProvider = getMenuArr(1);
			}else{
				tabList.selectedIndex = 2;
				list.dataProvider = getMenuArr(2);
			}
		}
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new AchieveTabListRender();
			var toolSkin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			toolSkin.filter = BlurFilter.createGlow(0x66ff33);
			renderer.defaultSelectedSkin = toolSkin;
			renderer.defaultSkin = new Image(Game.assets.getTexture("toolsStateSkin"));
			renderer.width = renderer.height = panelwidth*0.1 - 10*scale;
			return renderer;
		}
		
		private function getMenuArr(index:int):ListCollection
		{
			var goupe:Object = SpecController.instance.getGroup("AchieveItem");
			var spec:ItemSpec;
			var croparray:Array = [];
			var treearray:Array = [];
			var animalarray:Array = [];
			for each(spec in goupe){
				if(spec.type == "Crop"){
					croparray.push({item_id:spec.item_id});
				}else if(spec.type == "Tree"){
					treearray.push({item_id:spec.item_id});
				}else{
					animalarray.push({item_id:spec.item_id});
				}
			}
			croparray.sortOn("item_id",Array.NUMERIC);
			treearray.sortOn("item_id",Array.NUMERIC);
			animalarray.sortOn("item_id",Array.NUMERIC);
			var menuArr:Array = [croparray,treearray,animalarray];
			return new ListCollection(menuArr[index]);
		}
	}
}