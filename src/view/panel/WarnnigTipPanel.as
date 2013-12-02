package view.panel
{
	import controller.FieldController;
	
	import feathers.controls.PanelScreen;
	import feathers.events.FeathersEventType;
	
	import gameconfig.Configrations;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.VAlign;

	public class WarnnigTipPanel extends PanelScreen
	{
		private var mes:String;
		public function WarnnigTipPanel(str:String)
		{
			mes = str;
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			var mesText:TextField = FieldController.createSingleLineDynamicField(Configrations.ViewPortWidth,Configrations.ViewPortHeight,
				mes,0xff0000,50,true);
			addChild(mesText);
			mesText.vAlign = VAlign.TOP;
			mesText.pivotY = -Configrations.ViewPortHeight*0.2;
			var tween:Tween = new Tween(this,2);
			tween.animate("alpha",0);
			tween.onComplete = destroy;
			Starling.juggler.add(tween);
		}
		
		private function destroy():void
		{
			if(parent){
				parent.removeChild(this);
			}
		}
		
	}
}