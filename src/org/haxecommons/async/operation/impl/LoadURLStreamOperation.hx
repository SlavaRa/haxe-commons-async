package org.haxecommons.async.operation.impl;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.net.URLStream;

/**
 * @author SlavaRa
 */
class LoadURLStreamOperation {

	private static var TEXT_FIELD_NAME = 'text';
	
	public function new(url:String) {
		#if debug
		if(url == null || url.length == 0) throw "url argument must not be null or empty";
		#end
		
		super();
		
		init(url);
	}

	public var urlStream(default, null):URLStream;
	
	function init(url:String) {
		_urlStream = new URLStream();
		_urlStream.addEventListener(Event.COMPLETE, urlStreamCompleteHandler, false, 0, true);
		_urlStream.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
		_urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlStreamErrorHandler, false, 0, true);
		_urlStream.addEventListener(IOErrorEvent.IO_ERROR, urlStreamErrorHandler, false, 0, true);
		
		setTimeout(load, 0, url);
	}

	function load(url:String) _urlStream.load(new URLRequest(url));

	function urlStreamCompleteHandler(event:Event) {
		removeEventListeners();
		dispatchCompleteEvent();
	}

	function progressHandler(event:ProgressEvent) {
		progress = event.bytesLoaded;
		total = event.bytesTotal;
		dispatchProgressEvent();
	}

	function urlStreamErrorHandler(event:Event) {
		removeEventListeners();
		dispatchErrorEvent(event[TEXT_FIELD_NAME]);
	}
	
	function removeEventListeners() {
		if (_urlStream == null) {
			return;
		}
		
		_urlStream.removeEventListener(Event.COMPLETE, completeHandler);
		_urlStream.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		_urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		_urlStream = null;
	}
}