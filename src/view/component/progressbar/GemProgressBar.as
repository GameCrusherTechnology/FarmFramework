package view.component.progressbar
{
	import controller.GameController;
	
	import feathers.controls.Button;
	
	import gameconfig.Configrations;
	
	import starling.display.Image;

	public class GemProgressBar extends GreenProgressBar
	{
		private var addButton:Image;
		public function GemProgressBar()
		{
			super(Configrations.ViewPortWidth*.12, 30*Configrations.ViewScale,2,0x000000,0x3FA8DF);
			fillDirection = RIGHT_TO_LEFT;
			showIcon(Game.assets.getTexture("gemIcon"));
			comment = String(GameController.instance.currentPlayer.gems);
			progress = 0;
			
			addButton 
		}
	}
}