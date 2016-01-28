
# Hash of attributes to delete at the end of the chef run. 
# ```json
# {
#   "common":{
#     "blacklist": {
#       "my_password": true,
#       "deeply.nested.password": true,
#       "meh.show.this.one": false
#     }
#   }
# }
# ```
#
default[:common][:blacklist] = {}

