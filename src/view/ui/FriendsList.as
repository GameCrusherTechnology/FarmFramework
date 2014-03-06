package view.ui
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.TabBar;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	import model.player.SimplePlayer;
	
	import service.command.friend.GetStrangersCommand;
	
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
		private var currentTabIndex:int;
		
		private var container:Sprite;
		private var maxWidth:Number;
		public function FriendsList()
		{
			container = new Sprite();
			addChild(container);
		}
		
		public function show(w:Number):void
		{
			maxWidth = w;
			if(player.isFriend(currentplayer.gameuid)){
				currentTabIndex  = 0;
			}else if(GameController.instance.isHomeModel){
				currentTabIndex  = 0;
			}else{
				currentTabIndex  = 1;
			}
			configTabBar();
			configList();
			checkState();
			layout();
		}
		private var tabBar:TabBar;
		private function configTabBar():void
		{
			if(!_list){
				tabBar = new TabBar();
				var tabList:ListCollection = new ListCollection(
					[
						{ label: LanguageController.getInstance().getString("friend")},
						{ label: LanguageController.getInstance().getString("stranger")}
					]);
				tabBar.dataProvider = tabList;
				tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
				tabBar.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
				tabBar.gap = 10*Configrations.ViewScale;
				tabBar.tabFactory = function():Button
				{
					var tab:Button = new Button();
					tab.defaultSelectedSkin = new Image(Game.assets.getTexture("greenButtonSkin")) ;
					tab.defaultSkin = new Image(Game.assets.getTexture("cancelButtonSkin")) ;
					tab.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
					tab.paddingLeft = tab.paddingRight = 20;
					tab.paddingTop = tab.paddingBottom = 5;
					return tab;
				}
			}
			container.addChild(this.tabBar);
			tabBar.validate();
			tabBar.height = 50 *Configrations.ViewScale;
			tabBar.x = 0;
			tabBar.y = 0;
		}
		private var _list:List;
		private var _pageIndicator:PageIndicator;
		private function configList():void
		{
			if(!_list){
				const listLayout:TiledRowsLayout = new TiledRowsLayout();
				listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
				listLayout.useSquareTiles = false;
				listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
				listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
				listLayout.manageVisibility = true;
				
				this._list = new List();
				var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
				this._list.backgroundSkin = new Scale9Image(skintextures);
				
				this._list.dataProvider = getFriendList();
				this._list.layout = listLayout;
				this._list.snapToPages = true;
				this._list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
				this._list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
				this._list.itemRendererFactory = tileListItemRendererFactory;
				this._list.addEventListener(Event.SCROLL, list_scrollHandler);
				this._list.addEventListener(Event.CHANGE,onChange);
				_list.selectedItem = GameController.instance.currentPlayer.gameuid;
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
//				this._list.dataProvider = collection;
				if(!_list.parent){
					container.addChild(this._list);
				}
				if(!_pageIndicator.parent){
					container.addChild(this._pageIndicator);
				}
			}
		}

		private function checkState():void
		{
			tabBar.selectedIndex = currentTabIndex;
			var list:ListCollection = getFriendList();
			_list.dataProvider = list;
			_list.validate();
			var index:int = list.getItemIndex(currentplayer.gameuid);
			if(index>=0){
				_list.selectedIndex = index;
				_list.scrollToDisplayIndex(index);
			}else{
				
			}
		}
		
		protected function layout():void
		{
			if(_list && _list.parent){
				const layout:TiledRowsLayout = TiledRowsLayout(this._list.layout);
				this._list.itemRendererProperties.gap = layout.gap = layout.paddingTop = layout.paddingBottom = 10*Configrations.ViewScale;
				layout.paddingRight = layout.paddingLeft = 20*Configrations.ViewScale;
				
				this._list.width = Math.max(maxWidth/2,Math.min(maxWidth,6 * (renderWidth+10)+100));
				this._list.height = renderHeight ;
				this._pageIndicator.width = _list.width;
				this._pageIndicator.height = 10;
				this._list.validate();
				_list.y = tabBar.height;
				
				this._pageIndicator.y = _list.y + _list.height + 5;
				this._pageIndicator.pageCount = this._list.horizontalPageCount;
				this._pageIndicator.validate();
				if(_pageIndicator.pageCount ==1){
					_pageIndicator.visible = false;
				}else{
					_pageIndicator.visible = true;
				}
			}
			container.x = 0;
			container.y = -container.height;
		}
		
		private function tabBar_changeHandler(event:Event):void
		{
			if(tabBar.selectedIndex != currentTabIndex){
				currentTabIndex = tabBar.selectedIndex;
				checkState();
			}
		}
		
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new FriendListRender();
			renderer.defaultSkin = new Image(Game.assets.getTexture("PanelRenderSkin"));
			renderer.defaultSelectedSkin = new Image(Game.assets.getTexture("iconBlueBackSkin"));
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
			if(_list.selectedItem){
				var selectUid:String = String(_list.selectedItem);
				
				if(selectUid ){
					if(selectUid == "refresh"){
						new GetStrangersCommand(checkState);
					}else if(selectUid != GameController.instance.currentPlayer.gameuid){
						GameController.instance.visitFriend(selectUid);
					}
				}
			}
		}
		
		private function getFriendList():ListCollection
		{
			var list:ListCollection ;
			if(currentTabIndex == 0){
				var arr:Array = ["1","2"].concat(player.friends);
				list = new ListCollection(arr);
			}else{
				list =  new ListCollection();
				for each(var simp:SimplePlayer in player.strangers){
					list.push(simp.gameuid);
				}
				list.push('refresh');
			}
			return list;
		}
		private function get currentplayer():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
	}
}