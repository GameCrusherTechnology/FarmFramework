package view.component.UIButton
{
	import controller.DialogController;
	import controller.GameController;
	import controller.TaskController;
	
	import gameconfig.Configrations;
	
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import view.panel.FindTaskPanel;
	import view.panel.TaskPanel;
	
	public class TaskButton extends Sprite
	{
		private var length:Number =  70;
		
		public function TaskButton()
		{
			super();
			length = length * Configrations.ViewScale;
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			var skin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			addChild(skin);
			skin.width = skin.height = length ;
			skin.x = skin.y  = 0;
			
			icon = new Image(Game.assets.getTexture("maleHeadIcon"));
			addChild(icon);
			icon.width = icon.height = length *0.8;
			icon.x = icon.y  = length *0.1;
		}
		private var icon:Image ;
		public function refresh():void
		{
			if(TaskController.instance.getTaskPanelShow()){
				if(player.npc_order.npc == Configrations.NPC_MALE){
					icon.texture = Game.assets.getTexture("maleHeadIcon");
				}else{
					icon.texture = Game.assets.getTexture("femaleHeadIcon");
				}
			}else{
				icon.texture = Game.assets.getTexture("taskIcon");
			}
		}
		
		private function destroy():void
		{
			if(icon && icon.parent){
				icon.parent.removeChild(icon);
			}
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				if(TaskController.instance.getTaskPanelShow()){
					DialogController.instance.showPanel(new TaskPanel());
				} else{
					DialogController.instance.showPanel(new FindTaskPanel());
				}	
			}
		}
		
		
	}
}


