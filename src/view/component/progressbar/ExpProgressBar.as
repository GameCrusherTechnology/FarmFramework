package view.component.progressbar
{
	import controller.GameController;
	
	import gameconfig.Configrations;
	
	import model.player.GamePlayer;
	import model.player.PlayerChangeEvents;
	
	import starling.events.Event;

	public class ExpProgressBar extends GreenProgressBar
	{
		
		public function ExpProgressBar()
		{
			super(Configrations.ViewPortWidth*.2, 30*Configrations.ViewScale,2,0x000000,0xFFFF33);
			fillDirection = LEFT_TO_RIGHT;
			showIcon(Game.assets.getTexture("expIcon"));
			refresh();
		}
		public function refresh():void
		{
			comment = String(player.exp);
			
			var level:int = Configrations.expToGrade(player.exp);
			var nextLevel:int = level+1;
			var currentExp:int = player.exp - Configrations.gradeToExp(level);
			var currentTotal:int =  Configrations.gradeToExp(nextLevel) - Configrations.gradeToExp(level);
			progress = currentExp/currentTotal;
			
			iconStr = String(level);
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		override public function dispose():void
		{
			super.dispose();
		}
	}
}