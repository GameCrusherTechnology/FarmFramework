package view.component.UIButton
{
	import controller.GameController;
	import controller.UiController;
	
	import gameconfig.Configrations;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	import view.ui.FarmToolUI;

	public class ToolStateButton extends Sprite
	{
		private var length:Number =  70;
		
		public function ToolStateButton()
		{
			super();
			length = length * Configrations.ViewScale;
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		private var icon:Image ;
		private var type:String;
		public function show(_type:String,texture:Texture):void
		{
			destroy();
			type = _type;
			icon = new Image(texture);
			addChild(icon);
			icon.width = icon.height = length ;
			icon.x = icon.y = icon.pivotX =icon.pivotY = length/2;
		}
		
		public function playEffect():void
		{
			var tween:Tween = new Tween(icon,0.2,Transitions.LINEAR);
			tween.animate("rotation", -deg2rad(360));
			Starling.juggler.add(tween);
		}
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
				GameController.instance.selectTool = null;
				GameController.instance.selectSeed = null;
				UiController.instance.hideToolStateButton();
				if(type == UiController.TOOL_SEED){
					UiController.instance.showUiTools(UiController.TOOL_SEED);
				}
			}
		}
		
	}
}