package view.component.progressbar
{
	import controller.GameController;
	
	import gameconfig.Configrations;
	
	import model.player.GamePlayer;
	
	public class LoveProgressBar extends GreenProgressBar
	{
		public function LoveProgressBar(w:Number,h:Number)
		{
			super(w, h,2,0x000000,0xB71F1A);
			fillDirection = LEFT_TO_RIGHT;
			showIcon(Game.assets.getTexture("loveIcon"))
			refresh();
		}
		public function refresh():void
		{
			if(player.love >= Configrations.gradeToLove(player.skillLevel)){
				comment = String( Configrations.gradeToLove(player.skillLevel));
			}else{
				comment = String(player.love);
			}
			progress = player.love/Configrations.gradeToLove(player.skillLevel);
		}
		protected function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		override public function dispose():void
		{
			super.dispose();
		}
	}
}