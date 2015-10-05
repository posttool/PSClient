# psclient
Flash based component library

Documentation is very lite. Take a look at the main package 
[com.pagesociety.ux](https://github.com/posttool/psclient/tree/master/src/com/pagesociety/ux).
The interfaces explain some aspects of the design. The
[IComponent](https://github.com/posttool/psclient/blob/master/src/com/pagesociety/ux/IComponent.as) 
extends the flash.IEventDispatcher. A set of components that implement this are in 
[com.pagesociety.ux.components](https://github.com/posttool/psclient/tree/master/src/com/pagesociety/ux/components). 
Components are constructed with their parent. Many container implementations are available in [com.pagesociety.ux.component.container](https://github.com/posttool/psclient/tree/master/src/com/pagesociety/ux/component/container).

A [sample application](https://github.com/posttool/pscms/blob/master/com/pagesociety/cms/CMS2.as)
is available in another repo. It is a CMS that is built from markup. 


