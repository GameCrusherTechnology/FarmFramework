package view.effect
{
	import gameconfig.Configrations;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class RainEffect extends Sprite
	{
		private var rainTexture:Texture;
		private var rains:Array;
		public function RainEffect()
		{
			rainTexture = Game.assets.getTexture("raindropIcon");
			rains = [];
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event=null):void
		{
			var i:int = 0;
			while(i<3){
				creatRain();
				i++;
			}
			i=0;
			var l:int = rains.length;
			var rain:RainData;
			if(l>=30){
				onEnd();
			}
			for(i;i<l;i++){
				rain = rains[i];
				if(rain.y >= rain.targetPointY){
					rain.alpha = 0;
				}else{
					rain.y += 15;
				}
			}
		}
		
		private function creatRain():void
		{
			var rain:RainData = new RainData(rainTexture);
			addChild(rain);
			rain.x = Math.random()*(Configrations.Tile_Width-20)*2 -Configrations.Tile_Width+20;
			rain.y = -150;
			var r:Number = Math.random();
			rain.targetPointY = -r*Configrations.Tile_Height*2 +20;
			rain.alpha = 0.3 +r/2;
			rains.push(rain);
		}
		
		private function onEnd():void
		{
			this.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			if(parent){
				parent.removeChild(this);
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}