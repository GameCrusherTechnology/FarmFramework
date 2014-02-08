package view.component.progressbar
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.GameController;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.player.GamePlayer;
	import model.player.PlayerChangeEvents;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import view.panel.TreasurePanel;

	public class GemProgressBar extends GreenProgressBar
	{
		private var addButton:Scale9Image;
		public function GemProgressBar()
		{
			super(Configrations.ViewPortWidth*.12, 30*Configrations.ViewScale,2,0x000000,0x3FA8DF);
			fillDirection = RIGHT_TO_LEFT;
			showIcon(Game.assets.getTexture("gemIcon"));
			
			var scaleTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("addIcon"),new Rectangle(2,2,21,21));
			addButton  = new Scale9Image(scaleTexture);;
			addChild(addButton);
			addButton.width = addButton.height =  40*Configrations.ViewScale;
			addButton.x = - addButton.width/2;
			addButton.y = - 5*Configrations.ViewScale;
			addButton.addEventListener(TouchEvent.TOUCH,onAddButtonTouched);
			
			refresh();
		}
		public function refresh():void
		{
			comment = String(player.gem);
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		private function onAddButtonTouched(e:TouchEvent):void
		{
			e.stopPropagation();
			var touch:Touch = e.getTouch(addButton,TouchPhase.BEGAN);
			if(touch){
				DialogController.instance.showPanel(new TreasurePanel());
			}
		}
		override public function dispose():void
		{
			super.dispose();
		}
	}
}