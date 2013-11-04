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
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import view.render.MenuListRender;
	import view.render.ToolItemRender;

	public class MenuPanel extends Sprite
	{
		private var _list:List;
		private var _pageIndicator:PageIndicator;
		private var renderWidth:Number =  80 ;
		private var renderHeight:Number = 80;
		
		public function MenuPanel()
		{
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			var backSkin:Scale9Image = new Scale9Image(skintextures);
			backSkin.alpha = 0.5;
			backSkin.width = Configrations.ViewPortWidth;
			backSkin.height= Configrations.ViewPortHeight;
			addChild(backSkin);
			
			renderWidth = Configrations.ViewPortWidth *.2;
			renderHeight = Configrations.ViewPortHeight *.3;
			
			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.manageVisibility = true;
			listLayout.horizontalGap = Configrations.ViewPortWidth*0.02;
			listLayout.verticalGap = Configrations.ViewPortHeight*0.02;
			
			this._list = new List();
			_list.backgroundSkin = new Scale9Image(skintextures);
			this._list.dataProvider = menuArr;
			this._list.layout = listLayout;
			this._list.width = Configrations.ViewPortWidth*0.8;
			this._list.height = Configrations.ViewPortHeight*0.8;
			this._list.snapToPages = true;
			this._list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			this._list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			this._list.itemRendererFactory = tileListItemRendererFactory;
			this.addChild(this._list);
			_list.x = Configrations.ViewPortWidth*0.1;
			_list.y = Configrations.ViewPortHeight*0.1;
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
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			layout();

		}
		protected function addedToStageHandler(event:Event):void
		{
			this.layout();
		}
		protected function pageIndicator_changeHandler(event:Event):void
		{
			this._list.scrollToPageIndex(this._pageIndicator.selectedIndex, 0, this._list.pageThrowDuration);
		}
		protected function list_scrollHandler(event:Event):void
		{
			this._pageIndicator.selectedIndex = this._list.horizontalPageIndex;
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
			return renderer;
		}
		private function get menuArr():ListCollection
		{
			return new ListCollection([
				{ label: LanguageController.getInstance().getString("profile"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_HARVEST},
				{ label: LanguageController.getInstance().getString("skill"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_SEED},
				{ label: LanguageController.getInstance().getString("social"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_HARVEST},
				{ label: LanguageController.getInstance().getString("achieve"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_SEED},
				{ label: LanguageController.getInstance().getString("rating"), texture: "reapIcon",type:UiController.TOOL_HARVEST},
				{ label: LanguageController.getInstance().getString("setting"), texture: "FarmPlow",type:UiController.TOOL_SEED},
				{ label: LanguageController.getInstance().getString("harvest"), texture: "reapIcon",type:UiController.TOOL_HARVEST},
				{ label: LanguageController.getInstance().getString("seed"), texture: "FarmPlow",type:UiController.TOOL_SEED},
				{ label: LanguageController.getInstance().getString("speed"), texture: "FarmPlow",type:UiController.TOOL_SPEED}

			]);
		}
		protected function layout():void
		{
			this._pageIndicator.y = _list.height + 10;
			this._pageIndicator.pageCount = this._list.horizontalPageCount;
			this._pageIndicator.validate();
			if(_pageIndicator.pageCount ==1){
				_pageIndicator.visible = false;
			}else{
				_pageIndicator.visible = true;
			}
			
		}
	}
}