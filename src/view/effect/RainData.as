package view.effect
{
	import starling.display.Image;
	import starling.textures.Texture;

	public class RainData extends Image
	{
		public function RainData(texture:Texture)
		{
			super(texture);
		}
		
		public var icon:Image;
		public var targetPointY:Number;
			
	}
}