

var fb_everything_ready = false;
var fb_inited = false;
var fb_api_key;
var fb_channel_path;

function fb_swf_js_init(canvas_url, hosted_url, api_key, channel_path, as_swf_name, s3bucket, swf)
{
	fb_api_key = api_key;
	fb_channel_path = channel_path;
		
	var flashvars = { 
			s3bucket: s3bucket,
			resourceRootUrl: hosted_url+"/", 
			as_swf_name: as_swf_name,
			fb_api_key: api_key,
			swf: swf
	};
	var params = { wmode: "transparent", allowscriptaccess: "always" };
	var attributes = { id: as_swf_name };
	swfobject.embedSWF("static/Bootstrap.swf", as_swf_name, "760", "1000", "9.0.0", "static/js/swfobject/expressInstall.swf", flashvars, params, attributes);
	//swfmacmousewheel.registerObject(attributes.id);
}



function fb_init()
{
	fb_inited = true;
	FB_RequireFeatures(["Api","Connect"], function()
	{	
		FB.Facebook.init(fb_api_key, fb_channel_path, {"ifUserConnected":FB_connected, "ifUserNotConnected":FB_NOT_connected});
	});
}

function FB_NOT_connected() 
{
	//alert("NOT CONNECTED");
}


function FB_connected(o) 
{
	// permission conditional?
	on_fb_everything_ready(o);
}

function fb_get_session_key()
{
	return FB.Facebook.apiClient.get_session().session_key; 
}


function fb_disconnect()
{
	FB.Connect.logout(function(){ get_swf(as_swf_name).fb_on_disconnect(); })
}

function on_fb_everything_ready(o)
{
	fb_everything_ready = true;
	get_swf(as_swf_name).fb_on_got_session();
}


// check if the user is there...
function check_fb_user()
{
	FB.Facebook.apiClient.users_isAppUser(function(result,exception)
	{
		if (result != null)
		{
			var sequencer 			= new FB.BatchSequencer();
			var has_publish 		= FB.Facebook.apiClient.users_hasAppPermission("publish_stream",sequencer);
//			var has_read 			= FB.Facebook.apiClient.users_hasAppPermission("read_stream",sequencer);
			var has_offline_access 	= FB.Facebook.apiClient.users_hasAppPermission("offline_access",sequencer);
			sequencer.execute(function() 
			{
				//var all = has_publish.result && has_offline_access.result; //&& has_read.result
				//if (all)
					on_fb_everything_ready();
			});
		}
	});
}



///// require perms

function fb_require_session()
{
//	var callback = on_fb_session_require_perms;
	var callback = on_fb_everything_ready;
	FB.Facebook.apiClient.users_isAppUser(function(result,exception)
	{
		var in_facebook = window.location.search.indexOf("fb_sig_in_iframe")!=-1;
		if (result == null)
		{
			if(in_facebook)
				window.parent.location.href = 'http://www.facebook.com/login.php?v=1.0&api_key='+api_key+'&next='+canvas_url+'&canvas=';
			else
				FB.Connect.requireSession(function(exception) { callback(); });
		}
		else
		{
			callback();
		}
	});

	//FB.Connect.showPermissionDialog("publish_stream,read_stream,offline_access");


}

function on_fb_session_require_perms()
{
	var sequencer 			= new FB.BatchSequencer();
	var has_publish 		= FB.Facebook.apiClient.users_hasAppPermission("publish_stream",sequencer);
	//var has_read 			= FB.Facebook.apiClient.users_hasAppPermission("read_stream",sequencer);
	var has_offline_access 	= FB.Facebook.apiClient.users_hasAppPermission("offline_access",sequencer);
	sequencer.execute(function() 
	{
		var all = has_publish.result && has_offline_access.result ; //&& has_read.result 
		if (all)
			on_fb_everything_ready();
		else
		{
			FB.Connect.showPermissionDialog("publish_stream,read_stream,offline_access", on_fb_everything_ready);
		}
	});
}











// doing stuff
function fb_publishToStream(href,images)
{
	var msg = "This is something about a template";
	var media = new Array();
	for (var i=0; i<images.length; i++)
	{
		var o =  
		     { 
		  		type: 'image', 
		  		src:  images[i], 
		  		href: href
		  	 };
		media[media.length] = o;
	}
	var attachment = {
		  name: 		"Updated Portfolio",
		  href: 		href,
		  caption: 		"caption",
		  description:	"This is the description",	  
		  media: 		media
	};
	FB.Connect.streamPublish(msg, attachment, null, null, "What's up?", on_fb_stream_publish, true);
}

function on_fb_stream_publish()
{
	//
}











/// utility
function get_swf(movieName) {
    if (navigator.appName.indexOf("Microsoft") != -1) {
        return window[movieName];
    } else {
        return document[movieName];
    }
}