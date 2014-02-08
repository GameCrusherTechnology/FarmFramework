package view.component.progressbar
{
	import controller.GameController;
	
	import model.player.GamePlayer;

	public class CoinProgressBar extends GreenProgressBar
	{
		public function CoinProgressBar(w:Number,h:Number,direction:String = RIGHT_TO_LEFT)
		{
			super(w, h,2,0x000000,0xFBCE00);
			fillDirection = direction;
			showIcon(Game.assets.getTexture("coinIcon"));
			refresh();
		}
		public function refresh():void
		{
			comment = String(player.coin);
		}
		protected function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}