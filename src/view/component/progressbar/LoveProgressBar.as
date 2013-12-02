package view.component.progressbar
{
	import controller.GameController;
	
	import model.player.GamePlayer;
	import model.player.PlayerChangeEvents;
	
	import starling.events.Event;
	
	public class LoveProgressBar extends GreenProgressBar
	{
		public function LoveProgressBar(w:Number,h:Number)
		{
			super(w, h,2,0x000000,0xB71F1A);
			fillDirection = LEFT_TO_RIGHT;
			showIcon(Game.assets.getTexture("loveIcon"))
			refresh();
			player.addEventListener(PlayerChangeEvents.LOVE_CHANGE,onPlayerChange);
		}
		private function onPlayerChange(event:Event):void
		{
			refresh();
		}
		public function refresh():void
		{
			comment = String(player.love);
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
	}
}