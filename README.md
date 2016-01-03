# common_utils cookbook

This cookbook provides utility libraries, resources and recipes which are used 
to extend certain workflows. These are generally chef or workflow specific and 
will not directly alter the state of a node.

# Requirements

This cookbook requires *Chef 12.5.0* or later.

# Platform

Any

# Documentation

The source code contains most of the more specific documentation.

# Common::Environments

Chef PolicyFile does not support node environments or node roles and therefore does not provide a mechanism to share data which is more global in nature. 

To work around this, we introduce the `common_environment` LWRP which will attempt to load a data_bag_item and merge into it into the node attributes at either the `environment` or `role` precedence levels during compile time (by default).

# Common::Namespaces

An alternative to the above mentioned data_bag_item environment workflow, is to namespace attributes under a given environment attribute and then either access them directly or overlay them on top of the node attributes. 

To provide for this workflow, we introduce the `common_namespace` LWRP which will attempt to fetch namespaced attributes and overlay them at either the `environment` or `role` precedence levels during compile time (by default). 

This would therefore allow us to store attributes for all "environments" in a single location. A very brief and fairly stupid example below demonstrates what this might look like. 

```json
{
  "_production": {
    "enable_debug": "noneofthethings"
  },
  "_development": {
    "enable_debug": "someofthethings"
  },
  "common": {
    "namespaces": {
      "active": ["production"],
      "prefix": "_"
    }
  },
  "enable_debug": "allthethings"
}
```

# Chef::DataBagItem

In addition to the `common_namespace` LWRP, the standard DataBagItem class is extended with the `namespaced` method which returns the standard data_bag_item content with the current namespaces overlayed. 

# Chef::Resource

The Resource base class is extended so as to provide the `load_properties` method which is used to set resource properties from a hash or attributes. 

# TODO

Add mawr (real) tests.

