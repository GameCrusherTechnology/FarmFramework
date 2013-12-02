package view.panel
{
	import feathers.controls.PanelScreen;
	import feathers.events.FeathersEventType;
	
	import starling.events.Event;

	public class BuyCropPanel extends PanelScreen
	{
		public function BuyCropPanel(item_id:String)
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			
		}
	}
}