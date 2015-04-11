import massive.munit.TestSuite;
import org.haxecommons.async.command.CompositeCommandKindTest;
import org.haxecommons.async.command.CompositeCommandTest;
import org.haxecommons.async.command.GenericOperationCommandTest;
import org.haxecommons.async.operation.OperationHandlerTest;
import org.haxecommons.async.operation.OperationQueueTest;
import org.haxecommons.async.task.command.FunctionCommandTest;
import org.haxecommons.async.task.command.FunctionProxyCommandTest;
import org.haxecommons.async.task.command.PauseCommandTest;
import org.haxecommons.async.task.command.TaskCommandTest;
import org.haxecommons.async.task.impl.CountProviderTest;
import org.haxecommons.async.task.impl.ForBlockTest;
import org.haxecommons.async.task.impl.FunctionConditionProviderTest;
import org.haxecommons.async.task.impl.FunctionCountProviderTest;
import org.haxecommons.async.task.impl.IfElseBlockTest;
import org.haxecommons.async.task.impl.TaskTest;
import org.haxecommons.async.task.impl.WhileBlockTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();
		add(org.haxecommons.async.command.CompositeCommandKindTest);
		add(org.haxecommons.async.command.CompositeCommandTest);
		add(org.haxecommons.async.command.GenericOperationCommandTest);
		add(org.haxecommons.async.operation.OperationHandlerTest);
		add(org.haxecommons.async.operation.OperationQueueTest);
		add(org.haxecommons.async.task.command.FunctionCommandTest);
		add(org.haxecommons.async.task.command.FunctionProxyCommandTest);
		add(org.haxecommons.async.task.command.PauseCommandTest);
		add(org.haxecommons.async.task.command.TaskCommandTest);
		add(org.haxecommons.async.task.impl.CountProviderTest);
		add(org.haxecommons.async.task.impl.ForBlockTest);
		add(org.haxecommons.async.task.impl.FunctionConditionProviderTest);
		add(org.haxecommons.async.task.impl.FunctionCountProviderTest);
		add(org.haxecommons.async.task.impl.IfElseBlockTest);
		add(org.haxecommons.async.task.impl.TaskTest);
		add(org.haxecommons.async.task.impl.WhileBlockTest);
	}
}