package view.ui
{
	
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	import controller.UiController;
	
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
	import gameconfig.SystemDate;
	
	import model.entity.CropItem;
	import model.gameSpec.CropSpec;
	import model.player.GamePlayer;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	
	import view.entity.GameEntity;
	import view.render.FarmToolsRender;
	import view.render.ToolItemRender;

	public class FarmToolUI extends Sprite
	{
		private var renderWidth:int = 120*Configrations.ViewScale;
		private var renderHeight:int= 140*Configrations.ViewScale;
		private var renderGap:Number = 20*Configrations.ViewScale;
		private var container:Sprite;
		private const collection:Array = 
			[
				{ label: LanguageController.getInstance().getString("harvest"), texture: "reapIcon",type:UiController.TOOL_HARVEST},
				{ label: LanguageController.getInstance().getString("seed"), texture: "fertilizeIcon",type:UiController.TOOL_SEED},
				{ label: LanguageController.getInstance().getString("speed"), texture: "fertilizeIcon",type:UiController.TOOL_SPEED},
				{ label: LanguageController.getInstance().getString("searching"), texture: "excavateIcon",type:UiController.TOOL_EXCAVATE},
				{ label: LanguageController.getInstance().getString("info"), texture: "RanchInfoIcon",type:UiController.TOOL_RANCH_INFO},
				{ label: LanguageController.getInstance().getString("cancel"), texture: "WarningIcon",type:UiController.TOOL_CANCEL}
			];
		
		public function FarmToolUI() 
		{
			container = new Sprite();
			addChild(container);
		}
		private var leftTimeText:TextField;
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
					render = new FarmToolsRender(data,entity);
					container.addChild(render);
					render.x = leftPoint;
					leftPoint +=(renderWidth + renderGap);
				}
				if(type == UiController.TOOL_SPEED && entity){
					
					var leftTime:String = SystemDate.getTimeLeftString((entity.item as CropItem).remainTime);
					leftTimeText = FieldController.createSingleLineDynamicField(Configrations.ViewPortWidth,35*Configrations.ViewScale,leftTime,0x000000,25,true);
					leftTimeText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					container.addChild(leftTimeText);
					leftTimeText.x = renderWidth/2 - leftTimeText.width/2;
					leftTimeText.y =  - leftTimeText.height-5*Configrations.ViewScale;
					
					var nameText:TextField = FieldController.createSingleLineDynamicField(Configrations.ViewPortWidth,35*Configrations.ViewScale,entity.item.cname,0x000000,30,true);
					nameText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					container.addChild(nameText);
					nameText.x = 	renderWidth/2 - nameText.width/2;
					nameText.y =  leftTimeText.y- nameText.height - 5*Configrations.ViewScale;
					
				}
				
				container.x = -( leftPoint-renderGap)/2;
				container.y = -renderHeight;
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
				this._list.maxWidth = Configrations.ViewPortWidth/4*3;
				var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
				this._list.backgroundSkin = new Scale9Image(skintextures);
				
				this._list.dataProvider = collection;
				this._list.layout = listLayout;
				this._list.snapToPages = true;
				this._list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
				this._list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
				this._list.itemRendererFactory = tileListItemRendererFactory;
				this._list.addEventListener(Event.SCROLL, list_scrollHandler);
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
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
		}
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new ToolItemRender();
			renderer.defaultSkin = new Image(Game.assets.getTexture("PanelRenderSkin"));
//			renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 10, 0x000000);
			renderer.width = renderWidth;
			renderer.height= renderHeight-20*Configrations.ViewScale;
			return renderer;
		}
		private var toolsObject:Object = {
			"harvest" :[collection[0]],
			"seed":[collection[1]],
			"speed":[collection[2]],
			"excavate":[collection[3]],
			"ranchinfo":[collection[4]],
			"cancel":[collection[5]]
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
			var lastSpec:CropSpec;
			var player:GamePlayer = GameController.instance.localPlayer;
			var playerLv:int = player.level;
			for each(spec in cropSpecArr){
				if(spec.isTree){
					if(player.hasItem(spec.item_id)){
						list.addItemAt({label :spec.cname,texture:Game.assets.getTexture(spec.name+"Icon"),type:UiController.TOOL_SEED,id:spec.item_id},0);
					}
				}else{
					if(spec.level > playerLv){
						if(lastSpec){
							if(lastSpec.level>spec.level){
								lastSpec = spec;
							}
						}else{
							lastSpec = spec;
						}
					}else{
						list.push({label :spec.cname,texture:Game.assets.getTexture(spec.name+"Icon"),type:UiController.TOOL_SEED,id:spec.item_id});
					}
				}
			}
			if(lastSpec){
				list.push({label :lastSpec.cname,texture:Game.assets.getTexture(lastSpec.name+"Icon"),type:UiController.TOOL_SEED,id:lastSpec.item_id});
			}
			return list;
		}
		protected function layout():void
		{
			if(_list && _list.parent){
				const layout:TiledRowsLayout = TiledRowsLayout(this._list.layout);
				this._list.itemRendererProperties.gap = layout.gap = layout.paddingTop = layout.paddingBottom = 10*Configrations.ViewScale;
				layout.paddingRight = layout.paddingLeft = 20*Configrations.ViewScale;
				
				
				this._list.width = Math.min(Configrations.ViewPortWidth*0.8,_list.dataProvider.length * renderWidth+100);
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
			while(container.numChildren>0){
				displayObj = container.getChildAt(0);
				if(displayObj is FarmToolsRender){
					(displayObj as FarmToolsRender).destroy();
				}
				container.removeChild(displayObj);
			}
		}
	}
}