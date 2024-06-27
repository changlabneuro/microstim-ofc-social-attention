function [mua, sd] = signal_to_mua(signal, fs, varargin)

defaults = struct();
defaults.target_intervals = [];
defaults.ignore_intervals = true;
defaults.num_std_devs = 3;
defaults.remove_60hz = true;
defaults.filter_60hz_order = 2;
defaults.filter_60hz_type = 'designfilt';

params = shared_utils.general.parsestruct( defaults, varargin );

target_intervals = params.target_intervals;
ignore_intervals = params.ignore_intervals;

filt = mua_filter( signal, fs ...
  , 'remove_60hz', params.remove_60hz ...
  , 'filter_60hz_order', params.filter_60hz_order ...
  , 'filter_60hz_type', params.filter_60hz_type ...
);

[mua, sd] = detect_mua( filt, fs, target_intervals, ignore_intervals, params.num_std_devs );

end