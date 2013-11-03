package view.render
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import controller.GameController;
	import controller.UiController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import starling.core.RenderSupport;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import view.ui.FarmToolUI;

	public class ToolItemRender extends DefaultListItemRenderer
	{
		public function ToolItemRender()
		{
			super();
		}
		private var type:String;
		private var id:String;
		private var texture:Texture;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				id = value.id;
				texture =value.texture;
				type=value.type;
			}
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
			if(type  == UiController.TOOL_SEED){
				GameController.instance.selectSeed = id;
			}
			GameController.instance.selectTool = type;
			UiController.instance.hideUiTools();
			UiController.instance.showToolStateButton(type,texture);
		}
	}
}