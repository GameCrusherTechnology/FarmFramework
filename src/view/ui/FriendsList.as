package view.ui
{
	import flash.geom.Rectangle;
	
	import controller.GameController;
	
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.TiledRowsLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.player.GamePlayer;
	import model.player.SimplePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import view.render.FriendListRender;

	public class FriendsList extends Sprite
	{
		private var renderWidth:int = 100*Configrations.ViewScale;
		private var renderHeight:int= 120*Configrations.ViewScale;
		private var renderGap:Number = 20;
		private var container:Sprite;
		
		public function FriendsList()
		{
			container = new Sprite();
			addChild(container);
		}
		
		public function show():void
		{
			configList(getFriendList());
		}
		private var _list:List;
		private var _pageIndicator:PageIndicator;
		private function configList(collection:ListCollection):void
		{
			if(!_list){
				const listLayout:TiledRowsLayout = new TiledRowsLayout();
				listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
				listLayout.useSquareTiles = false;
				listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
				listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
				listLayout.manageVisibility = true;
				
				this._list = new List();
				this._list.maxWidth = Configrations.ViewPortWidth/4;
				var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
				this._list.backgroundSkin = new Scale9Image(skintextures);
				
				this._list.dataProvider = collection;
				this._list.layout = listLayout;
				this._list.snapToPages = true;
				this._list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
				this._list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
				this._list.itemRendererFactory = tileListItemRendererFactory;
				this._list.addEventListener(Event.SCROLL, list_scrollHandler);
				this._list.addEventListener(Event.CHANGE,onChange);
				container.addChild(this._list);
				
				const normalSymbolTexture:Texture   = Game.assets.getTexture("pageoff");
				const selectedSymbolTexture:Texture = Game.assets.getTexture("pageon");
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
				this._pageIndicator.gap = 10;
				this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
				container.addChild(this._pageIndicator);
			}else{
				this._list.dataProvider = collection;
				container.addChild(this._list);
				container.addChild(this._pageIndicator);
			}
			layout();
		}

		protected function layout():void
		{
			if(_list && _list.parent){
				const layout:TiledRowsLayout = TiledRowsLayout(this._list.layout);
				this._list.itemRendererProperties.gap = layout.gap = layout.paddingTop = layout.paddingBottom = 10*Configrations.ViewScale;
				layout.paddingRight = layout.paddingLeft = 20*Configrations.ViewScale;
				
				
				this._list.width = Math.min(Configrations.ViewPortWidth*0.8,_list.dataProvider.length * 80+100);
				this._list.height = renderHeight ;
				this._pageIndicator.width = _list.width;
				this._list.validate();
				
				this._pageIndicator.y = _list.height + 5;
				this._pageIndicator.pageCount = this._list.horizontalPageCount;
				this._pageIndicator.validate();
				if(_pageIndicator.pageCount ==1){
					_pageIndicator.visible = false;
				}else{
					_pageIndicator.visible = true;
				}
			}
			container.x = -container.width/2;
			container.y = -container.height;
		}
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new FriendListRender();
			renderer.defaultSkin = new Image(Game.assets.getTexture("PanelRenderSkin"));
			//			renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 10, 0x000000);
			renderer.width = renderWidth;
			renderer.height= renderHeight-20*Configrations.ViewScale;
			return renderer;
		}
		
		protected function list_scrollHandler(event:Event):void
		{
			this._pageIndicator.selectedIndex = this._list.horizontalPageIndex;
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			this.layout();
		}
		
		protected function pageIndicator_changeHandler(event:Event):void
		{
			this._list.scrollToPageIndex(this._pageIndicator.selectedIndex, 0, this._list.pageThrowDuration);
		}
		
		private function onChange(e:Event):void
		{
			var selectPlayer:SimplePlayer = _list.selectedItem as SimplePlayer;
			if(selectPlayer && selectPlayer.gameuid != GameController.instance.currentPlayer.gameuid){
				GameController.instance.visitFriend(selectPlayer.gameuid);
			}
		}
		
		private function getFriendList():ListCollection
		{
			return new ListCollection(player.friends);
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
	}
}