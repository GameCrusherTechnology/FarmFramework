package view.render
{
	import controller.SpecController;
	
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.ItemSpec;
	import model.gameSpec.PetSpec;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.filters.BlurFilter;

	public class PetMenuPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var panelList:List;
		private var tabList:List;
		private var petsArr:Array=[];
		public function PetMenuPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.86;
			panelheight = Configrations.ViewPortHeight*0.68;
			scale = Configrations.ViewScale;
			
			var group:Object = SpecController.instance.getGroup("Pet");
			for each(var spec:PetSpec in group)
			{
				petsArr.push(spec);
			}
			
			var listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.manageVisibility = true;
			listLayout.horizontalGap = 4;
			listLayout.verticalGap = Configrations.ViewPortHeight*0.01;
			
			
			tabList = new List();
			tabList.layout = listLayout;
			tabList.dataProvider =getPanelCollection();
			tabList.width = panelwidth*0.1 - 10*scale;
			tabList.height = 500*scale;
			
			tabList.itemRendererFactory = tileListItemRendererFactory;
			this.addChild(tabList);
			tabList.x = 5*scale;
			tabList.y = 10*scale;
			tabList.addEventListener(Event.CHANGE, list_changeHandler);
			
			
			const listLayout1:TiledRowsLayout = new TiledRowsLayout();
			listLayout1.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout1.useSquareTiles = false;
			listLayout1.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout1.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			listLayout1.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout1.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout1.manageVisibility = true;
			
			panelList = new List();
			panelList.layout = listLayout1;
			panelList.dataProvider = getPanelCollection();
			panelList.width = panelwidth - tabList.x - tabList.width-10*scale;
			panelList.height = Configrations.ViewPortHeight *.6;
			panelList.snapToPages = true;
			panelList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			panelList.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			panelList.itemRendererFactory = panelListItemRendererFactory;
			this.addChild(panelList);
			panelList.y = 20*scale;
			panelList.x = tabList.x + tabList.width + 10*scale;
			panelList.addEventListener(Event.SCROLL, panellist_scrollHandler);
			
			configList();
		}
		private function getPanelCollection():ListCollection
		{
			return new ListCollection(petsArr);
		}
		private function panellist_scrollHandler(e:Event):void
		{
			tabList.selectedIndex = panelList.horizontalPageIndex;
		}
		
		private var currentSelectSpec:ItemSpec;
		private function list_changeHandler(event:Event):void
		{
			if(tabList && tabList.selectedItem){
				currentSelectSpec =tabList.selectedItem as ItemSpec;
			}
			configList();
		}
		private function configList():void
		{
			if(currentSelectSpec){
				var index:int = petsArr.indexOf(currentSelectSpec);
				if(index>=0){
					tabList.selectedIndex = index;
					panelList.scrollToPageIndex(index, 0, panelList.pageThrowDuration);
				}
			}else{
				tabList.selectedIndex = 0;
				panelList.scrollToPageIndex(0, 0, panelList.pageThrowDuration);
			}
		}
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new PetTabRender();
			var toolSkin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			toolSkin.filter = BlurFilter.createGlow(0x0000CC,1,3);
			renderer.defaultSelectedSkin = toolSkin;
			renderer.defaultSkin = new Image(Game.assets.getTexture("toolsStateSkin"));
			renderer.width = renderer.height = panelwidth*0.1 - 10*scale;
			return renderer;
		}
		protected function panelListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new PetPanelRender();
			renderer.width = Configrations.ViewPortWidth*0.75;
			renderer.height = Configrations.ViewPortHeight *.6;
			return renderer;
		}
	}
}