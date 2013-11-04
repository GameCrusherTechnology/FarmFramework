package view.render
{
	import flash.utils.getTimer;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import starling.core.RenderSupport;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class MenuListRender extends DefaultListItemRenderer
	{
		public function MenuListRender()
		{
			super();
		}
		override protected function button_touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				doSelected();
			}
		}
		override protected function itemRenderer_triggeredHandler(event:Event):void
		{
			super.itemRenderer_triggeredHandler(event);
			doSelected();
		}
		
		private function doSelected():void
		{
			
		}
	}
}


