package org.haxecommons.async.task.command;
import flash.events.TimerEvent;
import flash.utils.Timer;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.operation.impl.AbstractOperation;

/**
 * @author SlavaRa
 */
class PauseCommand extends AbstractOperation implements ICommand {
	
	public function new(duration:Int) {
		super();
		_duration = duration;
	}
	
	var _duration:Int;

	public function execute():Dynamic {
		var timer = new Timer(_duration);
		timer.addEventListener(TimerEvent.TIMER, onTimerTimer);
		timer.start();
		return null;
	}

	function onTimerTimer(event:TimerEvent) {
		var timer = event.target;
		timer.removeEventListener(TimerEvent.TIMER, onTimerTimer);
		timer.stop();
		dispatchCompleteEvent(null);
	}
}