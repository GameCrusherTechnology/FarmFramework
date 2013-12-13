package view.render
{
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.UiController;
	
	import gameconfig.Configrations;
	
	import model.OwnedItem;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	import view.panel.BuyItemPanel;

	public class FarmToolsRender extends Sprite
	{
		private var textureName:String;
		private var lableStr:String;
		private var type:String;
		private var id:String;
		private var renderWidth:int = 80*Configrations.ViewScale;
		private var renderHeight:int= 120*Configrations.ViewScale;
		
		private var countText:TextField;
		
		public function FarmToolsRender(data:Object)
		{
			renderWidth = 80*Configrations.ViewScale;
			renderHeight= 120*Configrations.ViewScale;
			type = data.type;
			id = data.id;
			var backImage:Image =  new Image(Game.assets.getTexture("toolBackSkin"));
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
			if(type== UiController.TOOL_SPEED){
				
				var ownedFer:OwnedItem = player.getOwnedItem(Configrations.SPEED_ITEMID);
				countText = FieldController.createSingleLineDynamicField(renderWidth,30,"×"+ownedFer.count,0x000000,15,true);
				countText.hAlign = HAlign.RIGHT;
				addChild(countText);
				countText.x =icon.x;
				countText.y = icon.y + icon.height - countText.height;
			}
			
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
		
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		private function doSelected():void
		{
			if(type == UiController.TOOL_SPEED){
				var o :OwnedItem = player.getOwnedItem(Configrations.SPEED_ITEMID);
				if(o.count<=0){
					DialogController.instance.showPanel(new BuyItemPanel(Configrations.SPEED_ITEMID));
				}else{
					GameController.instance.selectTool = type;
					UiController.instance.showToolStateButton(type,Game.assets.getTexture(textureName));
				}
			}else{
				GameController.instance.selectTool = type;
				UiController.instance.showToolStateButton(type,Game.assets.getTexture(textureName));
			}
			UiController.instance.hideUiTools();
		}
		public function destroy():void
		{
			removeEventListener(TouchEvent.TOUCH,button_touchHandler);
		}
	}
}