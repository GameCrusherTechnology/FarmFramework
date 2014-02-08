package view.component.progressbar
{
	import controller.GameController;
	
	import model.player.GamePlayer;

	public class SkillCoinBar extends GreenProgressBar
	{
		private var total_coin:int;
		
		public function SkillCoinBar(w:Number,h:Number,total:int)
		{
			total_coin = total;
			super(w, h,2,0x000000,0xFBCE00);
			fillDirection = LEFT_TO_RIGHT;
			showIcon(Game.assets.getTexture("coinIcon"));
			refresh();
		}
		public function refresh():void
		{
			comment = String(player.coin) +"/" + total_coin;
			progress = player.coin/total_coin;
		}
		protected function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		
	}
}