package view.render
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import starling.events.Event;
	
	public class MenuListRender extends DefaultListItemRenderer
	{
		public function MenuListRender()
		{
			super();
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


