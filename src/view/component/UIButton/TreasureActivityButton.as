package view.component.UIButton
{
	import controller.DialogController;
	import controller.FieldController;
	import controller.UiController;
	import controller.VoiceController;
	
	import gameconfig.Configrations;
	import gameconfig.SystemDate;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.panel.PayActivitiesPanel;
	
	public class TreasureActivityButton extends Sprite
	{
		private var buttonText:TextField;
		public function TreasureActivityButton()
		{
			super();
			
			var skin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			addChild(skin);
			skin.width = skin.height = 70 * Configrations.ViewScale;
			
			var icon:Image = new Image(Game.assets.getTexture("GiftIcon"));
			icon.width = icon.height = 60 * Configrations.ViewScale;
			addChild(icon);
			icon.x = icon.y = 5 * Configrations.ViewScale;
			
			if(Configrations.treasuresActivity.time){
				buttonText = FieldController.createSingleLineDynamicField(400,30," ",0x000000,25,true);
				addChild(buttonText);
				buttonText.autoSize = TextFieldAutoSize.HORIZONTAL;
				buttonText.x = icon.x;
				buttonText.y =  icon.height - 2* icon.y ;
			}
			addEventListener(TouchEvent.TOUCH,onTouch);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		private var sysTime:Number;
		private function onEnterFrame(e:Event):void
		{
			if(buttonText && Configrations.treasuresActivity.time){
				sysTime = SystemDate.systemTimeS;
				
				if(Configrations.treasuresActivity.time > sysTime){
					buttonText.text = SystemDate.getTimeLeftString(Configrations.treasuresActivity.time - SystemDate.systemTimeS);
				}else{
					UiController.instance.removeActivityBut();
				}
			}
		}
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				VoiceController.instance.playSound(VoiceController.SOUND_BUTTON);
				DialogController.instance.showPanel(new PayActivitiesPanel());
			}
		}
		
	}
}


