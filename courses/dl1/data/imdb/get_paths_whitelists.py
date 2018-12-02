from scipy.io import loadmat
import numpy as np
import operator

metadata = loadmat('imdb.mat')
metadata = metadata['imdb'][0, 0]

paths = metadata['full_path']
gender = metadata['gender']
is_single_person = np.isnan(metadata['second_face_score'])

# Unwrap objects
paths = np.array(list(map(operator.itemgetter(0), paths[0])))
gender = gender[0]
is_single_person = is_single_person[0]

paths = paths[is_single_person]
gender = gender[is_single_person]

idxs = paths.argsort()
paths = paths[idxs]
gender = gender[idxs]

is_nan_gender = ~np.isnan(gender)

paths = paths[is_nan_gender]
gender = gender[is_nan_gender]

paths_idxs = list(map(lambda s: s.startswith('06/'), paths))
paths_06 = paths[paths_idxs]

with open('blacklist_idxs_06.txt') as f:
    blacklist_idxs = list(map(lambda s: int(s.strip()), f.readlines()))

with open('whitelist_paths_06.txt', 'w') as f:
    whitelist_paths = [x for i, x in enumerate(sorted(paths_06)) if i not in blacklist_idxs]
    for p in whitelist_paths:
        f.write(p + '\n')

paths_idxs = list(map(lambda s: s.startswith('07/'), paths))
paths_07 = paths[paths_idxs]

with open('blacklist_idxs_07.txt') as f:
    blacklist_idxs = list(map(lambda s: int(s.strip()), f.readlines()))

with open('whitelist_paths_07.txt', 'w') as f:
    whitelist_paths = [x for i, x in enumerate(sorted(paths_07)) if i not in blacklist_idxs]
    for p in whitelist_paths:
        f.write(p + '\n')


