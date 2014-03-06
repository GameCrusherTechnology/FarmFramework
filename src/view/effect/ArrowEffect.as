package view.effect
{
	import gameconfig.Configrations;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.deg2rad;

	public class ArrowEffect extends Sprite
	{
		private var mc:Image;
		public function ArrowEffect()
		{
			mc = new Image(Game.assets.getTexture("leftArrowIcon"));
			mc.scaleX = mc.scaleY = Configrations.ViewScale;
			mc.pivotX = mc.width/2;
			mc.pivotY = mc.height/2;
			addChild(mc);
		}
		
		public function setRot(r:Number):void
		{
			mc.rotation = deg2rad(r);
		}
		
	}
}