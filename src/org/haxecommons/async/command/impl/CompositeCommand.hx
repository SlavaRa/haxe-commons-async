package org.haxecommons.async.command.impl;
import haxe.Log;
import org.haxecommons.async.command.CompositeCommandKind;
import org.haxecommons.async.command.event.CommandEvent;
import org.haxecommons.async.command.event.CompositeCommandEvent;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.command.ICompositeCommand;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.impl.AbstractProgressOperation;
import org.haxecommons.async.operation.IOperation;

/**
 * @author SlavaRa
 */
class CompositeCommand extends AbstractProgressOperation implements ICompositeCommand {

	public function new(?kind:CompositeCommandKind) {
		super();
		
		if(kind != null) {
			this.kind = kind;
		} else {
			this.kind = CompositeCommandKind.SEQUENCE;
		}
		
		commands = [];
	}
	
	public var failOnFault:Bool;
	public var commands(default, default):Array<ICommand>;
	public var kind(default, default):CompositeCommandKind;
	public var numCommands(get, null):Int;
	public var currentCommand(default, null):ICommand;
	
	function get_numCommands() return commands.length;

	public function execute():Dynamic {
		if (commands != null) {
			if(kind == CompositeCommandKind.SEQUENCE) {
				#if debug
				Log.trace('Executing composite command $this in sequence.');
				#end
				
				executeNextCommand();
			} else if(kind == CompositeCommandKind.PARALLEL) {
				#if debug
				Log.trace('Executing composite command $this in parallel.');
				#end
				
				executeCommandsInParallel();
			}
		} else {
			#if debug
			Log.trace("No commands were added to this composite command. Dispatching complete event.");
			#end
			
			dispatchCompleteEvent();
		}
		return null;
	}

	public function addCommand(command:ICommand):ICompositeCommand {
		#if debug
		if(command == null) throw "the command argument must not be null.";
		#end
		
		commands[commands.length] = command;
		total++;
		
		return this;
	}
	
	public function addCommandAt(command:ICommand, index:Int):ICompositeCommand {
		if (index < commands.length) {
			commands.insert(index, command);
			total++;
			return this;
		}
		
		return addCommand(command);
	}

	public function addOperation(operationClass:Class<Dynamic>, ?constructorArgs:Array<Dynamic>):ICompositeCommand {
		#if debug
		if(operationClass == null) throw "the operationClass argument must not be null.";
		#end
		
		return addCommand(GenericOperationCommand.createNew(operationClass, constructorArgs));
	}
	
	public function addOperationAt(operationClass:Class<Dynamic>, index:Int, ?constructorArgs:Array<Dynamic>):ICompositeCommand {
		return addCommandAt(GenericOperationCommand.createNew(operationClass, constructorArgs), index);
	}

	function executeCommand(command:ICommand) {
		#if debug
		if(command == null) throw "the command argument must not be null.";
		Log.trace("Executing command: " + command);
		#end
		
		currentCommand = command;
		
		addCommandListeners(cast(command, IOperation));
		
		dispatchEvent(new CommandEvent(CommandEvent.EXECUTE, command));
		dispatchBeforeCommandEvent(command);
		
		command.execute();
		
		if (!Std.is(command, IOperation)) {
			dispatchAfterCommandEvent(command);
		}
		
		if (Std.is(command, IOperation)) {
			#if debug
			Log.trace('Command $command is asynchronous. Waiting for response.');
			#end
		} else {
			progress++;
			dispatchProgressEvent();
			
			#if debug
			Log.trace('Command $command is synchronous and is executed. Trying to execute next command.');
			#end
			
			executeNextCommand();
		}
	}

	function executeNextCommand() {
		var command = commands.shift();
		
		var nextCommand = commands.shift();
		
		if (Std.is(command, ICommand)) {
			#if debug
			Log.trace('Executing next command $nextCommand. Remaining number of commands: ${commands.length}.');
			#end
			
			executeCommand(nextCommand);
		} else {
			#if debug
			Log.trace('All commands in $this have been executed. Dispatching \"complete\" event.');
			#end
			
			dispatchCompleteEvent();
		}
	}

	function removeCommand(asyncCommand:IOperation) {
		#if debug
		if(asyncCommand == null) throw "the asyncCommand argument must not be null";
		#end
		
		if (commands == null || !Std.is(asyncCommand, ICommand)) {
			return;
		}
		
		commands.remove(cast(asyncCommand, ICommand));
		
		if (commands.length == 0) {
			dispatchCompleteEvent();
		}
	}

	function executeCommandsInParallel() {
		var containsOperations = false;
		
		for (cmd in commands) {
			if (Std.is(cmd, IOperation)) {
				containsOperations = true;
				addCommandListeners(cast(cmd, IOperation));
			}
			
			dispatchBeforeCommandEvent(cmd);
			cmd.execute();
			
			if (!Std.is(cmd, IOperation)) {
				dispatchAfterCommandEvent(cmd);
			}
		}
		
		if (!containsOperations) {
			dispatchCompleteEvent();
		}
	}

	function addCommandListeners(?asyncCommand:IOperation) {
		if (asyncCommand == null) {
			return;
		}
		
		asyncCommand.addCompleteListener(onCommandResult);
		asyncCommand.addErrorListener(onCommandFault);
	}

	function removeCommandListeners(?asyncCommand:IOperation) {
		if (asyncCommand == null) {
			return;
		}
		
		asyncCommand.removeCompleteListener(onCommandResult);
		asyncCommand.removeErrorListener(onCommandFault);
	}

	function onCommandResult(event:OperationEvent) {
		progress++;
		dispatchProgressEvent();
		
		#if debug
		Log.trace('Asynchronous command ${event.target} returned result. Executing next command.');
		#end
		
		removeCommandListeners(cast(event.target, IOperation));
		dispatchAfterCommandEvent(cast(event.target, ICommand));
		
		if(kind == CompositeCommandKind.SEQUENCE) {
			executeNextCommand();
		} else if(kind == CompositeCommandKind.PARALLEL) {
			removeCommand(cast(event.target, IOperation));
		}
	}

	function onCommandFault(event:OperationEvent) {
		#if debug
		Log.trace('Asynchronous command ${event.target} returned error.');
		#end
		
		dispatchErrorEvent(event.error);
		removeCommandListeners(cast event.target);
		
		if(kind == CompositeCommandKind.SEQUENCE) {
			if (failOnFault) {
				currentCommand = null;
			} else {
				executeNextCommand();
			}
		} else if(kind == CompositeCommandKind.PARALLEL) {
			removeCommand(cast(event.target, IOperation));
		}
	}

	function dispatchAfterCommandEvent(command:ICommand) {
		#if debug
		if(command == null) throw "the command argument must not be null";
		#end
		
		dispatchEvent(new CompositeCommandEvent(CompositeCommandEvent.AFTER_EXECUTE_COMMAND, command));
	}

	function dispatchBeforeCommandEvent(command:ICommand) {
		#if debug
		if(command == null) throw "the command argument must not be null";
		#end
		
		dispatchEvent(new CompositeCommandEvent(CompositeCommandEvent.BEFORE_EXECUTE_COMMAND, command));
	}
}