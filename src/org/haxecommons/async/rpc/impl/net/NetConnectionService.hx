package org.haxecommons.async.rpc.impl.net;
import org.haxecommons.async.operation.impl.NetConnectionOperation;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.rpc.IService;

/**
 * @author SlavaRa
 */
class NetConnectionService implements IService {

	public function new(?netConnection:NetConnection) this.netConnection = netConnection;
	
	public var netConnection(default, default):NetConnection;
	
	public function call(methodName:String, parameters):IOperation {
		#if debug
		if(netConnection == null) throw "the netConnection argument must not be null";
		#end
		
		return new NetConnectionOperation(netConnection, methodName, parameters);
	}
	
}