package view.component.UIButton
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.UiController;
	import controller.VoiceController;
	
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	import model.player.PlayerChangeEvents;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.utils.deg2rad;

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
		private var tipContainer:Image;
		private var tipButton:Button;
		private var countText:TextField;
		public function show(_type:String,texture:Texture):void
		{
			type = _type;
			var skin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			addChild(skin);
			skin.width = skin.height = length ;
			skin.x = -skin.width;
			
			icon = new Image(texture);
			addChild(icon);
			icon.width = icon.height =  length*0.9 ;
			if(type == UiController.TOOL_HARVEST){
				icon.x  = -length/2;
				icon.y = length/2;
				icon.pivotX =icon.pivotY = length*0.45;
			}else{
				icon.x  = -length*0.95;
				icon.y  = length*0.05;
			}
			
			tipButton = new Button();
			tipButton.label =  LanguageController.getInstance().getString("click");
			tipButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
			tipButton.defaultSkin =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("whitePanelSkin"), new Rectangle(1, 1, 198, 98)));
			tipButton.width = length;
			tipButton.height = 30 * Configrations.ViewScale;
			addChild(tipButton);
			tipButton.y = length;
			tipButton.x = -length;
			
			if(type == UiController.TOOL_SPEED || type == UiController.TOOL_SEED){
				countText = FieldController.createSingleLineDynamicField(1000,length," ",0x000000,25,true);
				countText.hAlign = HAlign.RIGHT;
				countText.vAlign = VAlign.BOTTOM;
				countText.autoSize = TextFieldAutoSize.HORIZONTAL;
				addChild(countText);
				countText.x = - countText.width;
				player.addEventListener(PlayerChangeEvents.ITEM_CHANGE,onItemChange);
				onItemChange();
			}else if(type == UiController.TOOL_ADDFEILD){
				countText = FieldController.createSingleLineDynamicField(1000,length," ",0x000000,25,true);
				countText.hAlign = HAlign.RIGHT;
				countText.vAlign = VAlign.BOTTOM;
				countText.autoSize = TextFieldAutoSize.HORIZONTAL;
				addChild(countText);
				countText.x = - countText.width;
				player.addEventListener(PlayerChangeEvents.CROP_CHANGE,onItemChange);
				onItemChange();
			}
		}
		private function onItemChange(e:Event = null):void
		{
			var id:String ;
			var count :int;
			if(type == UiController.TOOL_SPEED){
				id = Configrations.SPEED_ITEMID;
				count = player.getOwnedItem(id).count;
			}else if(type == UiController.TOOL_SEED){
				id = GameController.instance.selectSeed;
				count = player.getOwnedItem(id).count;
			}else if(type == UiController.TOOL_ADDFEILD){
				count = player.leftFarmLand;
			}else{
			}
			countText.text = "×" + count;
			countText.x = - countText.width;
		}
		public function hideTip():void
		{
			var tween:Tween = new Tween(tipButton, 0.5);
			tween.animate("alpha",0);
			tween.onComplete = function():void{
				if(tipButton && tipButton.parent){
					tipButton.parent.removeChild(tipButton);
				}
			};
			Starling.juggler.add(tween);
		}
		
		public function playEffect():void
		{
			var tween:Tween = new Tween(icon,0.2,Transitions.LINEAR);
			tween.animate("rotation", -deg2rad(360));
			Starling.juggler.add(tween);
		}
		public function destroy():void
		{
			if(icon && icon.parent){
				icon.parent.removeChild(icon);
			}
			if(tipButton && tipButton.parent){
				tipButton.parent.removeChild(tipButton);
			}
			if(countText){
				player.removeEventListener(PlayerChangeEvents.ITEM_CHANGE,onItemChange);
			}
			
			if(parent){
				parent.removeChild(this);
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
				VoiceController.instance.playSound(VoiceController.SOUND_BUTTON);
			}
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		
		override public function dispose():void
		{
			player.removeEventListener(PlayerChangeEvents.CROP_CHANGE,onItemChange);
			player.removeEventListener(PlayerChangeEvents.ITEM_CHANGE,onItemChange);
			super.dispose();
		}
	}
}