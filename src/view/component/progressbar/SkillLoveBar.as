package view.component.progressbar
{
	import controller.GameController;
	
	import model.player.GamePlayer;

	public class SkillLoveBar extends GreenProgressBar
	{
		private var total_love:int;
		public function SkillLoveBar(w:Number,h:Number,total:int)
		{
			total_love = total;
			super(w, h,2,0x000000,0xB71F1A);
			fillDirection = LEFT_TO_RIGHT;
			showIcon(Game.assets.getTexture("loveIcon"))
			refresh();
		}
		
		public function refresh():void
		{
			comment = String(Math.min(total_love,player.love)) +"/" + total_love;
			progress = player.love/total_love;
		}
		
		protected function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
	
}