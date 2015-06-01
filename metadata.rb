name              "squid_extend"
maintainer        "Sebastian Johnsson"
maintainer_email  "sebastian@agiley.se"
license           "Private"
description       "Wrapper cookbook for the Squid cookbook"
version           "0.0.1"

recipe "squid_extend",                  "Default recipe"
recipe "squid_extend::auth",            "Recipe used to configure auth using htpasswd and basic_ncsa_auth"

%w{ ubuntu }.each do |os|
  supports os
end

%w{ ohai squid htpasswd }.each do |cb|
  depends cb
end