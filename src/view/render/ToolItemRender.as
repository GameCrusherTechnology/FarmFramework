package view.render
{
	import flash.utils.getTimer;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	import controller.UiController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.text.BitmapFontTextFormat;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.OwnedItem;
	import model.gameSpec.CropSpec;
	import model.player.GamePlayer;
	
	import starling.core.RenderSupport;
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
	import starling.utils.HAlign;
	
	import view.panel.BuyItemPanel;
	import view.panel.WarnnigTipPanel;
	
	public class ToolItemRender extends DefaultListItemRenderer
	{
		public function ToolItemRender()
		{
			super();
		}
		private var type:String;
		private var id:String;
		private var texture:Texture;
		
		private var container:Sprite;
		private var no_level:Boolean = false;
		private var no_count:Boolean = false;
		
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				id = value.id;
				texture =value.texture;
				type=value.type;
				no_count = no_level = false;
				
				if(container&&container.parent){
					container.parent.removeChild(container);
				}
				configContainer();
			}
		}
		
		private function configContainer():void
		{
			var renderwidth:Number = width;
			var renderheight:Number = height;
			var scale:Number = Configrations.ViewScale;
			
			container = new Sprite;
			addChild(container);
			
			var spec:CropSpec = SpecController.instance.getItemSpec(id) as CropSpec;
			
			var icon:Image = new Image(Game.assets.getTexture(spec.name +"Icon"));
			icon.width = icon.height = Math.min(renderheight*0.8,renderwidth*0.8);
			icon.x = renderwidth/2 - icon.width/2;
			icon.y = renderheight*0.2;
			container.addChild(icon);
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,30*scale,spec.name,0x000000,25,true);
			nameText.hAlign = HAlign.CENTER;
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(nameText);
			
			
			var ownitem:OwnedItem = player.getOwnedItem(id);
			var countText:TextField = FieldController.createSingleLineDynamicField(renderwidth,30*scale,"×"+ownitem.count,0x000000,15,true);
			countText.hAlign = HAlign.RIGHT;
			container.addChild(countText);
			countText.y = renderheight - countText.height - 10*scale;
			
			if(spec.level > player.level){
				//阻止 点击
				no_level = true;
				var blackSkin:Shape = new Shape;
				blackSkin.graphics.beginFill(0x000000,0.5);
				blackSkin.graphics.drawRect(0,0,renderwidth,renderheight);
				blackSkin.graphics.endFill();
				container.addChild(blackSkin);
				
			}else if(ownitem.count <=0){
				//add buy
				no_count = true;
				var buyBut:Button = new Button();
				buyBut.label = LanguageController.getInstance().getString("buy");
				buyBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
				buyBut.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0xffffff);
				buyBut.paddingLeft =buyBut.paddingRight =  2;
				buyBut.paddingTop =buyBut.paddingBottom =  2;
				buyBut.width =renderwidth *0.8;
				container.addChild(buyBut);
				buyBut.validate();
				buyBut.x = renderwidth/2 - buyBut.width/2;
				buyBut.y =  renderheight - buyBut.height;
			}
			
		}
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			super.render(support,parentAlpha);
			if(lastTouchBegin>0 && (getTimer() - lastTouchBegin >500)){
				lastTouchBegin = 0;
				doSelected();
			}
		}
		private var lastTouchBegin:int = 0;
		override protected function button_touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				lastTouchBegin =getTimer();
			}
			touch =  event.getTouch(this, TouchPhase.ENDED);
			if(touch){
				lastTouchBegin = 0;
			}
			
			super.button_touchHandler(event);
		}
		override protected function itemRenderer_triggeredHandler(event:Event):void
		{
			super.itemRenderer_triggeredHandler(event);
			doSelected();
		}
		
		private function doSelected():void
		{
			if(no_level){
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warnTip01")));
			}else if(no_count){
				DialogController.instance.showPanel(new BuyItemPanel(id));
			}else if(type  == UiController.TOOL_SEED){
				GameController.instance.selectSeed = id;
				GameController.instance.selectTool = type;
				UiController.instance.showToolStateButton(type,texture);
			}
			UiController.instance.hideUiTools();
		}
	}
}