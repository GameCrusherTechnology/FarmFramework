package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
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
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.OwnedItem;
	import model.gameSpec.AchieveItemSpec;
	import model.gameSpec.ItemSpec;
	import model.player.GamePlayer;
	import model.player.PlayerChangeEvents;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	
	import view.render.PackageListRender;
	
	public class PackagePanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var renderWidth:Number ;
		private var renderHeight:Number ;
		private var _list:List;
		
		public function PackagePanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.86;
			panelheight = Configrations.ViewPortHeight*0.68;
			var scale:Number = Configrations.ViewScale;
			renderWidth =  100*scale;
			renderHeight = 120*scale;
			
			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_VERTICAL;
			listLayout.tileVerticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			listLayout.useSquareTiles = false;
			listLayout.horizontalGap = 10*scale;
			listLayout.verticalGap = 20*scale;
			listLayout.paddingTop = 30*scale;
			
			
			this._list = new List();
			this._list.layout = listLayout;
			this._list.dataProvider = menuArr;
			this._list.width = panelwidth*0.96;
			this._list.height = panelheight*0.96;
			this._list.snapToPages = true;
			this._list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FIXED;
			this._list.horizontalScrollPolicy = List.SCROLL_POLICY_OFF;
			this._list.verticalScrollPolicy = List.SCROLL_POLICY_ON;
			this._list.itemRendererFactory = tileListItemRendererFactory;
			this.addChild(this._list);
			_list.x = panelwidth*0.02;_list.y = panelheight*0.02;
			this._list.addEventListener(Event.CHANGE, list_changeHandler);
			player.addEventListener(PlayerChangeEvents.ITEM_CHANGE,onItemChanged);
		}
		private function onItemChanged(e:Event):void
		{
			var page:int = _list.verticalPageIndex;
			this._list.dataProvider = menuArr;
			this._list.validate();
			this._list.scrollToPageIndex(_list.horizontalPageIndex,page);
		}
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new PackageListRender();
			var buttxtures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20));
			renderer.defaultSkin = new Scale9Image(buttxtures) ;
			
			renderer.defaultSelectedSkin = new Image(Game.assets.getTexture("iconBlueBackSkin")) ;
			renderer.width = renderWidth;
			renderer.height= renderHeight;
			return renderer;
		}
		
		
		private function list_changeHandler(e:Event):void
		{
			if(_list && _list.selectedItem is OwnedItem){
				var spec:ItemSpec = SpecController.instance.getItemSpec((_list.selectedItem as OwnedItem).itemid);
				if(spec.coinPrice>0){
					var panel:SellItemPanel = new SellItemPanel(spec.item_id);
					DialogController.instance.showPanel(panel);
				}
			}
		}
		private function get menuArr():ListCollection
		{
			var spec:ItemSpec;
			var item:OwnedItem;
			var list:ListCollection = new ListCollection;
			var ownedItems:Vector.<OwnedItem> = player.ownedItemVec;
			for each(item in ownedItems){
				spec = SpecController.instance.getItemSpec(item.itemid);
				if(item.count > 0 && spec && !(spec is AchieveItemSpec)){
					list.push(item);
				}
			}
			return list;
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		
		override public function dispose():void
		{
			player.removeEventListener(PlayerChangeEvents.ITEM_CHANGE,onItemChanged);
			super.dispose();
		}
	}
}
