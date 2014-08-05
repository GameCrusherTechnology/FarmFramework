package view.component.UIButton
{
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	import controller.TaskController;
	import controller.VoiceController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.ItemSpec;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.panel.CommunicationPanel;
	
	public class CommunicationButton extends Sprite
	{
		private var length:Number =  70;
		
		public function CommunicationButton()
		{
			super();
			length = length * Configrations.ViewScale;
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			icon = new Image(Game.assets.getTexture("WallIcon"));
			addChild(icon);
			icon.width = icon.height = length;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(1000,30*Configrations.ViewScale,LanguageController.getInstance().getString("board"),0x000000,25);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(nameText);
			nameText.y = icon.y+icon.height - 10*Configrations.ViewScale;
			if(nameText.width >= icon.width){
				nameText.x = 0;
			}else{
				nameText.x = icon.width/2- nameText.width/2;
			}
		}
		private var icon:Image ;
		
		private function destroy():void
		{
			if(icon && icon.parent){
				icon.parent.removeChild(icon);
			}
		}
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				TaskController.instance.finishCurrentOrderByNpc(GameController.instance.currentPlayer);
				DialogController.instance.showPanel(new CommunicationPanel());
				VoiceController.instance.playSound(VoiceController.SOUND_BUTTON);
			}
		}
		
		
	}
}


