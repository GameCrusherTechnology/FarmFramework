package view.render
{
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.UiController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.panel.ExtendFarmLandPanel;
	import view.panel.ExtendFarmPanel;
	
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
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(1000,30*Configrations.ViewScale,lableStr,0x000000,25);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(nameText);
			nameText.y = backImage.y+backImage.height - 10*Configrations.ViewScale;
			nameText.x = renderWidth/2 - nameText.width/2;
			
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
				}else if(type == UiController.TOOL_EXTEND){
					GameController.instance.selectTool = null;
					GameController.instance.selectSeed = null;
					UiController.instance.hideToolStateButton();
					DialogController.instance.showPanel(new ExtendFarmPanel());
				}else if(type == UiController.TOOL_ADDFEILD){
					if(GameController.instance.localPlayer.leftFarmLand <= 0){
						GameController.instance.selectTool = null;
						GameController.instance.selectSeed = null;
						UiController.instance.hideToolStateButton();
						DialogController.instance.showPanel(new ExtendFarmLandPanel());
					}else{
						GameController.instance.selectTool = type;
						UiController.instance.showToolStateButton(type,Game.assets.getTexture(textureName));
					}
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