package view.panel
{
	
	import flash.geom.Rectangle;
	
	import controller.TextFieldFactory;
	import controller.UiController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import view.render.MenuListRender;
	import view.render.PanelListRender;

	public class MenuPanel extends Sprite
	{
		private var _list:List;
		private var _pageIndicator:PageIndicator;
		private var renderWidth:Number =  80 ;
		private var renderHeight:Number = 80;
		private var panelSkin:Shape;
		private var panelList:List;
		public function MenuPanel()
		{
			var texture:Texture; 
			texture = Game.assets.getTexture("simplePanelSkin");
			var bgImage:Image = new Image(texture);
			bgImage.width = Configrations.ViewPortWidth;
			bgImage.height= Configrations.ViewPortHeight;
			addChild(bgImage);
			bgImage.alpha = 0;
			
			var skintextures:Scale9Textures = new Scale9Textures(texture, new Rectangle(20, 20,10, 10));
			var backSkin:Scale9Image = new Scale9Image(skintextures);
			backSkin.width = Configrations.ViewPortWidth *.9;
			backSkin.height= Configrations.ViewPortHeight *.9;
			addChild(backSkin);
			backSkin.x = Configrations.ViewPortWidth *.05;
			backSkin.y = Configrations.ViewPortHeight *.05;
			
			renderWidth = Math.max(Configrations.ViewPortWidth *.15,80);
			renderHeight = Math.max(Configrations.ViewPortHeight *.1,80);
			
			
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
			panelList.dataProvider = getPanelCollection("profile");
			panelList.width = Configrations.ViewPortWidth;
			panelList.height = Configrations.ViewPortHeight *.7;
			panelList.snapToPages = true;
			panelList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			panelList.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			panelList.itemRendererFactory = panelListItemRendererFactory;
			this.addChild(panelList);
			panelList.y = Configrations.ViewPortHeight*0.1;
			panelList.addEventListener(Event.SCROLL, panellist_scrollHandler);
			
			panelSkin = new Shape;
			panelSkin.graphics.beginFill(0xffffff,1);
			panelSkin.graphics.drawRect(0,0,panelList.width,panelList.height);
			panelSkin.graphics.endFill();
			
			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.manageVisibility = true;
			listLayout.horizontalGap = Configrations.ViewPortWidth*0.01;
			listLayout.verticalGap = Configrations.ViewPortHeight*0.01;
			
			
			this._list = new List();
			skintextures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			_list.backgroundSkin = new Scale9Image(skintextures);
			this._list.dataProvider = menuArr;
			this._list.layout = listLayout;
			this._list.width = Configrations.ViewPortWidth*0.86;
			this._list.height = Configrations.ViewPortHeight *.12;
			this._list.snapToPages = true;
//			this._list.clipContent = false;
			this._list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			this._list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			this._list.itemRendererFactory = tileListItemRendererFactory;
			this.addChild(this._list);
			_list.x = Configrations.ViewPortWidth*0.07;
			_list.y = Configrations.ViewPortHeight*0.9 - _list.height;
			this._list.addEventListener(Event.SCROLL, list_scrollHandler);
			
			const normalSymbolTexture:Texture   = Game.assets.getTexture("PanelRenderSkin");
			const selectedSymbolTexture:Texture = Game.assets.getTexture("PanelBackSkin");
			this._pageIndicator = new PageIndicator();
			this._pageIndicator.normalSymbolFactory = function():Image
			{
				var ig:Image = new Image(normalSymbolTexture);
				ig.width = ig.height = 10;
				return ig;
			}
			this._pageIndicator.selectedSymbolFactory = function():Image
			{
				var ig:Image =  new Image(selectedSymbolTexture);
				ig.width = ig.height = 10;
				return ig;
			}
			this._pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
			this._pageIndicator.pageCount = 1;
			this._pageIndicator.gap = 3;
			this._pageIndicator.paddingTop = this._pageIndicator.paddingRight = this._pageIndicator.paddingBottom =
			this._pageIndicator.paddingLeft = 6;
			this._pageIndicator.width = _list.width;
			this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
			this.addChild(this._pageIndicator);
			_list.addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			this._list.addEventListener(Event.CHANGE, list_changeHandler);

		}
		protected function addedToStageHandler(event:Event):void
		{
			this.layout();
		}
		
		private function selectTab(index:int):void
		{
			_list.selectedIndex 
		}
		private function list_changeHandler(e:Event):void
		{
			const eventType:String = this._list.selectedItem.event as String;
			trace(eventType);
		}
		protected function pageIndicator_changeHandler(event:Event):void
		{
			this._list.scrollToPageIndex(this._pageIndicator.selectedIndex, 0, this._list.pageThrowDuration);
		}
		private function panellist_scrollHandler(e:Event):void
		{
			
		}
		protected function list_scrollHandler(event:Event):void
		{
			this._pageIndicator.selectedIndex = this._list.horizontalPageIndex;
		}
		protected function panelListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new PanelListRender();
			renderer.defaultSkin = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));;
			renderer.width = Configrations.ViewPortWidth*0.86;
			renderer.height = Configrations.ViewPortHeight *.65;
			renderer.isQuickHitAreaEnabled = true;
			return renderer;
		}
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new MenuListRender();
			renderer.defaultSkin = new Image(Game.assets.getTexture("PanelRenderSkin"));
			renderer.labelField = "label";
			renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(TextFieldFactory.FONT_FAMILY, 20, 0x000000);
			renderer.iconSourceField = "texture";
			renderer.iconPosition = Button.ICON_POSITION_TOP;
			renderer.width = renderWidth;
			renderer.height= renderHeight;
			renderer.isQuickHitAreaEnabled = true;
			return renderer;
		}
		
		private function getPanelCollection(name:String):ListCollection
		{
			return new ListCollection([{name:name}]);
		}
		private function get menuArr():ListCollection
		{
			return new ListCollection([
				{ label: LanguageController.getInstance().getString("profile"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_HARVEST,event:"profile"},
				{ label: LanguageController.getInstance().getString("skill"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_SEED,event:"skill"},
				{ label: LanguageController.getInstance().getString("social"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_HARVEST,event:"social"},
				{ label: LanguageController.getInstance().getString("achieve"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_SEED,event:"achieve"},
				{ label: LanguageController.getInstance().getString("rating"), texture: "reapIcon",type:UiController.TOOL_HARVEST,event:"rating"},
				{ label: LanguageController.getInstance().getString("setting"), texture: "FarmPlow",type:UiController.TOOL_SEED,event:"setting"}

			]);
		}
		protected function layout():void
		{
			
			this._list.validate();
			this._pageIndicator.y = _list.y + _list.height;
			this._pageIndicator.pageCount = this._list.horizontalPageCount;
			this._pageIndicator.validate();
			if(_pageIndicator.pageCount ==1){
				_pageIndicator.visible = false;
			}else{
				_pageIndicator.visible = true;
			}
		}
		
		private function close():void
		{
			
			_list.removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			this._list.removeEventListener(Event.CHANGE, list_changeHandler);
			this._list.removeEventListener(Event.SCROLL, list_scrollHandler);
			this._pageIndicator.removeEventListener(Event.CHANGE, pageIndicator_changeHandler);
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}