package org.haxecommons.async.operation.impl;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;


/**
 * @author SlavaRa
 */
class LoadURLOperation extends AbstractProgressOperation {

	public function new(url:String, ?dataFormat:String, ?request:URLRequest) {
		#if debug
		if(url == null || url.length == 0) throw "url argument must not be null or empty";
		#end
		
		super();
		
		if (dataFormat == null || dataFormat.length == 0) {
			dataFormat = URLLoaderDataFormat.TEXT;
		}
		
		createLoader(url, dataFormat, request);
	}

	public var url(default, null):String;
	
	var _urlLoader:URLLoader;

	public override function toString():String return "[LoadURLOperation(url:'" + url + "')]";
	
	function createLoader(url:String, dataFormat:String, request:URLRequest) {
		this.url = url;
		
		_urlLoader = new URLLoader();
		_urlLoader.dataFormat = dataFormat;
		_urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
		_urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderErrorHandler);
		_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderErrorHandler);
		
		var request = (request == null) ? new URLRequest(url) : request;
		_urlLoader.load(request);
	}

	function progressHandler(event:ProgressEvent) {
		progress = event.bytesLoaded;
		total = event.bytesTotal;
		dispatchProgressEvent();
	}

	function removeEventListeners() {
		if (_urlLoader == null) {
			return;
		}
		
		_urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
		_urlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		_urlLoader = null;
	}

	function urlLoaderCompleteHandler(?event:Event) {
		result = _urlLoader.data;
		removeEventListeners();
		dispatchCompleteEvent();
	}

	function urlLoaderErrorHandler(?event:ErrorEvent) {
		removeEventListeners();
		dispatchErrorEvent(event.text);
	}
}