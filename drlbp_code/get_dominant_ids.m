function dominant_ids = get_dominant_ids(lbp_hf_trains, frac_thresh)

pattern_sum = sum(lbp_hf_trains,1);
[sorted_count, sorted_ids] = sort(pattern_sum,'descend');

cumm_count = cumsum(sorted_count);
cumm_count = cumm_count./sum(sorted_count);

over_threshold = find(cumm_count > frac_thresh);
threshold_index = over_threshold(1);
dominant_ids = sorted_ids(1:threshold_index);