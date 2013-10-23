package org.haxecommons.async.task.command;
import haxe.Log;
import org.haxecommons.async.command.CompositeCommandKind;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.command.impl.CompositeCommand;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.task.event.TaskFlowControlEvent;
import org.haxecommons.async.task.IResetable;
import org.haxecommons.async.task.ITask;
import org.haxecommons.async.task.ITaskFlowControl;

/**
 * @author SlavaRa
 */
class TaskCommand extends CompositeCommand implements IResetable {

	public function new(?kind:CompositeCommandKind) super(kind);
	
	var _stopped:Bool = false;
	var _finishedCommands:Array<ICommand>;

	public override function execute():Dynamic {
		_finishedCommands = [];
		_stopped = false;
		return super.execute();
	}
	
	public function reset() {
		for (cmd in _finishedCommands) {
			if (Std.is(cmd,IResetable)) {
				cast(cmd, IResetable).reset();
			} else if (Std.is(cmd, ITask)) {
				cast(cmd, ITask).reset(true);
			}
		}
		
		if(_finishedCommands == null) {
			_finishedCommands = [];
		}
		
		commands = _finishedCommands.concat(commands);
		_finishedCommands = [];
	}

	override function executeNextCommand(){
		var nextCommand:ICommand = commands.shift();
		if (nextCommand != null) {
			_finishedCommands[_finishedCommands.length] = nextCommand;
		}
		
		#if debug
		Log.trace('Executing next command $nextCommand. Remaining number of commands: ${commands.length}.');
		#end
		
		if (nextCommand != null) {
			executeCommand(nextCommand);
		} else {
			#if debug
			Log.trace('All commands in $this have been executed. Dispatching complete event.');
			#end
			
			dispatchCompleteEvent();
		}
	}

	override function addCommandListeners(?asyncCommand:IOperation) {
		if (Std.is(asyncCommand, ITaskFlowControl)) {
			asyncCommand.addEventListener(TaskFlowControlEvent.BREAK, onFlowControlHandler);
			asyncCommand.addEventListener(TaskFlowControlEvent.CONTINUE, onFlowControlHandler);
			asyncCommand.addEventListener(TaskFlowControlEvent.EXIT, onFlowControlHandler);
		}
		
		super.addCommandListeners(asyncCommand);
	}

	override function removeCommandListeners(?asyncCommand:IOperation) {
		if (Std.is(asyncCommand, ITaskFlowControl)) {
			asyncCommand.removeEventListener(TaskFlowControlEvent.BREAK, onFlowControlHandler);
			asyncCommand.removeEventListener(TaskFlowControlEvent.CONTINUE, onFlowControlHandler);
			asyncCommand.removeEventListener(TaskFlowControlEvent.EXIT, onFlowControlHandler);
		}
		
		super.removeCommandListeners(asyncCommand);
	}

	function onFlowControlHandler(event:TaskFlowControlEvent){
		_stopped = true;
		dispatchEvent(event.clone());
	}
	
}