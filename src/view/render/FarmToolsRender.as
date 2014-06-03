package view.render
{
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.TutorialController;
	import controller.UiController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.OwnedItem;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	import view.entity.GameEntity;
	import view.entity.RanchEntity;
	import view.panel.AnimalRanchPanel;
	import view.panel.BuyAnimalPanel;
	import view.panel.BuyItemPanel;

	public class FarmToolsRender extends Sprite
	{
		private var textureName:String;
		private var lableStr:String;
		private var type:String;
		private var id:String;
		private var renderWidth:int = 120*Configrations.ViewScale;
		private var renderHeight:int= 140*Configrations.ViewScale;
		
		private var countText:TextField;
		private var entity:GameEntity;
		public function FarmToolsRender(data:Object,_entity:GameEntity)
		{
			entity = _entity;
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
			if(type== UiController.TOOL_SPEED){
				lableStr += (":"+ Configrations.SPEED_TIME + LanguageController.getInstance().getString("m"));
			}
			var lable:TextField = FieldController.createSingleLineDynamicField(400,30*Configrations.ViewScale,lableStr,0x000000,25,true);
			lable.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(lable);
			lable.x = renderWidth/2 - lable.width/2;
			lable.y = backImage.y+backImage.height;
			
			addEventListener(TouchEvent.TOUCH,button_touchHandler);
			if(type== UiController.TOOL_SPEED){
				var ownedFer:OwnedItem = player.getOwnedItem(Configrations.SPEED_ITEMID);
				countText = FieldController.createSingleLineDynamicField(1000,30,"×"+ownedFer.count,0x000000,25,true);
				countText.hAlign = HAlign.RIGHT;
				countText.autoSize = TextFieldAutoSize.HORIZONTAL;
				addChild(countText);
				countText.x =icon.x+icon.width/2;
				countText.y = icon.y + icon.height - countText.height;
			}else if(type== UiController.TOOL_EXCAVATE){
				if(entity){
					var sp:Sprite = new Sprite;
					var cost:Object = entity.item.serchingCost;
					var i:Image ;
					if(cost.type == "gem"){
						i = new Image(Game.assets.getTexture("gemIcon"));
					}else{
						i = new Image(Game.assets.getTexture("coinIcon"));
					}
					i.width = i.height = 30*Configrations.ViewScale;
					sp.addChild(i);
					
					var costLabel:TextField = FieldController.createSingleLineDynamicField(100,30*Configrations.ViewScale,"×"+cost.price,0x000000,25,true);
					costLabel.hAlign = HAlign.LEFT;
					costLabel.autoSize = TextFieldAutoSize.HORIZONTAL;
					sp.addChild(costLabel);
					costLabel.x = i.width;
					addChild(sp);
					sp.x = renderWidth/2 - sp.width/2;
					sp.y = backImage.y - sp.height;
					
					var nameLabel:TextField = FieldController.createSingleLineDynamicField(400,30,entity.item.cname,0x000000,25,true);
					nameLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					addChild(nameLabel);
					nameLabel.x = renderWidth/2 - nameLabel.width/2;
					nameLabel.y = sp.y - nameLabel.height;
				}
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
			if(TutorialController.instance.inTutorial){
				if(type == UiController.TOOL_HARVEST){
					TutorialController.instance.playStep(2);
				}else if(type == UiController.TOOL_SPEED){
					TutorialController.instance.playStep(10);
				}
			}
			if(type == UiController.TOOL_SPEED){
				var o :OwnedItem = player.getOwnedItem(Configrations.SPEED_ITEMID);
				if(o.count<=0){
					DialogController.instance.showPanel(new BuyItemPanel(Configrations.SPEED_ITEMID));
				}else{
					GameController.instance.selectTool = type;
					UiController.instance.showToolStateButton(type,Game.assets.getTexture(textureName));
				}
			}else if(type == UiController.TOOL_EXCAVATE){
				if(entity){
					entity.searching();
				}
			}else if(type == UiController.TOOL_RANCH_INFO){
				if(entity is RanchEntity){
//					DialogController.instance.showPanel(new AnimalRanchPanel(entity as RanchEntity));
					DialogController.instance.showPanel(new BuyAnimalPanel(entity as RanchEntity));
				}
			}else if(type == UiController.TOOL_CANCEL){
				GameController.instance.selectTool = null;
				GameController.instance.selectSeed = null;
				UiController.instance.hideToolStateButton();
				GameController.instance.currentFarm.removeMoveEntity();
			}
			else{
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