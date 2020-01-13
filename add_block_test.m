function net = add_block_test(net, opts, id, h, w, in, out, stride, pad,batchOn,ReluOn)
% --------------------------------------------------------------------
info = vl_simplenn_display(net) ;
fc = (h == info.dataSize(1,end) && w == info.dataSize(2,end)) ;
if fc
    name = 'fc' ;
else
    name = 'conv' ;
end
convOpts = {'CudnnWorkspaceLimit', opts.cudnnWorkspaceLimit} ;
net.layers{end+1} = struct('type', 'conv', 'name', sprintf('%s%s', name, id), ...
    'weights', {{init_weight_test(opts, h, w, in, out, 'single'), zeros(out, 1, 'single')}}, ...
    'stride', stride, ...
    'pad', pad, ...
    'dilate', 1, ...
    'learningRate', [1 2], ...
    'weightDecay', [opts.weightDecay 0], ...
    'opts', {convOpts}) ;
if (opts.batchNormalization)&&batchOn
    net.layers{end+1} = struct('type', 'bnorm', 'name', sprintf('bn%s',id), ...
        'weights', {{ones(out, 1, 'single'), zeros(out, 1, 'single'), zeros(out, 2, 'single')}}, ...
        'learningRate', [2 1 0.05], ...
        'weightDecay', [0 0]) ;
end
if ReluOn
net.layers{end+1} = struct('type', 'relu', 'name', sprintf('relu%s',id)) ;
end 