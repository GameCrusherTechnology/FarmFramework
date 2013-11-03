package view.ui
{
	import controller.TextFieldFactory;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	
	import gameconfig.Configrations;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import view.render.ToolItemRender;

	public class ToolsList extends Sprite
	{
		
		private var _list:List;
		private var _pageIndicator:PageIndicator;
		private var _iconAtlas:AssetManager = Game.assets;
		private var renderWidth:int = 80*Configrations.ViewScale;
		private var renderHeight:int= 100*Configrations.ViewScale;
		public function ToolsList()
		{
			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.manageVisibility = true;
			
			this._list = new List();
			this._list.maxWidth = Configrations.ViewPortWidth/4;
			_list.backgroundSkin = new Image(_iconAtlas.getTexture("PanelBackSkin"));
			this._list.dataProvider = collection;
			this._list.layout = listLayout;
			this._list.snapToPages = true;
			this._list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			this._list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			this._list.itemRendererFactory = tileListItemRendererFactory;
			this._list.addEventListener(Event.SCROLL, list_scrollHandler);
			this._list.addEventListener(Event.CHANGE,onChange);
			this.addChild(this._list);
			
			const normalSymbolTexture:Texture   = _iconAtlas.getTexture("PanelRenderSkin");
			const selectedSymbolTexture:Texture = _iconAtlas.getTexture("PanelBackSkin");
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
			this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
			this.addChild(this._pageIndicator);
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
		}
		
		public function show():void
		{
			this._list.dataProvider = collection;
			if(stage){
				layout();
			}
		}
		private function onChange(e:Event):void
		{
			trace("click");
		}
		public function hide():void
		{
//			this.flatten();
		}
		private const collection:ListCollection = new ListCollection(
			[
				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
//				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
//				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
//				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
//				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
//				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
//				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
//				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
//				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
//				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
//				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
//				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") },
				{ label: "测试", texture: _iconAtlas.getTexture("FarmPlow") }
				
			]);
		protected function addedToStageHandler(event:Event):void
		{
			this.layout();
		}
		
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new ToolItemRender();
			renderer.defaultSkin = new Image(_iconAtlas.getTexture("PanelRenderSkin"));
			renderer.labelField = "label";
			renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(TextFieldFactory.FONT_FAMILY, 20, 0x000000);
			renderer.iconSourceField = "texture";
			renderer.iconPosition = Button.ICON_POSITION_TOP;
			renderer.width = renderWidth;
			renderer.height= renderHeight;
			return renderer;
		}
		
		protected function list_scrollHandler(event:Event):void
		{
			this._pageIndicator.selectedIndex = this._list.horizontalPageIndex;
		}
		
		protected function pageIndicator_changeHandler(event:Event):void
		{
			this._list.scrollToPageIndex(this._pageIndicator.selectedIndex, 0, this._list.pageThrowDuration);
		}
		
		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			this.layout();
		}
		protected function layout():void
		{
			this._pageIndicator.width = this.stage.stageWidth;
			this._pageIndicator.validate();
			this._pageIndicator.y = this.stage.stageHeight - this._pageIndicator.height;
			const layout:TiledRowsLayout = TiledRowsLayout(this._list.layout);
			this._list.itemRendererProperties.gap = layout.gap = layout.paddingTop = layout.paddingBottom = 10*Configrations.ViewScale;
			layout.paddingRight = layout.paddingLeft = 20*Configrations.ViewScale;
			
			
			this._list.width = Math.min(Configrations.ViewPortWidth*0.8,_list.dataProvider.length * 80+100);
			this._list.height = renderHeight  + 20*Configrations.ViewScale;
			this._list.x = Configrations.ViewPortWidth/2- _list.width/2;
			this._list.y = Configrations.ViewPortHeight - _list.height -20;
			this._list.validate();
			
			this._pageIndicator.pageCount = this._list.horizontalPageCount;
			if(_pageIndicator.pageCount ==1){
				_pageIndicator.visible = false;
			}else{
				_pageIndicator.visible = true;
			}
		}

	}
}