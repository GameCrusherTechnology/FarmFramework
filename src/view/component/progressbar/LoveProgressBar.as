package view.component.progressbar
{
	import gameconfig.Configrations;
	import view.component.progressbar.GreenProgressBar;
	
	public class LoveProgressBar extends GreenProgressBar
	{
		public function LoveProgressBar()
		{
			super(Configrations.ViewPortWidth*.12, 30*Configrations.ViewScale,2,0x000000,0xB71F1A);
			fillDirection = LEFT_TO_RIGHT;
			showIcon(Game.assets.getTexture("loveIcon"))
		}
	}
}