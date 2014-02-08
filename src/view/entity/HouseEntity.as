package view.entity
{
	import controller.DialogController;
	import controller.GameController;
	import controller.UiController;
	
	import gameconfig.LanguageController;
	
	import model.entity.EntityItem;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.TouchPhase;
	
	import view.panel.WarnnigTipPanel;

	public class HouseEntity extends GameEntity
	{
		public function HouseEntity(item:EntityItem)
		{
			super(item);
		}
		override protected function creatSurface():void
		{
			surface = new MovieClip(Game.assets.getTextures(item.name+"Static"));
			addChild(surface);
			surface.x = - surface.width/2;
			surface.y = - surface.height;
			
			if(isWorking){
				effctSur = new MovieClip(Game.assets.getTextures(item.name+"Effect"));
				addChild(effctSur);
				effctSur.x = - surface.width/2 + 30;
				effctSur.y =  surface.y - effctSur.height - 10;
				Starling.juggler.add(effctSur);
			}
		}
		private function get isWorking():Boolean
		{
			return true;
		}
		override public function  doTouchEvent(type:String):void
		{
			if(type == TouchPhase.BEGAN){
				var tool:String = GameController.instance.selectTool;
				if(GameController.instance.isHomeModel){
					if(tool == UiController.TOOL_MOVE){
						scene.addMoveEntity(this);
					}else if(!tool){
						DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warnintTip01")));
					}
				}else{
					
				}
			}
		}
	}
}