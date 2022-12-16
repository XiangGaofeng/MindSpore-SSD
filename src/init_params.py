from mindspore.common.initializer import initializer, TruncatedNormal

def init_net_param(network, initialize_mode='TruncatedNormal'):
    """Init the parameters in net."""
    params = network.trainable_params()
    for p in params:
        if 'beta' not in p.name and 'gamma' not in p.name and 'bias' not in p.name:
            if initialize_mode == 'TruncatedNormal':
                p.set_data(initializer(TruncatedNormal(0.02), p.data.shape, p.data.dtype))
            else:
                p.set_data(initialize_mode, p.data.shape, p.data.dtype)


def load_backbone_params(network, param_dict):
    """Init the parameters from pre-train model, default is mobilenetv2."""
    for _, param in network.parameters_and_names():
        param_name = param.name.replace('network.backbone.', '')
        name_split = param_name.split('.')
        if 'features_1' in param_name:
            param_name = param_name.replace('features_1', 'features')
        if 'features_2' in param_name:
            param_name = '.'.join(['features', str(int(name_split[1]) + 14)] + name_split[2:])
        if param_name in param_dict:
            param.set_data(param_dict[param_name].data)


def filter_checkpoint_parameter_by_list(param_dict, filter_list):
    """remove useless parameters according to filter_list"""
    for key in list(param_dict.keys()):
        for name in filter_list:
            if name in key:
                print("Delete parameter from checkpoint: ", key)
                del param_dict[key]
                break
