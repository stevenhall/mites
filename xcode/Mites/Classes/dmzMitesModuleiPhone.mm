#import "dmzAppDelegate.h"
#include <dmzLuaModule.h>
#include "dmzMitesModuleiPhone.h"
#include <dmzObjectAttributeMasks.h>
#include <dmzObjectModule.h>
#include <dmzRuntimePluginFactoryLinkSymbol.h>
#include <dmzRuntimePluginInfo.h>
#import "MainViewController.h"
#import "MainView.h"
#import "RootViewController.h"


dmz::MitesModuleiPhone *localInstance (0);
dmz::MitesModuleiPhone *dmz::MitesModuleiPhone::_instance (0);


dmz::MitesModuleiPhone::MitesModuleiPhone (const PluginInfo &Info, Config &local) :
      Plugin (Info),
      ObjectObserverUtil (Info, local),
      iPhoneModuleCanvas (Info),
      _log (Info),
      _navigationController (0),
      _rootViewController (0),
      _itemTable (),
      _arena (0),
      _mitesHandle (0),
      _chipsHandle (0),
      _speedHandle (0),
      _waitHandle (0),
      _lua (0) {

   if (!_instance) {
      
      _instance = this;
      localInstance = _instance;
   }

   _rootViewController = [[RootViewController alloc] 
      initWithNibName:@"RootView" bundle:nil];
         
   _navigationController = [[UINavigationController alloc]
      initWithRootViewController:_rootViewController];

   dmzAppDelegate *app = [dmzAppDelegate shared_dmz_app];

   app.window.backgroundColor = [UIColor blackColor];
   app.rootController = _navigationController;      

   _navigationController.navigationBarHidden = YES;
         
   _init (local);
}


dmz::MitesModuleiPhone::~MitesModuleiPhone () {

   _itemTable.clear ();
   
   [_rootViewController release];
   [_navigationController release];
   
   if (localInstance) {
      
      _instance = 0;
      localInstance = 0;
   }
}


dmz::MitesModuleiPhone *
dmz::MitesModuleiPhone::get_instance () { return _instance; }


// Plugin Interface
void
dmz::MitesModuleiPhone::update_plugin_state (
      const PluginStateEnum State,
      const UInt32 Level) {

   if (State == PluginStateInit) {

   }
   else if (State == PluginStateStart) {

   }
   else if (State == PluginStateStop) {

   }
   else if (State == PluginStateShutdown) {

   }
}


void
dmz::MitesModuleiPhone::discover_plugin (
      const PluginDiscoverEnum Mode,
      const Plugin *PluginPtr) {

   if (Mode == PluginDiscoverAdd) {

      if (!_lua) { _lua = dmz::LuaModule::cast (PluginPtr); }
   }
   else if (Mode == PluginDiscoverRemove) {

      if (_lua && (_lua == dmz::LuaModule::cast (PluginPtr))) { _lua = 0; }
   }
}


// Object Observer Interface
void
dmz::MitesModuleiPhone::update_object_counter (
      const UUID &Identity,
      const Handle ObjectHandle,
      const Handle AttributeHandle,
      const Int64 Value,
      const Int64 *PreviousValue) {
   
   _arena = ObjectHandle;
   
   if (AttributeHandle == _mitesHandle) {
         
//      _ui.MitesSlider->setValue ((int)Value);
   }
   else if (AttributeHandle == _chipsHandle) {
         
//      _ui.ChipsSlider->setValue ((int)Value);
   }
}


void
dmz::MitesModuleiPhone::update_object_scalar (
      const UUID &Identity,
      const Handle ObjectHandle,
      const Handle AttributeHandle,
      const Float64 Value,
      const Float64 *PreviousValue) {
   
   _arena = ObjectHandle;
   
   if (AttributeHandle == _speedHandle) {
      
//      _ui.SpeedSlider->setValue ((int)Value / 100);
   }
   else if (AttributeHandle == _waitHandle) {
      
//      _ui.WaitSlider->setValue ((int)Value);
   }
}


// iPhoneModuleCanvas Interface
UIView *
dmz::MitesModuleiPhone::get_view () const {
   
   //   MainViewController *mainViewController = _rootViewController.mainViewController;
   
   return (UIView *)_rootViewController.mainViewController.mainView.canvas;
}


dmz::Boolean
dmz::MitesModuleiPhone::add_item (const Handle ObjectHandle, UIView *item) {
   
   Boolean retVal (False);
   
   if (item) {
      
      retVal = _itemTable.store (ObjectHandle, item);
      
      if (retVal) {
         
         [item retain];
         
         [_rootViewController.mainViewController.mainView.canvas addSubview:item];
      }
   }
   
   return retVal;
}


UIView *
dmz::MitesModuleiPhone::lookup_item (const Handle ObjectHandle) {
   
   UIView *item (_itemTable.lookup (ObjectHandle));
   return item;
}


UIView *
dmz::MitesModuleiPhone::remove_item (const Handle ObjectHandle) {
   
   UIView *item (_itemTable.remove (ObjectHandle));
   
   if (item) {
      
      [item removeFromSuperview];
      [item release];
   }
   
   return item;
}


// class Interface

void
dmz::MitesModuleiPhone::set_mites (const Int64 Value) {

   dmz::ObjectModule *objMod (get_object_module ());
   
   if (_arena && objMod) {
   
      objMod->store_counter (_arena, _mitesHandle, Value);
   }
}


dmz::Int64
dmz::MitesModuleiPhone::get_mites () {
 
   dmz::Int64 retVal (0);
   
   ObjectModule *objMod  (get_object_module ());
   
   if (_arena && objMod) {
    
      objMod->lookup_counter (_arena, _mitesHandle, retVal);
   }
   
   return retVal;
}



void
dmz::MitesModuleiPhone::set_chips (const Int64 Value) {
   
   dmz::ObjectModule *objMod (get_object_module ());
   
   if (_arena && objMod) {
      
      objMod->store_counter (_arena, _chipsHandle, Value);
   }
}


dmz::Int64
dmz::MitesModuleiPhone::get_chips () {
   
   Int64 retVal (0);
   
   ObjectModule *objMod  (get_object_module ());
   
   if (_arena && objMod) {
      
      objMod->lookup_counter (_arena, _chipsHandle, retVal);
   }
   
   return retVal;
}


void
dmz::MitesModuleiPhone::set_speed (const Float64 Value) {
   
   ObjectModule *objMod (get_object_module ());
   
   if (_arena && objMod) {
      
      objMod->store_scalar (_arena, _speedHandle, Value * 100.0);
   }
}


dmz::Float64
dmz::MitesModuleiPhone::get_speed () {
   
   Float64 retVal (0);
   
   ObjectModule *objMod  (get_object_module ());
   
   if (_arena && objMod) {
      
      objMod->lookup_scalar (_arena, _speedHandle, retVal);
      
      retVal = retVal / 100.0;
   }
   
   return retVal;
}


void
dmz::MitesModuleiPhone::set_wait (const Float64 Value) {
   
   ObjectModule *objMod (get_object_module ());
   
   if (_arena && objMod) {
      
      objMod->store_scalar (_arena, _waitHandle, Value);
   }
}


dmz::Float64
dmz::MitesModuleiPhone::get_wait () {
   
   Float64 retVal (0);
   
   ObjectModule *objMod  (get_object_module ());
   
   if (_arena && objMod) {
      
      objMod->lookup_scalar (_arena, _waitHandle, retVal);
   }
   
   return retVal;
}


void
dmz::MitesModuleiPhone::reset_lua () {
   
   if (_lua) { _lua->reset_lua (); }
}



void
dmz::MitesModuleiPhone::_init (Config &local) {

   _mitesHandle = activate_object_attribute ("Mites", ObjectCounterMask);
   _chipsHandle = activate_object_attribute ("Chips", ObjectCounterMask);
   _speedHandle = activate_object_attribute ("Speed", ObjectScalarMask);
   _waitHandle = activate_object_attribute ("Wait", ObjectScalarMask);   
}


extern "C" {

DMZ_PLUGIN_FACTORY_LINK_SYMBOL dmz::Plugin *
create_dmzMitesModuleiPhone (
      const dmz::PluginInfo &Info,
      dmz::Config &local,
      dmz::Config &global) {

   return new dmz::MitesModuleiPhone (Info, local);
}

};
