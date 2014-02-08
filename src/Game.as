package
{
    
    import flash.desktop.NativeApplication;
    import flash.events.Event;
    import flash.ui.Keyboard;
    
    import controller.GameController;
    import controller.VoiceController;
    
    import gameconfig.Configrations;
    import gameconfig.Devices;
    
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
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
			addEventListener(EnterFrameEvent.ENTER_FRAME,onEnterFrame);
		}
		private function onEnterFrame(e:EnterFrameEvent):void
		{
			GameController.instance.tick();
		}
        
        
    }
}