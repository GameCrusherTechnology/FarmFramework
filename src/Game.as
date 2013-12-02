package
{
    import flash.ui.Keyboard;
    
    import controller.GameController;
    
    import gameconfig.Configrations;
    import gameconfig.Devices;
    
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    import starling.utils.AssetManager;
    
    
    public class Game extends Sprite
    {
//		private var mLoadingProgress:ProgressBar;
		
		public static var assets:AssetManager;
        public function Game()
        {
            this.alpha = 0.999;
        }
		public function start(_asset:AssetManager):void
		{
			Starling.current.stage.stageWidth  = Configrations.ViewPortWidth = Devices.getDeviceDetails().width;
			Starling.current.stage.stageHeight = Configrations.ViewPortHeight= Devices.getDeviceDetails().height;
			Configrations.ViewScale = Math.min(Configrations.ViewPortWidth/1024,Configrations.ViewPortHeight/768);
			assets = _asset;
//			mLoadingProgress = new ProgressBar();
//			mLoadingProgress.width = 200;
//			mLoadingProgress.height = 80;
//			mLoadingProgress.minimum = 0;
//			mLoadingProgress.maximum = 1;
//			const progressLayoutData:AnchorLayoutData = new AnchorLayoutData();
//			progressLayoutData.horizontalCenter = 0;
//			progressLayoutData.verticalCenter = 0;
//			mLoadingProgress.layoutData = progressLayoutData;
//			mLoadingProgress.x = (Configrations.ViewPortWidth  - mLoadingProgress.width) / 2;
//			mLoadingProgress.y = Configrations.ViewPortHeight * 0.7;
//			addChild(mLoadingProgress);
			
			
			GameController.instance.show(this);
			assets.loadQueue(onLoadQueue);
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(starling.events.Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		private function onLoadQueue(ratio:Number):void
		{
//			mLoadingProgress.value = ratio;
			
			// a progress bar should always show the 100% for a while,
			// so we show the main menu only after a short delay. 
			
			if (ratio == 1){
//				mLoadingProgress.removeFromParent(true);
//				mLoadingProgress = null;
				GameController.instance.start();
				
			}
		}
        private function onAddedToStage(event:starling.events.Event):void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        }
        private function onRemovedFromStage(event:starling.events.Event):void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
        }
        
        private function onKey(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.SPACE)
                Starling.current.showStats = !Starling.current.showStats;
            else if (event.keyCode == Keyboard.X)
                Starling.context.dispose();
        }
        
        
    }
}