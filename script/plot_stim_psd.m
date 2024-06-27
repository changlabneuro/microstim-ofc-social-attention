data_root = '/Volumes/external3/data/changlab/siqi';

psd_mats = shared_utils.io.findmat( fullfile(data_root, 'stim/intermediates/stim_psd') );
[psd, psd_labs, psd_f, psd_t] = bfw.load_time_frequency_measure(psd_mats ...
  , 'load_func', @load ...
  , 'get_data_func', @(x) x.psd ...
  , 'get_labels_func', @(x) fcat.from(x.psd_labs, x.psd_cats) ...
  , 'get_freqs_func', @(x) x.psd_f ...
  , 'get_time_func', @(x) x.psd_t ...
);

%%

[I, pl2_fname] = findall( psd_labs, 'pl2_filename' );
regs = { 'dmpfc', 'ofc', 'accg' };
matchi = cellfun( @(x) find(arrayfun(@(y) contains(x, y, 'ignorecase', 1), regs)), pl2_fname );
pl2_regs = regs(matchi);
for i = 1:numel(I)
  addsetcat( psd_labs, 'region', pl2_regs{i}, I{i} );
end

%%

t_ind = psd_t >= 200;
pl = plotlabeled.make_spectrogram( psd_f, psd_t(t_ind) );
axs = pl.imagesc( psd(:, :, t_ind), psd_labs, {'region', 'stim_type'} );