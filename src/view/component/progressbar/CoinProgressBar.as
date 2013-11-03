package view.component.progressbar
{
	import gameconfig.Configrations;

	public class CoinProgressBar extends GreenProgressBar
	{
		public function CoinProgressBar()
		{
			super(Configrations.ViewPortWidth*.2, 30*Configrations.ViewScale,2,0x000000,0xFBCE00);
			fillDirection = RIGHT_TO_LEFT;
			showIcon(Game.assets.getTexture("coinIcon"));
		}
	}
}