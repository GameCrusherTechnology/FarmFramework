package view.component.progressbar
{
	import controller.GameController;
	
	import model.player.GamePlayer;
	import model.player.PlayerChangeEvents;
	
	import starling.events.Event;

	public class CoinProgressBar extends GreenProgressBar
	{
		public function CoinProgressBar(w:Number,h:Number,direction:String = RIGHT_TO_LEFT)
		{
			super(w, h,2,0x000000,0xFBCE00);
			fillDirection = direction;
			showIcon(Game.assets.getTexture("coinIcon"));
			refresh();
			player.addEventListener(PlayerChangeEvents.COIN_CHANGE,onPlayerChange);
		}
		private function onPlayerChange(event:Event):void
		{
			refresh();
		}
		public function refresh():void
		{
			comment = String(player.coin);
		}
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}