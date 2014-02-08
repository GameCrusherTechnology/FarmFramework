package view.panel
{
	import feathers.controls.PanelScreen;
	import feathers.events.FeathersEventType;
	
	import gameconfig.Configrations;
	
	import starling.events.Event;

	public class HousePanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		
		public function HousePanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Math.min(1800,Configrations.ViewPortWidth*0.9);
			panelheight = Math.min(1500,Configrations.ViewPortHeight*0.9);
		}
	}
}