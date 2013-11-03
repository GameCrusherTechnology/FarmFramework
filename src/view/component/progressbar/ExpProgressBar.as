package view.component.progressbar
{
	import gameconfig.Configrations;

	public class ExpProgressBar extends GreenProgressBar
	{
		
		public function ExpProgressBar()
		{
			super(Configrations.ViewPortWidth*.2, 30*Configrations.ViewScale,2,0x000000,0xFFFF33);
			fillDirection = LEFT_TO_RIGHT;
			showIcon(Game.assets.getTexture("expIcon"));
		}
	}
}