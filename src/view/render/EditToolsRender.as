package view.render
{
	import controller.GameController;
	import controller.FieldController;
	import controller.UiController;
	
	import gameconfig.Configrations;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class EditToolsRender extends Sprite
	{
		private var textureName:String;
		private var lableStr:String;
		private var type:String;
		private var id:String;
		private var renderWidth:int = 80*Configrations.ViewScale;
		private var renderHeight:int= 100*Configrations.ViewScale;
		
		public function EditToolsRender(data:Object)
		{
			renderWidth = 80*Configrations.ViewScale;
			renderHeight= 100*Configrations.ViewScale;
			type = data.type;
			id = data.id;
			var backImage:Image =  new Image(Game.assets.getTexture("editButtonSkin"));
			addChild(backImage);
			backImage.width = backImage.height = renderWidth;
			//icon
			textureName = data.texture;
			var icon:Image = new Image(Game.assets.getTexture(textureName));
			addChild(icon);
			icon.width = icon.height = renderWidth *.7;
			icon.x = icon.y = renderWidth *.15;
			//text
			lableStr = data.label;
			var lable:TextField = FieldController.createSingleLineDynamicField(renderWidth,30,lableStr,0xffffff,25,true);
			addChild(lable);
			lable.x = 0;
			lable.y = renderHeight - lable.height-5;
			
			addEventListener(TouchEvent.TOUCH,button_touchHandler);
		}
		private var lastTouchBegin:int = 0;
		private function button_touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				doSelected();
			}
		}
		private function doSelected():void
		{
			if(type){
				if(type == UiController.TOOL_CANCEL){
					GameController.instance.selectTool = null;
					GameController.instance.selectSeed = null;
					UiController.instance.hideToolStateButton();
				}else{
					GameController.instance.selectTool = type;
					UiController.instance.showToolStateButton(type,Game.assets.getTexture(textureName));
				}
				UiController.instance.showEditUiTools(false);
			}else{
				UiController.instance.showEditUiTools(true);
			}
		}
		public function destroy():void
		{
			removeEventListener(TouchEvent.TOUCH,button_touchHandler);
		}
	}
}