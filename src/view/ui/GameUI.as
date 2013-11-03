package view.ui
{
	import controller.GameController;
	import controller.TextFieldFactory;
	import controller.UiController;
	
	import gameconfig.Configrations;
	
	import model.player.GamePlayer;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	
	import view.component.UIButton.MenuButton;
	import view.component.progressbar.CoinProgressBar;
	import view.component.progressbar.ExpProgressBar;
	import view.component.progressbar.GemProgressBar;
	import view.component.progressbar.LoveProgressBar;

	public class GameUI extends Sprite
	{
		private var expBar:ExpProgressBar;
		private var coinBar:CoinProgressBar;
		private var gemBar:GemProgressBar;
		private var loveBar:LoveProgressBar;
		private var farmNameText:TextField;
		private var menuButton:MenuButton;
		
		public function GameUI()
		{
			
		}
		public function homeUI():void
		{
			farmNameText = TextFieldFactory.createNoFontField(Configrations.ViewPortWidth *0.2,30,currentplayer.farmName,0x000000,18);
			addChild(farmNameText);
			farmNameText.x = 0;
			farmNameText.y = 0;
			
			configExpBar();
			configCoinBar();
			configGemBar();
			configLoveBar();
			configIcons();
			UiController.instance.showEditUiTools(false);
		}
		private function configIcons():void
		{
			menuButton = new MenuButton();
			addChild(menuButton);
			menuButton.x = 10;
			menuButton.y = Configrations.ViewPortHeight - menuButton.height -10 ;
			
			
		}
		
		private function configExpBar():void
		{
			expBar = new ExpProgressBar();
			addChild(expBar);
			expBar.x = 30;
			expBar.y = 30;
		}
		private function configCoinBar():void
		{
			coinBar = new CoinProgressBar();
			addChild(coinBar);
			coinBar.x = Configrations.ViewPortWidth - coinBar.width;
			coinBar.y = 30;
		}
		private function configGemBar():void
		{
			gemBar = new GemProgressBar();
			addChild(gemBar);
			gemBar.x = Configrations.ViewPortWidth - gemBar.width;
			gemBar.y = coinBar.y + coinBar.height;
		}
		private function configLoveBar():void
		{
			loveBar = new LoveProgressBar();
			addChild(loveBar);
			loveBar.x = 30;
			loveBar.y = expBar.y + expBar.height;
			
		}
		private function get currentplayer():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}