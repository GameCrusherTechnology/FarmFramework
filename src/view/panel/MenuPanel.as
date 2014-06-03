package view.panel
{
	
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.TiledRowsLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	
	import view.render.MenuListRender;
	import view.render.PanelListRender;

	public class MenuPanel extends Sprite
	{
		private var _list:List;
		private var _pageIndicator:PageIndicator;
		private var renderWidth:Number =  80;
		private var renderHeight:Number = 80;
		private var panelSkin:Shape;
		private var panelList:List;
		private var bgImage:Image;
		private var _listRenderNum:int;
		private var titleText:TextField;
		public function MenuPanel()
		{
			var texture:Texture; 
			texture = Game.assets.getTexture("simplePanelSkin");
			bgImage = new Image(texture);
			bgImage.width = Configrations.ViewPortWidth;
			bgImage.height= Configrations.ViewPortHeight;
			addChild(bgImage);
			bgImage.alpha = 0;
			bgImage.addEventListener( TouchEvent.TOUCH,onBackSkinTouch);
			var skintextures:Scale9Textures = new Scale9Textures(texture, new Rectangle(20, 20,10, 10));
			var backSkin:Scale9Image = new Scale9Image(skintextures);
			backSkin.width = Configrations.ViewPortWidth *.9;
			backSkin.height= Configrations.ViewPortHeight *.94;
			addChild(backSkin);
			backSkin.x = Configrations.ViewPortWidth *.05;
			backSkin.y = Configrations.ViewPortHeight *.06;
			
			var titleSkin:Image = new Image(Game.assets.getTexture("titleSkin"));
			addChild(titleSkin);
			titleSkin.width = Configrations.ViewPortWidth *.4;
			titleSkin.scaleY = titleSkin.scaleX;
			titleSkin.x = Configrations.ViewPortWidth/2 - titleSkin.width/2;
			titleSkin.y = Configrations.ViewPortHeight *.05;
			
			titleText = FieldController.createSingleLineDynamicField(titleSkin.width,titleSkin.height,LanguageController.getInstance().getString("profile"),0x000000,35,true);
			addChild(titleText);
			titleText.autoSize = TextFieldAutoSize.VERTICAL;
			titleText.x = titleSkin.x;
			titleText.y = titleSkin.y +titleSkin.height/2 -  titleText.height;
			
			
			var cancelButton:Button = new Button();
			cancelButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			cancelButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			addChild(cancelButton);
			cancelButton.width = cancelButton.height = Configrations.ViewPortHeight*0.05;
			cancelButton.x = Configrations.ViewPortWidth *0.95 -cancelButton.width -5;
			cancelButton.y = Configrations.ViewPortHeight *.06 +5;
			
			renderWidth = Configrations.ViewPortWidth*0.12;
			renderHeight = Configrations.ViewPortHeight *.1;
//			renderWidth = renderHeight = Math.min(Configrations.ViewPortHeight *.15,200);
			
			
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
			panelList.y = Configrations.ViewPortHeight*0.12;
			panelList.addEventListener(Event.SCROLL, panellist_scrollHandler);
			
			panelSkin = new Shape;
			panelSkin.graphics.beginFill(0xffffff,1);
			panelSkin.graphics.drawRect(0,0,panelList.width,panelList.height);
			panelSkin.graphics.endFill();
			
			
			
			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
//			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
//			listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.manageVisibility = true;
			listLayout.horizontalGap = 4;
			listLayout.verticalGap = Configrations.ViewPortHeight*0.01;
			
			
			this._list = new List();
			this._list.layout = listLayout;
			skintextures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			_list.backgroundSkin = new Scale9Image(skintextures);
			this._list.dataProvider = menuArr;
			this._list.width = Configrations.ViewPortWidth*0.86;
			this._list.height = Configrations.ViewPortHeight *0.15;
			this._list.snapToPages = true;
//			this._list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
//			this._list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			this._list.itemRendererFactory = tileListItemRendererFactory;
			this.addChild(this._list);
			_list.x = Configrations.ViewPortWidth/2 - _list.width/2;
			_list.y = Configrations.ViewPortHeight*0.98 - _list.height;
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
		
		private function list_changeHandler(e:Event):void
		{
			if(_list && _list.selectedItem){
				var eventType:String = this._list.selectedItem.event as String;
				titleText.text = LanguageController.getInstance().getString(eventType);
				this.panelList.scrollToPageIndex(_list.selectedIndex, 0, this.panelList.pageThrowDuration);
			}
		}
		protected function pageIndicator_changeHandler(event:Event):void
		{
			this._list.scrollToPageIndex(this._pageIndicator.selectedIndex, 0, this._list.pageThrowDuration);
		}
		private function panellist_scrollHandler(e:Event):void
		{
			this._list.selectedIndex = this.panelList.horizontalPageIndex;
			this._list.scrollToPageIndex(Math.floor((_list.selectedIndex)/_listRenderNum), 0, this._list.pageThrowDuration);
//			this._pageIndicator.selectedIndex = this._list.horizontalPageIndex;
		}
		protected function list_scrollHandler(event:Event):void
		{
			this._pageIndicator.selectedIndex = this._list.horizontalPageIndex;
		}
		protected function panelListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new PanelListRender();
			renderer.defaultSkin = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			renderer.width = Configrations.ViewPortWidth*0.86;
			renderer.height = Configrations.ViewPortHeight *.68;
//			renderer.isQuickHitAreaEnabled = true;
			return renderer;
		}
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new MenuListRender();
			var buttxtures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20));
			renderer.defaultSelectedSkin = new Scale9Image(buttxtures) ;
			buttxtures = new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(20, 20, 20, 20));
			renderer.defaultSkin = new Scale9Image(buttxtures) ;
			renderer.width = renderWidth;
			renderer.height= renderHeight;
			return renderer;
		}
		
		private function getPanelCollection():ListCollection
		{
			return new ListCollection([{name:"profile"},
				{name:"skill"},
				{name:"package"},
				{name:"social"},
				{name:"achieve"},
				{name:"setting"}]);
		}
		private function get menuArr():ListCollection
		{
			return new ListCollection([
				{event:"profile"},
				{event:"skill"},
				{event:"package"},
				{event:"social"},
				{event:"achieve"},
				{event:"setting"}
			]);
		}
		protected function layout():void
		{
			this._list.validate();
			_listRenderNum = _list.pageWidth / (renderWidth+Configrations.ViewPortWidth*0.01);
			this._pageIndicator.y = _list.y + _list.height;
			this._pageIndicator.pageCount = this._list.horizontalPageCount;
			this._pageIndicator.validate();
			if(_pageIndicator.pageCount ==1){
				_pageIndicator.visible = false;
			}else{
				_pageIndicator.visible = true;
			}
		}
		
		private function onBackSkinTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(bgImage,TouchPhase.BEGAN);
			if(touch){
				close();
			}
		}
		private function closeButton_triggeredHandler(e:Event):void
		{
			close();
		}
		private function close():void
		{
			_list.removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			this._list.removeEventListener(Event.CHANGE, list_changeHandler);
			this._list.removeEventListener(Event.SCROLL, list_scrollHandler);
			_list.dispose();
			panelList.dispose();
			this._pageIndicator.removeEventListener(Event.CHANGE, pageIndicator_changeHandler);
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}