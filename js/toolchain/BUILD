config_setting(
  name =   'k8',
  values = {'host_cpu': 'k8'},
)

config_setting(
  name =   'darwin',
  values = {'host_cpu': 'darwin'},
)

filegroup(
  name = 'node',
  srcs = select({
    'k8':     ['@nodejs_linux_x64//:node'],
    'darwin': ['@nodejs_darwin_x64//:node'],
  }),
  visibility = ['//visibility:public'],
)
