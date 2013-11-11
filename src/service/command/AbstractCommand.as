package service.command
{
	import controller.GameController;
	
	import model.player.GamePlayer;

	public class AbstractCommand
	{
		public function AbstractCommand(key:String,callback:Function,params:Object=null)
		{
			Command.execute(key,callback,params);
		}
		
		protected function get localplayer():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
	}
}