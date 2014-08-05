package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.ItemSpec;
	import model.gameSpec.PetSpec;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	
	import view.render.PetPanelRender;
	import view.render.PetTabRender;

	public class PetInfoPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var panelList:List;
		private var tabList:List;
		private var petsArr:Array=[];
		public function PetInfoPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			scale = Configrations.ViewScale;
			var group:Object = SpecController.instance.getGroup("Pet");
			for each(var spec:PetSpec in group)
			{
				petsArr.push(spec);
			}
			
			var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			var bsSkin:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(bsSkin);
			bsSkin.width = panelwidth;
			bsSkin.height = panelheight;
			bsSkin.alpha = 0.3;
			
			var skin1:Scale9Image = new Scale9Image(backgroundSkinTextures);
			addChild(skin1);
			skin1.width = panelwidth *.8;
			skin1.height =panelheight*.8;
			skin1.x = panelwidth/2 - skin1.width/2;
			skin1.y = panelheight/2 - skin1.height/2;
			
			
			
			
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
			panelList.width = Configrations.ViewPortWidth;
			panelList.height = Configrations.ViewPortHeight *.7;
			panelList.snapToPages = true;
			panelList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			panelList.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			panelList.itemRendererFactory = panelListItemRendererFactory;
			this.addChild(panelList);
			panelList.y = Configrations.ViewPortHeight*0.15;
			panelList.addEventListener(Event.SCROLL, panellist_scrollHandler);
			
			
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
			tabList.dataProvider = getPanelCollection();
			tabList.width = panelwidth;
			tabList.height = 100*scale;
			tabList.itemRendererFactory = tileListItemRendererFactory;
			this.addChild(tabList);
			tabList.x = panelwidth*0.1;
			tabList.y = Configrations.ViewPortHeight*0.15 - tabList.height/2 ;
			tabList.addEventListener(Event.CHANGE, list_changeHandler);
			
			
			var cancelButton:Button = new Button();
			cancelButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			cancelButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			addChild(cancelButton);
			cancelButton.width = cancelButton.height = 50*scale;
			cancelButton.x = panelwidth*0.9 -cancelButton.width -5;
			cancelButton.y = panelheight*0.1 +5;
			
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
			renderer.width = renderer.height = 100*scale;
			return renderer;
		}
		protected function panelListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new PetPanelRender();
			renderer.defaultSkin = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			renderer.width = Configrations.ViewPortWidth*0.75;
			renderer.height = Configrations.ViewPortHeight *.7;
			return renderer;
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
			return GameController.instance.currentPlayer;
		}
	}
}