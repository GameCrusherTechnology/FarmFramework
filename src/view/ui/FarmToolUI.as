package view.ui
{
	
	import flash.geom.Rectangle;
	
	import controller.SpecController;
	import controller.FieldController;
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
	
	import model.gameSpec.CropSpec;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.textures.Texture;
	
	import view.entity.GameEntity;
	import view.render.FarmToolsRender;
	import view.render.ToolItemRender;

	public class FarmToolUI extends Sprite
	{
		private var renderWidth:int = 80*Configrations.ViewScale;
		private var renderHeight:int= 100*Configrations.ViewScale;
		private var renderGap:Number = 20;
		private const collection:Array = 
			[
				{ label: LanguageController.getInstance().getString("harvest"), texture: "reapIcon",type:UiController.TOOL_HARVEST},
				{ label: LanguageController.getInstance().getString("seed"), texture: "FarmPlow",type:UiController.TOOL_SEED},
				{ label: LanguageController.getInstance().getString("speed"), texture: "FarmPlow",type:UiController.TOOL_SPEED}
			];
		
		public function FarmToolUI() 
		{
			
		}
		
		public function show(type:String,entity:GameEntity=null):void
		{
			destroy();
			if(type == UiController.TOOL_SEED){
				configList(getSeedCollection());
			}else{
				var data:Object;
				var render:FarmToolsRender;
				var leftPoint:Number = 0;
				var renderArr:Array = toolsObject[type];
				for each(data in renderArr){
					render = new FarmToolsRender(data);
					addChild(render);
					render.x = leftPoint;
					leftPoint +=(render.width + renderGap);
				}
			}
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
				this.addChild(this._list);
				
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
				this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
				this.addChild(this._pageIndicator);
			}else{
				this._list.dataProvider = collection;
				this.addChild(this._list);
				this.addChild(this._pageIndicator);
			}
			layout();
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
		}
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new ToolItemRender();
			renderer.defaultSkin = new Image(Game.assets.getTexture("PanelRenderSkin"));
			renderer.labelField = "label";
			renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
			renderer.iconSourceField = "texture";
			renderer.iconPosition = Button.ICON_POSITION_TOP;
			renderer.width = renderWidth;
			renderer.height= renderHeight;
			return renderer;
		}
		private var toolsObject:Object = {
			"harvest" :[collection[0]],
			"seed":[collection[1]],
			"speed":[collection[2]]
		};
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
		
		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			this.layout();
		}
		private function getSeedCollection():ListCollection
		{ 
			var cropSpecArr:Object = SpecController.instance.getGroup("Crop");
			var list:ListCollection = new ListCollection;
			var spec:CropSpec ;
			var specObj:Object;
			for each(spec in cropSpecArr){
				list.push({label :spec.name,texture:Game.assets.getTexture(spec.name+"Icon"),type:UiController.TOOL_SEED,id:spec.id});
			}
			return list;
		}
		protected function layout():void
		{
			const layout:TiledRowsLayout = TiledRowsLayout(this._list.layout);
			this._list.itemRendererProperties.gap = layout.gap = layout.paddingTop = layout.paddingBottom = 10*Configrations.ViewScale;
			layout.paddingRight = layout.paddingLeft = 20*Configrations.ViewScale;
			
			
			this._list.width = Math.min(Configrations.ViewPortWidth*0.8,_list.dataProvider.length * 80+100);
			this._list.height = renderHeight  + 20*Configrations.ViewScale;
			this._pageIndicator.width = _list.width;
			this._list.validate();
			
			this._pageIndicator.y = _list.height + 10;
			this._pageIndicator.pageCount = this._list.horizontalPageCount;
			this._pageIndicator.validate();
			if(_pageIndicator.pageCount ==1){
				_pageIndicator.visible = false;
			}else{
				_pageIndicator.visible = true;
			}
		}
		private function destroy():void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			
			if(_list && _list.parent){
				_list.parent.removeChild(_list);
			}
			if(_pageIndicator && _pageIndicator.parent){
				_pageIndicator.parent.removeChild(_pageIndicator);
			}
			
			var displayObj:DisplayObject;
			while(numChildren>0){
				displayObj = getChildAt(0);
				if(displayObj is FarmToolsRender){
					(displayObj as FarmToolsRender).destroy();
				}
				removeChild(displayObj);
			}
		}
	}
}