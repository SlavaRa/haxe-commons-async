package org.haxecommons.async.task.impl;
import org.haxecommons.async.command.CompositeCommandKind;
import org.haxecommons.async.command.event.CompositeCommandEvent;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.command.ICompositeCommand;
import org.haxecommons.async.command.impl.CompositeCommand;
import org.haxecommons.async.command.impl.GenericOperationCommand;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.impl.AbstractOperation;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.task.command.FunctionCommand;
import org.haxecommons.async.task.command.PauseCommand;
import org.haxecommons.async.task.command.TaskCommand;
import org.haxecommons.async.task.command.TaskFlowControlCommand;
import org.haxecommons.async.task.event.TaskEvent;
import org.haxecommons.async.task.event.TaskFlowControlEvent;
import org.haxecommons.async.task.IConditionProvider;
import org.haxecommons.async.task.ICountProvider;
import org.haxecommons.async.task.IForBlock;
import org.haxecommons.async.task.IIfElseBlock;
import org.haxecommons.async.task.IResetable;
import org.haxecommons.async.task.ITask;
import org.haxecommons.async.task.IWhileBlock;
import org.haxecommons.async.task.TaskFlowControlKind;

/**
 * @author SlavaRa
 */
class Task extends AbstractOperation implements ITask/* implements IDisposable*/ {

	public function new() {
		super();
		initTask();
	}
	
	public var isDisposed(default, null):Bool;
	public var isClosed(default, null):Bool;
	public var parent(default, default) :ITask;
	public var context(default, default):Dynamic;
	public var failOnFault:Bool = true;

	var commandList:Array<ICommand>;
	var finishedCommandList:Array<ICommand>;
	var currentCommand:ICommand;
	
	public function next(item:Dynamic, ?constructorArgs:Array<Dynamic>):ITask {
		#if debug
		if(item == null) throw "the item argument must not be null";
		#end
		
		var command = Std.is(item, ICommand) ? cast(item, ICommand) : GenericOperationCommand.createNew(item, constructorArgs);
		var result = addCommand(command, CompositeCommandKind.SEQUENCE);
		
		return result != null ? result : this;
	}

	public function and(item:Dynamic, ?constructorArgs:Array<Dynamic>):ITask {
		#if debug
		if(item == null) throw "the item argument must not be null";
		#end
		
		var command = Std.is(item, ICommand) ? cast(item, ICommand) : GenericOperationCommand.createNew(item, constructorArgs);
		var result = addCommand(command, CompositeCommandKind.PARALLEL);
		return result != null ? result : this;
	}

	public function if_(?conditionProvider:IConditionProvider, ?ifElseBlock:IIfElseBlock):IIfElseBlock {
		ifElseBlock = (ifElseBlock != null) ? ifElseBlock : new IfElseBlock(conditionProvider);
		
		var cmd = commandList[commandList.length - 1];
		if (Std.is(cmd, ICompositeCommand) || (Std.is(cmd, ITask) && (cast(cmd, ITask).isClosed))) {
			addToCommandList(ifElseBlock);
		} else {
			addCommand(ifElseBlock, CompositeCommandKind.SEQUENCE);
		}
		
		return ifElseBlock;
	}

	public function else_():IIfElseBlock {
		var result:IIfElseBlock = null;
		if (commandList.length > 0) {
			var ifElseBlock:IIfElseBlock = cast commandList[commandList.length - 1];
			if (ifElseBlock != null) {
				ifElseBlock.switchToElseBlock();
				result = ifElseBlock;
			}
		}
		return result;
	}

	public function while_(?conditionProvider:IConditionProvider, ?whileBlock:IWhileBlock):IWhileBlock {
		whileBlock = whileBlock != null ? whileBlock : new WhileBlock(conditionProvider);
		
		var cmd:ICommand = (commandList.length > 0) ? commandList[commandList.length - 1] : null;
		if (Std.is(cmd, ICompositeCommand) || (Std.is(cmd, ITask) && (cast(cmd, ITask).isClosed))) {
			addToCommandList(whileBlock);
		} else {
			addCommand(whileBlock, CompositeCommandKind.SEQUENCE);
		}
		return whileBlock;
	}

	public function for_(count:Int, ?countProvider:ICountProvider, ?forBlock:IForBlock):IForBlock {
		countProvider = ((countProvider == null) && (forBlock == null)) ? new CountProvider(count) : countProvider;
		forBlock = (forBlock != null) ? forBlock : new ForBlock(countProvider);
		
		var cmd:ICommand = (commandList.length > 0) ? commandList[commandList.length - 1] : null;
		if (Std.is(cmd, ICompositeCommand) || (Std.is(cmd, Task) && (cast(cmd, ITask).isClosed))) {
			addToCommandList(forBlock);
		} else {
			addCommand(forBlock, CompositeCommandKind.SEQUENCE);
		}
		
		return forBlock;
	}

	public function end():ITask {
		if (commandList.length > 0) {
			var command:ICommand = commandList[commandList.length - 1];
			if(Std.is(command, ITask)) {
				var task:ITask = cast(command, ITask);
				if(!task.isClosed) {
					return task.end();
				}
			}
		}
		return parent != null ? parent : this;
	}

	public function exit():ITask {
		var result = addCommand(new TaskFlowControlCommand(TaskFlowControlKind.EXIT), CompositeCommandKind.SEQUENCE);
		return result != null ? result : this;
	}

	public function pause(duration:Int, ?pauseCommand:ICommand):ITask {
		pauseCommand = pauseCommand == null ? new PauseCommand(duration) : pauseCommand;
		
		var result = addCommand(pauseCommand, CompositeCommandKind.SEQUENCE);
		return result != null ? result : this;
	}

	public function execute():Dynamic {
		finishedCommandList = [];
		executeNextCommand();
		return null;
	}
	
	public function reset(?doHardReset:Bool):ITask {
		if (doHardReset) {
			resetCommandList();
		} else {
			commandList[commandList.length] = new FunctionCommand(resetCommandList);
		}
		
		return this;
	}
	
	public function dispose() {
		if (!isDisposed) {
			commandList = null;
			context = null;
			finishedCommandList = null;
			parent = null;
			isDisposed = true;
		}
	}

	public function break_():ITask return this;
	
	public function continue_():ITask return this;
	
	function initTask() {
		commandList = [];
		context = {};
	}

	function addToCommandList(command:ICommand) {
		commandList[commandList.length] = command;
		currentCommand = command;
		
		if (Std.is(command, ITask)) {
			cast(command, ITask).parent = this;
		}
	}
	
	function addTaskCommand(kind:CompositeCommandKind):CompositeCommand {
		var taskCommand = new TaskCommand(kind);
		addToCommandList(taskCommand);
		return taskCommand;
	}

	function addCommand(command:ICommand, kind:CompositeCommandKind):ITask {
		var compositeCommand:ICompositeCommand = null;
		
		if (currentCommand != null) {
			var task:ITask = null;
			
			if(Std.is(currentCommand, ITask)) {
				task = cast(currentCommand, ITask);
			}
			
			if ((task != null) && !task.isClosed) {
				task.next(command);
				return task;
			} else {
				if(Std.is(currentCommand, ICompositeCommand)) {
					compositeCommand = cast(currentCommand, ICompositeCommand);
				}
				
				if ((compositeCommand != null) && (compositeCommand.kind != kind)) {
					compositeCommand = null;
				} 
				
				if (compositeCommand == null) {
					compositeCommand = addTaskCommand(kind);
				}
				
				compositeCommand.addCommand(command);
			}
		} else {
			compositeCommand = addTaskCommand(kind);
			compositeCommand.addCommand(command);
		}
		
		return null;
	}

	function executeCommand(command:ICommand) {
		currentCommand = command;
		
		if (command != null) {
			var async:IOperation = null;
			
			if(Std.is(command, IOperation)) {
				async = cast(command, IOperation);
				addCommandListeners(async);
				dispatchTaskEvent(TaskEvent.BEFORE_EXECUTE_COMMAND, command);
				command.execute();
			} else {
				dispatchTaskEvent(TaskEvent.AFTER_EXECUTE_COMMAND, command);
				executeNextCommand();
			}
		} else {
			completeExecution();
		}
	}

	function executeNextCommand() {
		var command = commandList.shift();
		if (command != null) {
			finishedCommandList[finishedCommandList.length] = command;
		}
		
		executeCommand(command);
	}

	function completeExecution() {
		dispatchTaskEvent(TaskEvent.TASK_COMPLETE);
		dispatchCompleteEvent(null);
	}

	function resetCommandList():Dynamic {
		if (finishedCommandList != null) {
			for (cmd in finishedCommandList) {
				if (Std.is(cmd, IResetable)) {
					cast(cmd, IResetable).reset();
				} else if (Std.is(cmd, ITask)) {
					cast(cmd, ITask).reset(true);
				}
			}
			
			commandList = finishedCommandList.concat(commandList);
		}
		return null;
	}

	function onCommandResult(event:OperationEvent) {
		if (event.target == currentCommand) {
			removeCommandListeners(cast event.target);
			dispatchTaskEvent(TaskEvent.AFTER_EXECUTE_COMMAND, cast event.target);
			executeNextCommand();
		}
	}

	function onCommandFault(event:OperationEvent) {
		if (event.target == currentCommand) {
			removeCommandListeners(cast event.target);
			
			var command:ICommand = null;
			
			if(Std.is(event.target, ICommand)) {
				command = cast(event.target, ICompositeCommand);
			}
			
			dispatchErrorEvent(command);
			dispatchTaskEvent(TaskEvent.TASK_ERROR, command);
			
			if (!failOnFault) {
				executeNextCommand();
			} else {
				currentCommand = null;
			}
		}
	}

	function addCommandListeners(asyncCommand:IOperation) {
		if (asyncCommand == null) {
			return;
		}
		
		asyncCommand.addCompleteListener(onCommandResult);
		asyncCommand.addErrorListener(onCommandFault);
		asyncCommand.addEventListener(TaskFlowControlEvent.BREAK, TaskFlowControlEvent_handler);
		asyncCommand.addEventListener(TaskFlowControlEvent.CONTINUE, TaskFlowControlEvent_handler);
		asyncCommand.addEventListener(TaskFlowControlEvent.EXIT, exit_handler);
		
		if (Std.is(asyncCommand, CompositeCommand)) {
			var compositeCommand:CompositeCommand = cast(asyncCommand, CompositeCommand);
			compositeCommand.addEventListener(CompositeCommandEvent.BEFORE_EXECUTE_COMMAND, redispatchCompositeCommand);
			compositeCommand.addEventListener(CompositeCommandEvent.AFTER_EXECUTE_COMMAND, redispatchCompositeCommand);
		}
		
		if (Std.is(asyncCommand, ITask)) {
			var task:ITask = cast(asyncCommand, ITask);
			task.addEventListener(TaskEvent.BEFORE_EXECUTE_COMMAND, redispatchTaskEvent);
			task.addEventListener(TaskEvent.AFTER_EXECUTE_COMMAND, redispatchTaskEvent);
		}
	}

	function removeCommandListeners(asyncCommand:IOperation) {
		if (asyncCommand == null) {
			return;
		}
		asyncCommand.removeCompleteListener(onCommandResult);
		asyncCommand.removeErrorListener(onCommandFault);
		asyncCommand.removeEventListener(TaskFlowControlEvent.BREAK, TaskFlowControlEvent_handler);
		asyncCommand.removeEventListener(TaskFlowControlEvent.CONTINUE, TaskFlowControlEvent_handler);
		asyncCommand.removeEventListener(TaskFlowControlEvent.EXIT, exit_handler);
		
		if (Std.is(asyncCommand, CompositeCommand)) {
			var compositeCommand:CompositeCommand = cast(asyncCommand, CompositeCommand);
			compositeCommand.removeEventListener(CompositeCommandEvent.BEFORE_EXECUTE_COMMAND, redispatchCompositeCommand);
			compositeCommand.removeEventListener(CompositeCommandEvent.AFTER_EXECUTE_COMMAND, redispatchCompositeCommand);
		}
		
		if (Std.is(asyncCommand, ITask)) {
			var task:ITask = cast(asyncCommand, ITask);
			task.removeEventListener(TaskEvent.BEFORE_EXECUTE_COMMAND, redispatchTaskEvent);
			task.removeEventListener(TaskEvent.AFTER_EXECUTE_COMMAND, redispatchTaskEvent);
		}
	}

	function redispatchTaskEvent(event:TaskEvent) dispatchEvent(event.clone());

	function TaskFlowControlEvent_handler(event:TaskFlowControlEvent) dispatchEvent(event.clone());

	function exit_handler(event:TaskFlowControlEvent) {
		TaskFlowControlEvent_handler(event);
		dispatchTaskEvent(TaskEvent.TASK_ABORTED);
	}

	function redispatchCompositeCommand(event:CompositeCommandEvent) {
		switch (event.type) {
			case CompositeCommandEvent.BEFORE_EXECUTE_COMMAND:
				dispatchTaskEvent(TaskEvent.BEFORE_EXECUTE_COMMAND, event.command);
			case CompositeCommandEvent.AFTER_EXECUTE_COMMAND:
				dispatchTaskEvent(TaskEvent.AFTER_EXECUTE_COMMAND, event.command);
		}
	}

	function dispatchTaskEvent(eventType:String, ?command:ICommand) dispatchEvent(new TaskEvent(eventType, this, command));
	
	function setIsClosed(value:Bool) isClosed = value;
	
}