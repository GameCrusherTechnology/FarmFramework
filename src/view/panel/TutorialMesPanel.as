package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	public class TutorialMesPanel extends Sprite
	{
		private var icon:Image;
		private var speechSkin:Scale9Image;
		private var mesText:TextField;
		private var panelSkin:Scale9Image;
		public function TutorialMesPanel(mes:String = " ")
		{
			
			panelSkin =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			addChild(panelSkin);
			
			icon = new Image(Game.assets.getTexture("femaleIcon"));
			addChild(icon);
			
			speechSkin =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("speechBackSkin"),new Rectangle(30, 10, 150, 80)));
			addChild(speechSkin);
			speechSkin.width =  Configrations.ViewPortWidth*0.5;
			
			
			mesText = FieldController.createSingleLineDynamicField(speechSkin.width - 10*Configrations.ViewScale,1000,mes,0x000000,30,true);
			addChild(mesText);
			mesText.autoSize = TextFieldAutoSize.VERTICAL;
			configPos();
		}
		
		public function talk(mes:String):void
		{
			mesText.text = mes;
			configPos();
		}
		
		private function configPos():void
		{
			var mH:Number = Math.max(mesText.height,100*Configrations.ViewScale);
			speechSkin.height = mH + 20*Configrations.ViewScale;
			
			
			icon.height = speechSkin.height+ 20*Configrations.ViewScale;
			icon.scaleX = icon.scaleY;
			icon.x =  0;
			icon.y = 0;
			
			
			speechSkin.x = icon.x + icon.width + 10*Configrations.ViewScale;
			speechSkin.y = 10 * Configrations.ViewScale;
			
			mesText.x =  speechSkin.x + 10*Configrations.ViewScale;
			mesText.y =  10*Configrations.ViewScale + speechSkin.height/2-mesText.height/2;
			
			panelSkin.width = speechSkin.x+speechSkin.width  + 10*Configrations.ViewScale;
			panelSkin.height= speechSkin.height + 20*Configrations.ViewScale;
		}
	}
}