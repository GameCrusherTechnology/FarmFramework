package view.component.progressbar{
	
	
	public class EnergyProgressBar extends GreenProgressBar {
		
		public function EnergyProgressBar(){
			
//			this.m_cStar = new LevelStar();
//			m_cStar.scaleX = m_cStar.scaleY = 2;
			super(bar_width, bar_height, 5, 6317693);
//			addChild(this.m_cStar);
		}
		public function addPower():void
		{
//			m_cStar.levelUp(1);
		}
		
		override public function set fillDirection(_arg1:String):void{
			super.fillDirection = _arg1;
			switch (_arg1){
				case LEFT_TO_RIGHT:
//					this.m_cStar.x = m_nBarWidth;
					break;
				case RIGHT_TO_LEFT:
//					this.m_cStar.x = 0;
					break;
			};
		}
		public function set power(_arg1:int):void{
//			this.m_cStar.level = _arg1;
		}
		
	}
}

